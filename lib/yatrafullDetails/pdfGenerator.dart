import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  Future<Uint8List> fetchImageBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to load image");
    }
  }

  Future<void> generateAndSavePdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // Fetch image bytes for all image URLs
    List<pw.Widget> imageWidgets = [];
    for (String url in data['images']) {
      try {
        final imageBytes = await fetchImageBytes(url);
        final image = pw.MemoryImage(imageBytes);
        imageWidgets.add(pw.Image(image, height: 100, fit: pw.BoxFit.cover));
      } catch (e) {
        imageWidgets.add(pw.Text("Image failed to load: $url"));
      }
    }

    // Adding content to the PDF
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(data['yatraTitle'] ?? 'Yatra Title',
              style:
                  pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text("Overview:",
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Text(data['yatraOverview'] ?? 'N/A'),
          pw.SizedBox(height: 10),
          pw.Text("Details:",
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Bullet(text: "Starting Point: ${data['yatraStarting']}"),
          pw.Bullet(text: "Ending Point: ${data['yatraEnding']}"),
          pw.Bullet(text: "Registration Open: ${data['registrationOpen']}"),
          pw.Bullet(text: "Registration Closed: ${data['registrationClosed']}"),
          pw.Bullet(text: "Departure: ${data['depature']}"),
          pw.Bullet(text: "Arrival: ${data['arrival']}"),
          pw.Bullet(text: "Cost: ₹${data['yatraCost']}"),
          pw.Bullet(text: "Status: ${data['status']}"),
          pw.SizedBox(height: 10),
          pw.Text("Yatra Highlights:",
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ...?data['yatraHighlights']
              ?.map((highlight) => pw.Bullet(text: highlight)),
          pw.SizedBox(height: 10),
          pw.Text("Destinations:",
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ...?data['destinations']
              ?.map((destination) => pw.Bullet(text: destination)),
          pw.SizedBox(height: 10),
          pw.Text("Images:",
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ...imageWidgets,
        ],
      ),
    );

    // Save the PDF to the device
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/${data['yatraTitle']}.pdf");
    await file.writeAsBytes(await pdf.save());

    print("PDF saved to ${file.path}");
  }
}
