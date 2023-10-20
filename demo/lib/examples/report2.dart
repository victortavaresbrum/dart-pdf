import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data.dart';

Future<Uint8List> generateReportTwo(
    PdfPageFormat pageFormat, CustomData data) async {
  // Create a PDF document.
  final document = pw.Document();
  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );
  const baseColor = PdfColors.cyan;

  // Second page with a pie chart
  document.addPage(
    pw.Page(
        pageFormat: pageFormat,
        theme: theme,
        build: (context) {
          const chartColors = [
            PdfColors.blue300,
            PdfColors.green300,
            PdfColors.amber300,
            PdfColors.pink300,
            PdfColors.cyan300,
            PdfColors.purple300,
            PdfColors.lime300,
          ];

          const tableHeaders = ['Category', 'Budget', 'Expense', 'Result'];

          const dataTable = [
            ['Phone', 80, 95],
            ['Internet', 250, 230],
            ['Electricity', 300, 375],
            ['Movies', 85, 80],
            ['Food', 300, 350],
            ['Fuel', 650, 550],
            ['Insurance', 250, 310],
          ];

          final expense = dataTable
              .map((e) => e[2] as num)
              .reduce((value, element) => value + element);
          // Data table
          final table = pw.TableHelper.fromTextArray(
            border: null,
            headers: tableHeaders,
            data: List<List<dynamic>>.generate(
              dataTable.length,
              (index) => <dynamic>[
                dataTable[index][0],
                dataTable[index][1],
                dataTable[index][2],
                (dataTable[index][1] as num) - (dataTable[index][2] as num),
              ],
            ),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: baseColor,
            ),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: baseColor,
                  width: .5,
                ),
              ),
            ),
            cellAlignment: pw.Alignment.centerRight,
            cellAlignments: {0: pw.Alignment.centerLeft},
          );
          return pw.Row(
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Chart(
                  grid: pw.PieGrid(),
                  datasets:
                      List<pw.Dataset>.generate(dataTable.length, (index) {
                    final data = dataTable[index];
                    final color = chartColors[index % chartColors.length];
                    final value = (data[2] as num).toDouble();
                    final pct = (value / expense * 100).round();
                    return pw.PieDataSet(
                      innerRadius: 45,
                      legend: '${data[0]}\n$pct%',
                      value: value,
                      color: color,
                      legendStyle: const pw.TextStyle(fontSize: 10),
                    );
                  }),
                ),
              ),
              pw.Flexible(
                child: pw.Chart(
                  grid: pw.PieGrid(),
                  datasets:
                      List<pw.Dataset>.generate(dataTable.length, (index) {
                    final data = dataTable[index];
                    final color = chartColors[index % chartColors.length];
                    final value = (data[2] as num).toDouble();
                    final pct = (value / expense * 100).round();
                    return pw.PieDataSet(
                      innerRadius: 45,
                      legend: '${data[0]}\n$pct%',
                      value: value,
                      color: color,
                      legendStyle: const pw.TextStyle(fontSize: 10),
                    );
                  }),
                ),
              ),
              pw.Flexible(
                child: pw.Chart(
                  grid: pw.PieGrid(),
                  datasets:
                      List<pw.Dataset>.generate(dataTable.length, (index) {
                    final data = dataTable[index];
                    final color = chartColors[index % chartColors.length];
                    final value = (data[2] as num).toDouble();
                    final pct = (value / expense * 100).round();
                    return pw.PieDataSet(
                      innerRadius: 45,
                      legend: '${data[0]}\n$pct%',
                      value: value,
                      color: color,
                      legendStyle: const pw.TextStyle(fontSize: 10),
                    );
                  }),
                ),
              ),
            ],
          );
        }),
  );

  // Return the PDF file content
  return document.save();
}
