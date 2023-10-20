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
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data.dart';

const PdfColor blue = PdfColor.fromInt(0xff91E9F2);
const PdfColor lightGreen = PdfColor.fromInt(0xff84BFAE);
const sep = 120.0;

Future<Uint8List> generateResume(PdfPageFormat format, CustomData data) async {
  final doc = Document(title: 'My Résumé', author: 'David PHAM-VAN');
  final pageTheme = await _myPageTheme(format);
  final String victor = 'Victor Hugo Tavares Brum';
  doc.addPage(
    MultiPage(
      pageTheme: pageTheme,
      build: (Context context) => [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Block(title: 'Batatinha'),
            Partition(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text('Declaração',
                        style: Theme.of(context)
                            .defaultTextStyle
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Declaro para os devidos fins, que a nutricionista $victor ,CRN/RS ________________ está cursando o Programa de ResidênciaMultiprofissional em Saúde - _____________________, curso credenciado pelo CNRMS/MEC, na Sociedade Beneficência e Caridade Lajeado (Hospital Bruno Born). Suas atividades práticas na Instituição e na saúde pública iniciaram em 01/03/2022 e serão concluídas no dia 28/02/2024.',
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('Lajeado, 19 de janeiro de 2023.')])
                ],
              ),
            ),
            Partition(
                child: Column(
              children: [],
            ))
          ],
        ),
      ],
    ),
  );
  return doc.save();
}

Future<PageTheme> _myPageTheme(PdfPageFormat format) async {
  final bgShape = await rootBundle.loadString('assets/resume.svg');

  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 4.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);
  return PageTheme(
    pageFormat: format,
    theme: ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
    buildBackground: (Context context) {
      return FullPage(
        ignoreMargins: true,
        child: Stack(
          children: [
            Positioned(
              child: SvgImage(svg: bgShape),
              left: 0,
              top: 0,
            ),
            Positioned(
              child: Transform.rotate(angle: pi, child: SvgImage(svg: bgShape)),
              right: 0,
              bottom: 0,
            ),
          ],
        ),
      );
    },
  );
}

class _Block extends StatelessWidget {
  _Block({
    required this.title,
    this.icon,
  });

  final String title;

  final IconData? icon;

  @override
  Widget build(Context context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 5.5, left: 2, right: 5),
              decoration: const BoxDecoration(
                color: blue,
                shape: BoxShape.circle,
              ),
            ),
            Text(title,
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(fontWeight: FontWeight.bold)),
            Spacer(),
            if (icon != null) Icon(icon!, color: lightGreen, size: 18),
          ]),
          Container(
            decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: blue, width: 2))),
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const EdgeInsets.only(left: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Lorem(length: 20),
                ]),
          ),
        ]);
  }
}

class _Category extends StatelessWidget {
  _Category({required this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Container(
      decoration: const BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      margin: const EdgeInsets.only(bottom: 10, top: 20),
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: Text(
        title,
        textScaleFactor: 1.5,
      ),
    );
  }
}

class _Percent extends StatelessWidget {
  _Percent({
    required this.size,
    required this.value,
    required this.title,
  });

  final double size;

  final double value;

  final Widget title;

  static const fontSize = 1.2;

  PdfColor get color => blue;

  static const backgroundColor = PdfColors.grey300;

  static const strokeWidth = 5.0;

  @override
  Widget build(Context context) {
    final widgets = <Widget>[
      Container(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Text(
                '${(value * 100).round().toInt()}%',
                textScaleFactor: fontSize,
              ),
            ),
            CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
      )
    ];

    widgets.add(title);

    return Column(children: widgets);
  }
}

class _UrlText extends StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  Widget build(Context context) {
    return UrlLink(
      destination: url,
      child: Text(text,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}
