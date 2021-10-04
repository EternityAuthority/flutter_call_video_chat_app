import 'dart:convert';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:undraw/undraw.dart';
import 'package:waya/utils/margin_utils.dart';
import 'package:waya/utils/validator.dart';

class Bubble extends StatelessWidget {
  Bubble(
      {this.isLoading = false,
      this.message,
      this.time,
      this.delivered = false,
      this.isMe = true});

  final String message, time;
  final bool delivered, isMe, isLoading;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.orange.shade50 : Colors.white;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          bottom: isMe ? 10 : 0,
          left: isMe ? 6 : 50,
          right: isMe ? 50 : 6),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: !isLoading
                ? Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          bottom: 14,
                        ),
                        child: Text(
                          '     ---',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  isMe ? Colors.orange.shade50 : Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 16.0,
                          bottom: 14,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        //left: 9.0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 2.0),
                              Icon(
                                icon,
                                size: 15.0,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}

class MoneyBubble extends StatelessWidget {
  MoneyBubble(
      {this.isLoading = false,
      this.message,
      this.time,
      this.delivered = false,
      this.isMe = true});

  final String message, time;
  final bool delivered, isMe, isLoading;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Theme.of(context).accentColor : Colors.green;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          bottom: isMe ? 10 : 0,
          left: isMe ? 6 : 50,
          right: isMe ? 50 : 6),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: !isLoading
                ? Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          bottom: 14,
                        ),
                        child: Text(
                          '     ---',
                          style: TextStyle(
                              fontSize: 17,
                              color: isMe
                                  ? Theme.of(context).accentColor
                                  : Colors.green),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 16.0,
                          bottom: 14,
                        ),
                        child: Text(
                          (!isMe ? "Transfered " : "Received ") +
                              "NGN " +
                              Validator.currFormatter
                                  .format(double.parse(message)),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        //left: 9.0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 2.0),
                              Icon(
                                icon,
                                size: 15.0,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}

class PaymentRequestBubble extends StatelessWidget {
  PaymentRequestBubble(
      {this.isLoading = false,
      this.message,
      this.time,
      this.delivered = false,
      this.isMe = true});

  final String message, time;
  final bool delivered, isMe, isLoading;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.red : Colors.black54;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(15.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(20.0),
          );
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          bottom: isMe ? 10 : 0,
          left: isMe ? 6 : 50,
          right: isMe ? 50 : 6),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: !isLoading
                ? Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          bottom: 14,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 16.0,
                          bottom: 14,
                        ),
                        child: Column(
                          children: <Widget>[
                            /* Container(
                              height: 140,
                              width: 140,
                              child: UnDraw(
                                color: Colors.white,
                                illustration: UnDrawIllustration.transfer_money,
                                placeholder: CircularProgressIndicator(),
                                errorWidget: Icon(Icons.error_outline,
                                    color: Colors.grey[200], size: 30),
                              ),
                            ), */
                            customYMargin(10),
                            Text(
                              (!isMe
                                      ? "Requested "
                                      : "Click to Pay\nMoney Request of  ") +
                                  "NGN" +
                                  message,
                              style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            customYMargin(10),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        //left: 9.0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 2.0),
                              Icon(
                                icon,
                                size: 15.0,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}

class PaidRequestBubble extends StatelessWidget {
  PaidRequestBubble(
      {this.isLoading = false,
      this.message,
      this.time,
      this.delivered = false,
      this.isMe = true});

  final String message, time;
  final bool delivered, isMe, isLoading;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.blue : Colors.amber;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          bottom: isMe ? 10 : 0,
          left: isMe ? 6 : 50,
          right: isMe ? 50 : 6),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: !isLoading
                ? Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          bottom: 14,
                        ),
                        child: Text(
                          '     ---',
                          style: TextStyle(
                              fontSize: 17,
                              color: isMe ? Colors.blue : Colors.amber),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 16.0,
                          bottom: 14,
                        ),
                        child: Column(
                          children: <Widget>[
                            /* Container(
                              height: 140,
                              width: 150,
                              child: UnDraw(
                                color: Colors.white,
                                illustration: UnDrawIllustration.checklist,
                                placeholder: CircularProgressIndicator(),
                                errorWidget: Icon(Icons.error_outline,
                                    color: Colors.grey[200], size: 30),
                              ),
                            ), */
                            customYMargin(10),
                            Text(
                              (!isMe ? "Recieved " : " Money Request of ") +
                                  "NGN " +
                                  message +
                                  (isMe ? '\n Successfully Paid' : ''),
                              style: TextStyle(
                                  fontSize: 17,
                                  height: 1.7,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        //left: 9.0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 2.0),
                              Icon(
                                icon,
                                size: 15.0,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}

class LoadImage extends StatelessWidget {
  LoadImage({
    this.isLoading = false,
    this.image,
  });

  final File image;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    );
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 6, right: 50),
      child: Container(
        width: 200,
        height: 200,
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          borderRadius: radius,
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
    );
  }
}

class ImageBubble extends StatelessWidget {
  ImageBubble(
      {this.isLoading = false,
      this.message,
      this.time,
      this.image,
      this.delivered = false,
      this.isMe = true});

  final String message, time, image;
  final bool delivered, isMe, isLoading;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.orange.shade50 : Colors.white;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(8.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(10.0),
          );
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          bottom: isMe ? 10 : 0,
          left: isMe ? 6 : 50,
          right: isMe ? 30 : 6),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: !isLoading
                ? Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          bottom: 14,
                        ),
                        child: Text(
                          '     ---',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  isMe ? Colors.orange.shade50 : Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[900],
                                  image: DecorationImage(
                                      image: image.contains('http')
                                          ? NetworkImage(image)
                                          : MemoryImage(base64.decode(image
                                              .replaceAll('WayaImage', ''))),
                                      fit: BoxFit.cover),
                                  borderRadius: radius,
                                ),
                              ),
                            ),
                            customYMargin(10),
                            Text(
                              message,
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        //left: 9.0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 2.0),
                              Icon(
                                icon,
                                size: 15.0,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}

class VideoBubble extends StatelessWidget {
  VideoBubble(
      {this.isLoading = false,
      this.message,
      this.time,
      this.image,
      this.videoUrl,
      this.delivered = false,
      this.isMe = true});

  final String message, time, image, videoUrl;
  final bool delivered, isMe, isLoading;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.orange.shade50 : Colors.white;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(8.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(10.0),
          );
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          bottom: isMe ? 10 : 0,
          left: isMe ? 6 : 50,
          right: isMe ? 30 : 6),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: !isLoading
                ? Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          bottom: 14,
                        ),
                        child: Text(
                          '     ---',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  isMe ? Colors.orange.shade50 : Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[900],
                                  image: DecorationImage(
                                      image: MemoryImage(base64.decode(
                                          image.replaceAll('WayaImage', ''))),
                                      fit: BoxFit.cover),
                                  borderRadius: radius,
                                ),
                              ),
                            ),
                            customYMargin(10),
                            Text(
                              message,
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        //left: 9.0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 2.0),
                              Icon(
                                icon,
                                size: 15.0,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}

class FileBubble extends StatelessWidget {
  FileBubble(
      {this.isLoading = false,
      this.message,
      this.time,
      this.image,
      this.delivered = false,
      this.isMe = true,
      this.fileUrl});

  final String message, time, image, fileUrl;
  final bool delivered, isMe, isLoading;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.orange.shade50 : Colors.white;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(8.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(10.0),
          );
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          bottom: isMe ? 10 : 0,
          left: isMe ? 6 : 50,
          right: isMe ? 30 : 6),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: !isLoading
                ? Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          bottom: 14,
                        ),
                        child: Text(
                          '     ---',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  isMe ? Colors.orange.shade50 : Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                /* final taskId = */ await FlutterDownloader
                                    .enqueue(
                                  url: '$fileUrl',
                                  savedDir:
                                      'the path of directory where you want to save downloaded files',
                                  showNotification:
                                      true, // show download progress in status bar (for Android)
                                  openFileFromNotification:
                                      true, // click on notification to open downloaded file (for Android)
                                );
                              },
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[900],
                                  image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.cover),
                                  borderRadius: radius,
                                ),
                              ),
                            ),
                            customYMargin(10),
                            Text(
                              message,
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        //left: 9.0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 2.0),
                              Icon(
                                icon,
                                size: 15.0,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}
