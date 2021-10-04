import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waya/models/chat/chatBubble.dart';
import 'package:waya/models/chat/fileMessage.dart';
import 'package:waya/models/users/profileModel.dart';
import 'package:waya/models/chat/messageList.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/src/views/layout/social/calls/initCall.dart';
import 'package:waya/src/views/layout/social/calls/providers/callController.dart';
import 'package:waya/utils/date.dart';
import 'package:waya/utils/margin_utils.dart';
import 'package:waya/utils/persistence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waya/utils/urlConstants.dart';

import 'ChatProfile.dart';
import 'package:waya/src/functions/chat/messageServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'exploreChats.dart';

class ChatScreen extends StatefulWidget {
  final User contact;
  final GetProfileData getProfileData;

  const ChatScreen({
    Key key,
    @required this.contact,
    @required this.getProfileData,
  }) : super(key: key);
  // final LoginModel senderData;

  @override
  ChatState createState() => new ChatState();
}

class ChatState extends State<ChatScreen> {
  CallController controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  double _progressState = 0, percent = 0;
  double get progressState => _progressState;

  FirebaseStorage _storage = FirebaseStorage.instance;

  final flutterVideoCompress = FlutterVideoCompress();

  bool isLoading = false;

  bool isExpanded = false;

  bool isComposingMessage = false;

  String _body;
  String get body => _body;

  var _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  MessageList messages;

  var reference;

  List<MessageItemModel> messageList = [];

  UserProfileModel profileData;
  ScrollController scrollController = new ScrollController();

  FocusNode nodeText1 = FocusNode();

  TextEditingController textEditingController = new TextEditingController();

  File fileMessage, imageFile, imageThumbnail, videoMessage;

  @override
  void initState() {
    _loadData();
    setUpView();
    firebaseSignIn();
    super.initState();
  }

  setUpView() async {
    scrollController = new ScrollController(
      initialScrollOffset: 1000.0,
      keepScrollOffset: true,
    );

    getUserMessages(context);
  }

  void _loadData() async {
    await Future.delayed(Duration(milliseconds: 600));
    controller.initRenderers();
    controller.connect(
        context,
        '${widget.getProfileData.profileData.data.userDetails.id}',
        '${widget.getProfileData.profileData.data.userDetails.fullName}');
    controller.userData = await getProfileData();
    if (controller.userData != null && controller.userData.loginData != null) {}
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<CallController>(context);

    if (nodeText1.hasFocus) {
      isExpanded = false;
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: new AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(top: 19),
                child: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(left: 48.0, top: 23),
                child: Center(
                  child: new ListTile(
                    //contentPadding: const EdgeInsets.all(0),
                    leading: _buildAvatar(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatProfile(sendMessage,
                            contact: widget.contact, profileData: profileData),
                      ),
                    ),
                    title: Container(
                      width: 100,
                      child: Text(
                        widget?.contact?.fullName?.split(' ')[1] ?? '',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.videocam,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      //start video call
                      controller.isVideo = true;
                      controller.receiverId = widget.contact.id;
                      controller.invitePeer(context, '${widget.contact.id}',
                          false, '${widget.contact.fullName}',
                          isVideo: true);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      //start voice call
                      controller.isVideo = false;
                      controller.receiverId = widget.contact.id;
                      controller.invitePeer(context, '${widget.contact.id}',
                          false, '${widget.contact.fullName}');
                      //InitCall
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InitCall(
                            () {},
                            contact: widget.contact,
                          ),
                        ),
                      ); */
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: new PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                          child: new Text('Clear Chats'), value: 'Delete'),
                    ],
                    onSelected: (String v) async {
                      bool done = await MessageServices.deleteMessages(context,
                          id: widget.contact.id);
                      if (done) {
                        setState(() {
                          messageList = [];
                        });
                      }
                    },
                  ),
                )
              ],
              elevation: 1,
            ),
          ),
          body: new Container(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Flexible(
                    child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            percent > 0 && percent <= 0.999
                                ? LinearProgressIndicator(value: percent)
                                : Container(color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    !isLoading
                        ? buildMessageList()
                        : Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          )
                  ],
                )),
                new Divider(height: 1.0),
                new Container(
                  //  height: 56,
                  decoration:
                      new BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
                Row(
                  children: <Widget>[
                    fileMessage != null
                        ? Container(
                            child: new FileCard(
                              removeFile: clearFields,
                            ),
                          )
                        : Container(),
                    imageThumbnail != null
                        ? Container(
                            child: new ImageCard(
                            removeFile: clearFields,
                            image: imageThumbnail,
                          ))
                        : Container(),
                    imageFile != null
                        ? Container(
                            child: new ImageCard(
                            removeFile: clearFields,
                            image: imageFile,
                          ))
                        : Container(),
                  ],
                ),
                isExpanded ? buildBottomMenu(context) : Container(),
              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? new BoxDecoration(
                    border: new Border(
                        top: new BorderSide(
                    color: Colors.grey[200],
                  )))
                : null,
          )),
    );
  }

  buildMessageList() {
    return ListView.builder(
      itemCount: messageList?.length ?? 0,
      controller: scrollController,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (BuildContext context, int i) {
        var recvID = messageList[i].receiverId;

        //RETURN MONEY/NORMAL RECICVED MESSAGES
        if (recvID == widget.contact.id) {
          //MULTIMEDIA
          if (messageList[i].imageUrl != null) {
            if (messageList[i].imageUrl.contains('_video_')) {
              FileMessage fileData =
                  FileMessage.fromJson(json.decode(messageList[i].imageUrl));
              try {
                return VideoBubble(
                  delivered: true,
                  message: messageList[i]?.message ?? '',
                  isLoading: messageList[i].isLoading ?? false,
                  time: formatTime(messageList[i].createdAt),
                  isMe: false,
                  image: fileData.thumbnailUrl,
                  videoUrl: fileData.fileUrl,
                );
              } catch (e) {
                print(e.toString());
              }
            } else if (messageList[i].imageUrl.contains('_file_')) {
              try {
                FileMessage fileData =
                    FileMessage.fromJson(json.decode(messageList[i].imageUrl));
                return FileBubble(
                  delivered: true,
                  message: messageList[i].message,
                  isLoading: messageList[i].isLoading ?? false,
                  time: formatTime(messageList[i].createdAt),
                  isMe: false,
                  image: fileData.thumbnailUrl,
                  fileUrl: fileData.fileUrl,
                );
              } catch (e) {
                print(e.toString());
              }
            } else {
              //    print(messageList[i].imageUrl);
              return ImageBubble(
                delivered: true,
                message: messageList[i]?.message ?? '',
                isLoading: messageList[i].isLoading ?? false,
                time: formatTime(messageList[i].createdAt),
                isMe: false,
                image: messageList[i].imageUrl,
              );
            }
          }

          //TEXT AND TRANSACTION
          if (messageList[i].message.contains('**PaymentRequest**')) {
            return PaymentRequestBubble(
              delivered: true,
              message: messageList[i]
                  .message
                  .replaceAll('**PaymentRequest** of', ''),
              isLoading: messageList[i].isLoading ?? false,
              time: formatTime(messageList[i].createdAt),
              isMe: false,
            );
          } else if (messageList[i].message.contains('**ACCESSCODE101**')) {
            return MoneyBubble(
              delivered: true,
              message:
                  messageList[i].message.replaceAll('**ACCESSCODE101**', ''),
              isLoading: messageList[i].isLoading ?? false,
              time: formatTime(messageList[i].createdAt),
              isMe: false,
            );
          } else if (messageList[i].message.contains('**PaidRequest**')) {
            return PaidRequestBubble(
              delivered: true,
              message:
                  messageList[i].message.replaceAll('**PaidRequest** ', ''),
              isLoading: messageList[i].isLoading ?? false,
              time: formatTime(messageList[i].createdAt),
              isMe: false,
            );
          } else {
            return Bubble(
              delivered: true,
              message: messageList[i]?.message ?? '',
              isLoading: messageList[i].isLoading ?? false,
              time: formatTime(messageList[i].createdAt),
              isMe: false,
            );
          }
        }

        //RETURN MONEY/NORMAL SENT MESSAGES
        else {
          //MULTIMEDIA MESSGAES
          if (messageList[i].imageUrl != null) {
            if (messageList[i].imageUrl.contains('_video_')) {
              FileMessage fileData =
                  FileMessage.fromJson(json.decode(messageList[i].imageUrl));
              try {
                return VideoBubble(
                  delivered: true,
                  message: messageList[i]?.message ?? '',
                  isLoading: messageList[i].isLoading ?? false,
                  time: formatTime(messageList[i].createdAt),
                  isMe: true,
                  image: fileData.thumbnailUrl,
                  videoUrl: fileData.fileUrl,
                );
              } catch (e) {
                print(e.toString());
              }
            } else if (messageList[i].imageUrl.contains('_file_')) {
              try {
                FileMessage fileData =
                    FileMessage.fromJson(json.decode(messageList[i].imageUrl));
                return FileBubble(
                  delivered: true,
                  message: messageList[i]?.message ?? '',
                  isLoading: messageList[i].isLoading ?? false,
                  time: formatTime(messageList[i].createdAt),
                  isMe: true,
                  image: fileData.thumbnailUrl,
                  fileUrl: fileData.fileUrl,
                );
              } catch (e) {
                print(e.toString());
              }
            } else {
              return ImageBubble(
                delivered: true,
                message: messageList[i]?.message ?? '',
                isLoading: messageList[i].isLoading ?? false,
                time: formatTime(messageList[i].createdAt),
                isMe: true,
                image: messageList[i].imageUrl,
              );
            }
          }

          //TRANSACTION MESSAEGS
          if (messageList[i].message.contains('**ACCESSCODE101**')) {
            return MoneyBubble(
              delivered: true,
              message:
                  messageList[i].message.replaceAll('**ACCESSCODE101**', ''),
              isLoading: messageList[i].isLoading ?? false,
              time: formatTime(messageList[i].createdAt),
              isMe: true,
            );
          } else if (messageList[i].message.contains('**PaymentRequest**')) {
            return InkWell(
              onTap: () {},
              child: PaymentRequestBubble(
                delivered: true,
                message: messageList[i]
                    .message
                    .replaceAll('**PaymentRequest** of ', ''),
                isLoading: messageList[i].isLoading ?? false,
                time: formatTime(messageList[i].createdAt),
                isMe: true,
              ),
            );
          } else if (messageList[i].message.contains('**PaidRequest**')) {
            return PaidRequestBubble(
              delivered: true,
              message:
                  messageList[i].message.replaceAll('**PaidRequest** ', ''),
              isLoading: messageList[i].isLoading ?? false,
              time: formatTime(messageList[i].createdAt),
              isMe: true,
            );
          } else {
            // print()
            return Bubble(
              delivered: true,
              message: messageList[i]?.message ?? '',
              isLoading: messageList[i].isLoading ?? false,
              time: formatTime(messageList[i].createdAt),
              isMe: true,
            );
          }
        }
      },
    );
  }

  Container buildBottomMenu(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Material(
        child: Column(
          children: <Widget>[
            customYMargin(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new KeyBoardButton(
                    title: 'Photo',
                    onTap: () {
                      getImage();
                    },
                    image: 'camera',
                  ),
                  new KeyBoardButton(
                    title: 'Video',
                    onTap: () {
                      getFile(type: FileType.VIDEO);
                    },
                    image: 'video',
                  ),
                  new KeyBoardButton(
                    title: 'File',
                    onTap: () {
                      getFile();
                    },
                    image: 'file',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new KeyBoardButton(
                    title: 'Video Call',
                    image: 'video-call',
                    onTap: () {
                      //start video call
                      controller.isVideo = true;
                      controller.invitePeer(context, '${widget.contact.id}',
                          true, '${widget.contact.fullName}',
                          isVideo: true);
                    },
                  ),
                  new KeyBoardButton(
                    title: 'Voice Call',
                    image: 'voice-call',
                    onTap: () {
                      //start voice call
                      controller.isVideo = false;
                      controller.invitePeer(context, '${widget.contact.id}',
                          false, '${widget.contact.fullName}',
                          isVideo: false);
                    },
                  ),
                  new KeyBoardButton(
                    title: 'Transfer',
                    onTap: () {},
                    image: 'transfer',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getUserMessages(context) async {
    setState(() {
      isLoading = true;
    });
    profileData = (await getProfileData()).profileData;

    var __message = await MessageServices.getMessages(
        context, widget.contact.conversationId);
    if (__message != null) {
      setState(() {
        messages = __message;
        messageList = __message?.data?.reversed?.toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<Null> textMessageSubmitted(String text) async {
    if (profileData.data.userDetails.id != null &&
        profileData.data.userDetails.id > 0 &&
        text != null &&
        (fileMessage != null ||
            imageFile != null ||
            videoMessage != null ||
            text.isNotEmpty)) {
      textEditingController.clear();
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );
      setState(() {
        isComposingMessage = false;
      });

      sendMessage(text);
    } // _sendMessage(messageText: text, imageUrl: null);
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: isComposingMessage
          ? () => textMessageSubmitted(textEditingController.text)
          : null,
    );
  }

  getImageSendButton() {
    return new IconButton(
        icon: new Icon(Icons.send, color: Colors.blue),
        onPressed: () async {
          if (imageFile != null) {
            var imageEncoded = await convertToBase64();
            if (imageEncoded != null) {
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 100),
              );
              setState(() {
                isComposingMessage = false;
              });
              sendMessage(textEditingController.text, image: imageEncoded);
              textEditingController.clear();
            }
          } else if (fileMessage != null) {
            sendMessage(
              textEditingController.text,
            );
          } else if (videoMessage != null) {
            sendMessage(
              textEditingController.text,
            );
          }
        });
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: isComposingMessage
          ? () => textMessageSubmitted(textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          child: new Row(
            children: <Widget>[
              !isExpanded
                  ? new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.photo_camera,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () async {
                            getImage();
                          }),
                    )
                  : Container(
                      width: 8,
                    ),
              new Flexible(
                child: new TextField(
                  controller: textEditingController,
                  focusNode: nodeText1,
                  onChanged: (String messageText) {
                    setState(() {
                      isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: textMessageSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: fileMessage != null || imageFile != null
                    ? getImageSendButton()
                    : Theme.of(context).platform == TargetPlatform.iOS
                        ? getIOSSendButton()
                        : getDefaultSendButton(),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      !isExpanded ? Icons.more_horiz : Icons.close,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (nodeText1.hasFocus) {
                          nodeText1.unfocus();
                          isExpanded = true;
                        } else {
                          nodeText1.requestFocus();
                          isExpanded = false;
                        }
                      });
                    }),
              ),
            ],
          ),
        ));
  }

  Widget _buildAvatar() {
    return new CircleAvatar(
      child: Text(
          initials(widget.contact.fullName.split(' ')[0],
              widget.contact.fullName.split(' ')[1]),
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepOrange,
      radius: 20.0,
    );
  }

  void sendMessage(String message, {String image}) async {
    FileMessage fileModel;
    try {
      setState(() {
        messageList.insert(
          0,
          MessageItemModel(
            id: messageList.length,
            userId: profileData.data.userDetails.id,
            receiverId: widget.contact.id,
            message: message,
            imageUrl: image ?? '',
            isLoading: true,
            percent: percent,
            createdAt: formatMessageDate(DateTime.now()),
            updatedAt: formatMessageDate(DateTime.now()),
          ),
        );
      });

      if (fileMessage != null) {
        setState(() {
          fileModel = new FileMessage(
              type: '_file_', fileUrl: '', thumbnailUrl: FireStoreUrl.fileIcon);
        });

        //Upload for Files like docs e.t.c.
        var fileUrl = await uploadFile(fileMessage);

        setState(() {
          fileModel = new FileMessage(
              type: '_file_',
              fileUrl: fileUrl,
              thumbnailUrl:
                  'https://firebasestorage.googleapis.com/v0/b/waya-paychat.appspot.com/o/fileIcon.png?alt=media&token=7c009438-3229-49ce-b05a-8719d30186c6');
        });

        var sentMessage = await MessageServices.sendMessage(context,
            message: message,
            id: widget.contact.id,
            image: json.encode(fileModel?.toJson()));

        setState(() {
          isLoading = false;
          messageList.removeAt(0);
          if (sentMessage != null) {
            messageList.insert(
              0,
              MessageItemModel(
                id: messageList.length + 1,
                userId: profileData.data.userDetails.id,
                receiverId: widget.contact.id,
                imageUrl: json.encode(fileModel?.toJson()),
                message: '${sentMessage?.data?.message ?? ''}',
                createdAt: sentMessage.data.createdAt ?? ';',
                updatedAt: sentMessage.data.updatedAt ?? '',
              ),
            );
          }
        });
      }
      if (videoMessage != null) {
        //Upload for Video Files
        var fileUrl = await uploadVideo(videoMessage);
        var thumbnailUrl = await uploadThumbnail();

        setState(() {
          fileModel = new FileMessage(
              type: '_video_', fileUrl: fileUrl, thumbnailUrl: thumbnailUrl);
        });

        var sentMessage = await MessageServices.sendMessage(context,
            image: json.encode(fileModel?.toJson()),
            id: widget.contact.id,
            message: message);

        setState(() {
          isLoading = false;
          messageList.removeAt(0);
        });

        setState(() {
          if (sentMessage != null) {
            messageList.insert(
              0,
              MessageItemModel(
                id: messageList.length + 1,
                userId: profileData.data.userDetails.id,
                receiverId: widget.contact.id,
                imageUrl: json.encode(fileModel?.toJson()),
                message: '${sentMessage?.data?.message ?? ''}',
                createdAt: sentMessage.data.createdAt ?? ';',
                updatedAt: sentMessage.data.updatedAt ?? '',
              ),
            );
          }
        });
      } else {
        //Ordinary Base64 Image Upload
        var sentMessage = await MessageServices.sendMessage(context,
            message: message, id: widget.contact.id, image: image);

        setState(() {
          isLoading = false;
          messageList.removeAt(0);
        });

        setState(() {
          if (sentMessage != null) {
            messageList.insert(
              0,
              MessageItemModel(
                id: messageList.length + 1,
                userId: profileData.data.userDetails.id,
                receiverId: widget.contact.id,
                imageUrl: image,
                message: '${sentMessage?.data?.message ?? ''}',
                createdAt: sentMessage.data.createdAt ?? ';',
                updatedAt: sentMessage.data.updatedAt ?? '',
              ),
            );
          }
        });
        /* UsersList usersList = await UserListLoad.allUsers(context);
      await saveUsersList(usersList: usersList); */
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getImage() async {
    try {
      var img = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (img != null)
        setState(() {
          imageFile = img;
        });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getFile({FileType type = FileType.ANY}) async {
    try {
      var file;
      if (type == FileType.VIDEO) {
        file = (await _videoPicker()).file;
        if (file != null)
          setState(() {
            videoMessage = file;
          });
      } else {
        file = await FilePicker.getFile(type: type);
        if (file != null)
          setState(() {
            fileMessage = file;
          });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<int>> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 767,
      minHeight: 500,
      format: CompressFormat.jpeg,
      quality: 95,
    );
    return result;
  }

  Future<String> convertToBase64() async {
    try {
      var baseItem = await testCompressFile(imageFile);

      if (baseItem != null) {
        var compressedImage = base64Encode(baseItem);
        clearFields();
        return compressedImage;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<String> uploadVideo(File file) async {
    StorageReference ref = _storage
        .ref()
        .child('videos')
        .child("video_${DateTime.now().millisecondsSinceEpoch}.mp4");
    StorageUploadTask uploadTask = ref.putFile(file);

    uploadTask.events.listen((event) {
      setState(() {
        percent = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
      });
    }).onError((error) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Failed to Upload Video'),
        backgroundColor: Colors.red,
      ));
    });

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    return downloadUrl.toString();
  }

  Future<String> uploadThumbnail() async {
    StorageReference ref = _storage
        .ref()
        .child('thumbnails')
        .child("thumb_${DateTime.now().millisecondsSinceEpoch}.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageThumbnail);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    return downloadUrl.toString();
  }

  Future<String> uploadFile(File file) async {
    StorageReference ref = _storage
        .ref()
        .child('file')
        .child("file_${DateTime.now().millisecondsSinceEpoch}");
    StorageUploadTask uploadTask = ref.putFile(file);
    uploadTask.events.listen((event) {
      setState(() {
        percent = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
      });
    }).onError((error) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Failed to Upload Video'),
        backgroundColor: Colors.red,
      ));
    });

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    return downloadUrl.toString();
  }

  Future<MediaInfo> _videoPicker() async {
    final file = await FilePicker.getFile(type: FileType.VIDEO);
    if (file?.path != null) {
      imageThumbnail = await flutterVideoCompress.getThumbnailWithFile(
        file.path,
        quality: 49,
        position: -1,
      );

      //debugPrint(imageThumbnail.path);

      assert(imageThumbnail.existsSync());

      debugPrint('file Exists: ${imageThumbnail.existsSync()}');

      MediaInfo info = await flutterVideoCompress.compressVideo(
        file.path,
        deleteOrigin: true,
        quality: VideoQuality.DefaultQuality,
      );

      //debugPrint(info.toJson().toString());
      return info;
    } else {
      return null;
    }
  }

  void clearFields({bool fromUI = false}) {
    if (!fromUI) {
      setState(() {
        isLoading = false;
        fileMessage = null;
        imageFile = null;
        imageThumbnail = null;
      });
    }
  }

  onChanged(val) {
    if (val.length > 0) {
      setState(() {
        isComposingMessage = true;
      });
      //
    }
    print(val.length);
  }
}

class KeyBoardButton extends StatelessWidget {
  final title;
  final onTap;
  final image;
  const KeyBoardButton({
    Key key,
    this.title,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        customYMargin(9),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              child: Container(
                  width: 60,
                  height: 60,
                  child: Image.asset('assets/icons/$image.png', scale: 4)),
            ),
          ),
        ),
        customYMargin(9),
        Text(
          '$title',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        )
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key key,
    @required this.image,
    this.removeFile,
  }) : super(key: key);

  final File image;
  final removeFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.16,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                image:
                    DecorationImage(image: FileImage(image), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  new BoxShadow(
                    offset: Offset(0, 20),
                    spreadRadius: -13,
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20,
                width: 20,
                margin: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red, size: 16),
                  onPressed: () {
                    removeFile();
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class FileCard extends StatelessWidget {
  const FileCard({
    Key key,
    this.removeFile,
  }) : super(key: key);

  final removeFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.16,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                image: DecorationImage(
                    image: NetworkImage(FireStoreUrl.fileIcon),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  new BoxShadow(
                    offset: Offset(0, 20),
                    spreadRadius: -13,
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20,
                width: 20,
                margin: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red, size: 16),
                  onPressed: () {
                    removeFile();
                  },
                ),
              ))
        ],
      ),
    );
  }
}

firebaseSignIn() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signInWithEmailAndPassword(
        email: 'waya.impactif.admin@gmail.com',
        password:
            'wayapassword1234567890!@#%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?');

    //print("Email Signed in " + user.uid); // THIS works
  } catch (err) {
    print("ERROR CAUGHT: " + err.toString());
  }
}
