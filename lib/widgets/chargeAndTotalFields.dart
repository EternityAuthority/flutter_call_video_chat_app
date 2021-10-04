import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undraw/undraw.dart';

class ChargeAndTotalField extends StatefulWidget {
  String currentText = '0.00';
  ChargeAndTotalField({@required this.currentText});

  @override
  _ChargeAndTotalFieldState createState() => _ChargeAndTotalFieldState();
}

class _ChargeAndTotalFieldState extends State<ChargeAndTotalField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Text('Charge: N20.00',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 25.0),
          Flexible(
            child: Text(
                // 'Total: N${(double.parse(provider.amountTEC.text.replaceAll(',', '')) + 20.00).toString()}',
                'Total: N${((double.tryParse(widget.currentText.replaceAll(',', '')) ?? 0.0).roundToDouble() + 20.00).toString()}',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
