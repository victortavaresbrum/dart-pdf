import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:printing_demo/examples/report2.dart';

import 'data.dart';
import 'examples/calendar.dart';
import 'examples/certificate.dart';
import 'examples/document.dart';
import 'examples/invoice.dart';
import 'examples/report.dart';
import 'examples/resume.dart';

const examples = <Example>[
  Example('RÉSUMÉ', 'resume.dart', generateResume),
  Example('DOCUMENT', 'document.dart', generateDocument),
  Example('INVOICE', 'invoice.dart', generateInvoice),
  Example('REPORT', 'report.dart', generateReport),
  Example('CALENDAR', 'calendar.dart', generateCalendar),
  Example('CERTIFICATE', 'certificate.dart', generateCertificate, true),
];

const testandoExemplos = <Example>[
  Example('REPORT2', 'report2.dart', generateReportTwo),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
