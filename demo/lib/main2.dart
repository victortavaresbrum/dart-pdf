import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyContainerApp(),
    );
  }
}

class MyContainerApp extends StatefulWidget {
  @override
  _MyContainerAppState createState() => _MyContainerAppState();
}

class _MyContainerAppState extends State<MyContainerApp> {
  Offset _containerPosition = Offset(0, 0);
  Offset _widgetPosition = Offset(0, 0);
  bool isCalculatingDistance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posicionando Widget e Obtendo Distância'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              height: 300,
              color: Colors.blue,
              child: Stack(
                children: [
                  Positioned(
                    left: _widgetPosition.dx,
                    top: _widgetPosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _widgetPosition += details.delta;
                          if (_isWidgetInsideContainer()) {
                            isCalculatingDistance = true;
                          } else {
                            isCalculatingDistance = false;
                          }
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (isCalculatingDistance)
              Text("Distância: ${_calculateDistance().toStringAsFixed(2)}")
            else
              Text("Mova o quadrado vermelho para dentro do azul."),
          ],
        ),
      ),
    );
  }

  double _calculateDistance() {
    final dx = _widgetPosition.dx - _containerPosition.dx;
    final dy = _widgetPosition.dy - _containerPosition.dy;
    return sqrt(dx * dx + dy * dy);
  }

  bool _isWidgetInsideContainer() {
    final widgetRect = Rect.fromPoints(
      _widgetPosition,
      Offset(_widgetPosition.dx + 50, _widgetPosition.dy + 50),
    );

    final containerRect = Rect.fromPoints(
      _containerPosition,
      Offset(_containerPosition.dx + 300, _containerPosition.dy + 300),
    );

    return containerRect.contains(widgetRect.topLeft) &&
        containerRect.contains(widgetRect.bottomRight);
  }
}
