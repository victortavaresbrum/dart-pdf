/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'data.dart';
import 'drag_widget.dart';
import 'examples.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _tab = 0;
  TabController? _tabController;

  PrintingInfo? printingInfo;

  var _data = const CustomData();
  var _hasData = false;
  var _pending = false;
  GlobalKey _identifySizeKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    _tabController = TabController(
      vsync: this,
      length: examples.length,
      initialIndex: _tab,
    );
    _tabController!.addListener(() {
      if (_tab != _tabController!.index) {
        setState(() {
          _tab = _tabController!.index;
        });
      }
      if (examples[_tab].needsData && !_hasData && !_pending) {
        _pending = true;
        askName(context).then((value) {
          if (value != null) {
            setState(() {
              _data = CustomData(name: value);
              _hasData = true;
              _pending = false;
            });
          }
        });
      }
    });

    setState(() {
      printingInfo = info;
    });
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Offset _containerPosition = Offset(0, 0);
  Offset _widgetPosition = Offset(0, 0);
  bool isCalculatingDistance = false;

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
      Offset(_containerPosition.dx + 1000, _containerPosition.dy + 1000),
    );

    return containerRect.contains(widgetRect.topLeft) &&
        containerRect.contains(widgetRect.bottomRight);
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: examples.map<Tab>((e) => Tab(text: e.name)).toList(),
          isScrollable: true,
        ),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: ListView(
                children: [
                  GestureDetector(
                    onPanUpdate: (details) {},
                    child: Ink(
                      height: 36,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text('Nome do usuário'),
                        ],
                      ),
                    ),
                  )
                ],
              )),
          Expanded(
              flex: 5,
              child: Stack(children: [
                PdfPreview(
                  maxPageWidth: 700,
                  build: (format) => examples[_tab].builder(format, _data),
                  actions: actions,
                  onPrinted: _showPrintedToast,
                  onShared: _showSharedToast,
                ),
              ]))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: _showSources,
        child: const Icon(Icons.code),
      ),
    );
  }

  void _showSources() {
    ul.launchUrl(
      Uri.parse(
        'https://github.com/DavBfr/dart_pdf/blob/master/demo/lib/examples/${examples[_tab].file}',
      ),
    );
  }

  Future<String?> askName(BuildContext context) {
    return showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          final controller = TextEditingController();

          return AlertDialog(
            title: const Text('Please type your name:'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            content: TextField(
              decoration: const InputDecoration(hintText: '[your name]'),
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (controller.text != '') {
                    Navigator.pop(context, controller.text);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
