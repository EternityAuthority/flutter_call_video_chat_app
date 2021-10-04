import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientScaffold extends StatelessWidget {
  final Gradient gradient;
  final Widget body;
  const GradientScaffold({
    Key key,
    this.gradient,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _buildUI() {
      return body != null ? body : Column();
    }

    _buildContainer() {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: gradient != null
                ? gradient
                : LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.2, 0.9],
                    colors: [
                      Color.fromRGBO(238, 202, 0, 1),
                      Color.fromRGBO(239, 108, 0, 1),
                    ],
                  )),
        child: _buildUI(),
      );
    }

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light, child: _buildContainer()),
    );
  }
}
