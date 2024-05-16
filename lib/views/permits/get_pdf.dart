import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfCertificate extends StatefulWidget {
  const PdfCertificate({super.key});

  @override
  State<PdfCertificate> createState() => _PdfCertificateState();
}

class _PdfCertificateState extends State<PdfCertificate> {
  final image = pw.MemoryImage(
    File('assets/images/love.png').readAsBytesSync(),
  );
  Future<void> documentGenerator() async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(
      File('assets/images/love.png').readAsBytesSync(),
    );
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // return pw.Center(
          // child: pw.Text('Hello World!'),
          // );

          return pw.Column(children: [
            pw.Center(
              child: pw.Text("Certificate For Permit"),
            ),
            pw.SizedBox(height: 40),
            pw.Center(
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Image(image),
              ),
            ),
          ]);
        },
      ),
    );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
