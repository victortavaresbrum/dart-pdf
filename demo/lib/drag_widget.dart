import 'package:flutter/material.dart';

class DragWidget extends StatefulWidget {
  const DragWidget({Key? key}) : super(key: key);

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  double x1 = 0.0,
      x2 = 0.0,
      y1 = 0.0,
      y2 = 32.0,
      x1Prev = 0.0,
      x2Prev = 200.0,
      y1Prev = 100.0,
      y2Prev = 100.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: x1,
          top: y1,
          child: GestureDetector(
            onPanDown: (d) {
              x1Prev = x1;
              y1Prev = y1;
            },
            onPanUpdate: (details) {
              setState(() {
                x1 = x1Prev + details.localPosition.dx;
                y1 = y1Prev + details.localPosition.dy;
              });
            },
            child: Container(
              width: 64,
              height: 24,
              color: Colors.amber,
            ),
          ),
        ),
        Positioned(
          left: x2,
          top: y2,
          child: GestureDetector(
            onPanDown: (d) {
              x2Prev = x2;
              y2Prev = y2;
            },
            onPanUpdate: (details) {
              setState(() {
                x2 = x2Prev + details.localPosition.dx;
                y2 = y2Prev + details.localPosition.dy;
              });
            },
            child: Container(
              width: 64,
              height: 24,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
