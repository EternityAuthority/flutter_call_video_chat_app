import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:waya/utils/margin_utils.dart';

class DashImageItem extends StatefulWidget {
  final IconData icon;
  final String image;
  final String desc;
  final Color color;
  final Function function;
  final bool isDialog;

  DashImageItem(
      {Key key,
      this.icon,
      this.desc,
      this.function,
      this.color = Colors.black,
      this.isDialog = false,
      this.image})
      : super(key: key);

  @override
  _DashImageItemState createState() => _DashImageItemState();
}

class _DashImageItemState extends State<DashImageItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      height: 90,
      width: widget.isDialog ? 100 : 90,
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: -18,
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.all(Radius.circular(widget.isDialog ? 10 : 20)),
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(widget.isDialog ? 10 : 20),
            color: Colors.white,
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: widget.image != null
                    ? MemoryImage(base64.decode(widget.image), scale: 2)
                    : AssetImage('dfd')),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: widget.function ?? () => print('null'),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        widget.icon,
                        size: 30,
                        color: widget.color,
                      ),
                      customYMargin(10),
                      Text('${widget?.desc ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12)),
                    ])),
          ),
        ),
      ),
    );
  }
}

class DashItem extends StatelessWidget {
  final String val;
  final String desc;
  final Color color;
  const DashItem({Key key, this.val, this.desc, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('$val',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: color)),
      customYMargin(5),
      Text('$desc', style: TextStyle(fontWeight: FontWeight.bold)),
    ]);
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    @required this.onTap,
    @required this.title,
    this.iconData,
    this.showLine = false,
    this.iconColor = Colors.black,
    this.otherText,
    this.isWhiteTheme = false,
    this.child,
  })  : assert(title != null),
        super(key: key);

  final VoidCallback onTap;
  final String title;
  final IconData iconData;
  final bool showLine, isWhiteTheme;
  final Color iconColor;
  final String otherText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: isWhiteTheme ? Colors.transparent : Colors.white,
        child: ListTile(
          onTap: onTap,
          leading:
              Icon(iconData, color: isWhiteTheme ? Colors.white : iconColor),
          subtitle: otherText != null
              ? Container(
                  width: 200,
                  child: Text(
                    otherText,
                    style: TextStyle(
                        color: isWhiteTheme ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          title: child != null
              ? child
              : Text(
                  title ?? '',
                  style: TextStyle(
                      color: isWhiteTheme ? Colors.white : Colors.black),
                ),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: isWhiteTheme ? Colors.white : Colors.grey[300]),
        ));
  }
}
