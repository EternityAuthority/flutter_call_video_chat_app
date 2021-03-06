import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'random_string.dart';

enum SignalingState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateAnswered,
  CallStateConnected,
  CallStateBye,
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

/*
 * callbacks for Signaling API.
 */
typedef void SignalingStateCallback(SignalingState state);
typedef void StreamStateCallback(MediaStream stream);
typedef void OtherEventCallback(dynamic event);
typedef void DataChannelMessageCallback(
    RTCDataChannel dc, RTCDataChannelMessage data);
typedef void DataChannelCallback(RTCDataChannel dc);

bool answered;
SignalingState state;

class Signaling {
  String _selfId = randomNumeric(6);
  var _socket;
  var _sessionId;
  var _host;
  var _port = 4443;
  var _displayName;
  var _peerConnections = new Map<String, RTCPeerConnection>();
  var _dataChannels = new Map<String, RTCDataChannel>();
  MediaStream _localStream;
  List<MediaStream> _remoteStreams;
  SignalingStateCallback onStateChange;
  StreamStateCallback onLocalStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;
  OtherEventCallback onPeersUpdate;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;
  var controller = new StreamController.broadcast();
  Stream get onAnswered => controller.stream;
  final BuildContext context;

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      /*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
       */
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  final Map<String, dynamic> _constraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  Signaling(this._host, this._displayName, this.context);

  close() {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }

    _peerConnections.forEach((key, pc) {
      pc.close();
    });
    if (_socket != null) _socket.close();
  }

  void switchCamera() {
    if (_localStream != null) {
      _localStream.getVideoTracks()[0].switchCamera();
    }
  }

  void invite(String peerId, String media, useScreen) {
    this._sessionId = this._selfId + '-' + peerId;

    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateNew);
      state = SignalingState.CallStateNew;
    }

    _createPeerConnection(peerId, media, useScreen).then((pc) {
      _peerConnections[peerId] = pc;
      if (media == 'data') {
        _createDataChannel(peerId, pc);
      }
      _createOffer(peerId, pc, media);
    });
  }

  void bye() {
    _send('bye', {
      'session_id': this._sessionId,
      'from': this._selfId,
    });
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateBye);
      state = SignalingState.CallStateBye;
    }
  }

  void onMessage(message) async {
    Map<String, dynamic> mapData = message;
    var data = mapData['data'];

    switch (mapData['type']) {
      case 'peers':
        {
          List<dynamic> peers = data;
          if (this.onPeersUpdate != null) {
            Map<String, dynamic> event = new Map<String, dynamic>();
            event['self'] = _selfId;
            event['peers'] = peers;
            this.onPeersUpdate(event);
          }
        }
        break;
      case 'offer':
        {
          var id = data['from'];
          var description = data['description'];
          var media = data['media'];
          var sessionId = data['session_id'];
          this._sessionId = sessionId;

          /* if (this.onStateChange != null) {
            this.onStateChange(SignalingState.CallStateRinging);
            state = SignalingState.CallStateRinging;
          } */

          if (data == 'true') {
            _createPeerConnection(id, media, false).then((pc) {
              _peerConnections[id] = pc;
              pc.setRemoteDescription(new RTCSessionDescription(
                  description['sdp'], description['type']));
              _createAnswer(id, pc, media);
              controller.add('event');
            });
          }

          //  answerMethod(id, media, description);
        }
        break;
      case 'answer':
        {
          var id = data['from'];
          var description = data['description'];

          var pc = _peerConnections[id];
          if (pc != null) {
            pc.setRemoteDescription(new RTCSessionDescription(
                description['sdp'], description['type']));
          }
        }
        break;
      case 'candidate':
        {
          var id = data['from'];
          var candidateMap = data['candidate'];
          var pc = _peerConnections[id];
          var description = data['description'];
          var media = data['media'];

          if (pc != null) {
            RTCIceCandidate candidate = new RTCIceCandidate(
                candidateMap['candidate'],
                candidateMap['sdpMid'],
                candidateMap['sdpMLineIndex']);
            pc.addCandidate(candidate);
          }
          if (data == 'true') {
            _createPeerConnection(id, media, false).then((pc) {
              _peerConnections[id] = pc;
              pc.setRemoteDescription(new RTCSessionDescription(
                  description['sdp'], description['type']));
              _createAnswer(id, pc, media);
              controller.add('event');
            });
          }
        }
        break;
      case 'leave':
        {
          var id = data;
          _peerConnections.remove(id);
          _dataChannels.remove(id);

          if (_localStream != null) {
            _localStream.dispose();
            _localStream = null;
          }

          var pc = _peerConnections[id];
          if (pc != null) {
            pc.close();
            _peerConnections.remove(id);
          }
          this._sessionId = null;
          if (this.onStateChange != null) {
            this.onStateChange(SignalingState.CallStateBye);
            state = SignalingState.CallStateBye;
          }
        }
        break;
      case 'bye':
        {
          var to = data['to'];
          var sessionId = data['session_id'];
          print('bye: ' + sessionId);
          this._sessionId = null;
          this.onStateChange(SignalingState.CallStateBye);
          state = SignalingState.CallStateBye;

          if (_localStream != null) {
            _localStream.dispose();
            _localStream = null;
          }

          var pc = _peerConnections[to];
          if (pc != null) {
            pc.close();
            _peerConnections.remove(to);
          }

          var dc = _dataChannels[to];
          if (dc != null) {
            dc.close();
            _dataChannels.remove(to);
          }
        }
        break;
      case 'keepalive':
        {
          print('keepalive response!');
        }
        break;
      default:
        break;
    }
  }

  void answerMethod(
    id,
    media,
    description,
  ) {
    StreamSubscription subscription;
    subscription = onAnswered.listen((data) {
      print("DataReceived: " + data);
      if (data == 'true') {
        _createPeerConnection(id, media, false).then((pc) {
          _peerConnections[id] = pc;
          pc.setRemoteDescription(new RTCSessionDescription(
              description['sdp'], description['type']));
          _createAnswer(id, pc, media);
          controller.add('event');
        });
      }

      // Add 5 seconds delay
      // It will call onPause function passed on StreamController constructor
      subscription.pause(Future.delayed(const Duration(seconds: 5)));
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print("Some Error");
    });
  }

  Future<WebSocket> _connectForSelfSignedCert(String host, int port) async {
    try {
      Random r = new Random();
      String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));
      SecurityContext securityContext = new SecurityContext();
      HttpClient client = HttpClient(context: securityContext);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        //print('Allow self-signed certificate => $host:$port. ');
        return true;
      };

      HttpClientRequest request = await client.getUrl(
          Uri.parse('https://$host:$port/ws')); // form the correct url here
      request.headers.add('Connection', 'Upgrade');
      request.headers.add('Upgrade', 'websocket');
      request.headers.add(
          'Sec-WebSocket-Version', '13'); // insert the correct version here
      request.headers.add('Sec-WebSocket-Key', key.toLowerCase());

      HttpClientResponse response = await request.close();
      // ignore: close_sinks
      Socket socket = await response.detachSocket();
      var webSocket = WebSocket.fromUpgradedSocket(
        socket,
        protocol: 'signaling',
        serverSide: false,
      );

      return webSocket;
    } catch (e) {
      throw e;
    }
  }

  void connect() async {
    try {
      /*
      var url = 'ws://$_host:$_port';
      _socket = await WebSocket.connect(url);
      */
      _socket = await _connectForSelfSignedCert(_host, _port);

      if (this.onStateChange != null) {
        this.onStateChange(SignalingState.ConnectionOpen);
        state = SignalingState.ConnectionOpen;
      }

      _socket.listen((data) {
        print('Recivied data: ' + data);
        JsonDecoder decoder = new JsonDecoder();
        this.onMessage(decoder.convert(data));
      }, onDone: () {
        print('Closed by server!');
        if (this.onStateChange != null) {
          this.onStateChange(SignalingState.ConnectionClosed);
          state = SignalingState.ConnectionClosed;
        }
      });

      _send('new', {
        'name': _displayName,
        'id': _selfId,
        'user_agent':
            'flutter-webrtc/' + Platform.operatingSystem + '-plugin 0.0.1'
      });
    } catch (e) {
      print(e.toString());
      if (this.onStateChange != null) {
        this.onStateChange(SignalingState.ConnectionError);
        state = SignalingState.ConnectionError;
      }
    }
  }

  Future<MediaStream> createStream(media, useScreen) async {
    //  print();
    //print(MediaQuery.of(context).size.height);
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '480', // Provide your own width, height and frame rate here
          'minHeight': '640',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    MediaStream stream = useScreen
        ? await navigator.getDisplayMedia(mediaConstraints)
        : await navigator.getUserMedia(mediaConstraints);
    if (this.onLocalStream != null) {
      this.onLocalStream(stream);
    }
    return stream;
  }

  _createPeerConnection(id, media, useScreen) async {
    if (media != 'data') _localStream = await createStream(media, useScreen);
    RTCPeerConnection pc = await createPeerConnection(_iceServers, _config);
    if (media != 'data') pc.addStream(_localStream);
    pc.onIceCandidate = (candidate) {
      _send('candidate', {
        'to': id,
        'candidate': {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
        'session_id': this._sessionId,
      });
    };

    pc.onIceConnectionState = (state) {};

    pc.onAddStream = (stream) {
      if (this.onAddRemoteStream != null) this.onAddRemoteStream(stream);
      //_remoteStreams.add(stream);
    };

    pc.onRemoveStream = (stream) {
      if (this.onRemoveRemoteStream != null) this.onRemoveRemoteStream(stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc.onDataChannel = (channel) {
      _addDataChannel(id, channel);
    };

    return pc;
  }

  _addDataChannel(id, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      if (this.onDataChannelMessage != null)
        this.onDataChannelMessage(channel, data);
    };
    _dataChannels[id] = channel;

    if (this.onDataChannel != null) this.onDataChannel(channel);
  }

  _createDataChannel(id, RTCPeerConnection pc, {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = new RTCDataChannelInit();
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    _addDataChannel(id, channel);
  }

  _createOffer(String id, RTCPeerConnection pc, String media) async {
    try {
      RTCSessionDescription s =
          await pc.createOffer(media == 'data' ? _dcConstraints : _constraints);
      pc.setLocalDescription(s);
      _send('offer', {
        'to': id,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': this._sessionId,
        'media': media,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _createAnswer(String id, RTCPeerConnection pc, media) async {
    try {
      RTCSessionDescription s = await pc
          .createAnswer(media == 'data' ? _dcConstraints : _constraints);
      pc.setLocalDescription(s);
      _send('answer', {
        'to': id,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': this._sessionId,
      });
      if (this.onStateChange != null) {
        this.onStateChange(SignalingState.CallStateConnected);
        state = SignalingState.CallStateConnected;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _send(event, data) {
    data['type'] = event;
    JsonEncoder encoder = new JsonEncoder();
    if (_socket != null) _socket.add(encoder.convert(data));
    print('send: ' + encoder.convert(data));
  }
}
