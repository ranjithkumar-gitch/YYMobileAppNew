import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'package:yogayatra/widgets/readmore.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yogayatra/yatrafullDetails/pdfGenerator.dart';

class Myyatralistview extends StatefulWidget {
  final Map<String, dynamic> yatraData;
  final String yatraId;

  const Myyatralistview({
    Key? key,
    required this.yatraData,
    required this.yatraId,
  }) : super(key: key);

  @override
  State<Myyatralistview> createState() => _MyyatralistviewState();
}

class _MyyatralistviewState extends State<Myyatralistview> {
  final Map<String, dynamic> yatraData = {
    "yatraTitle": "Ujjain-Gwalior YogaYatra",
    "yatraOverview":
        "The 'Sacred Pilgrimage: Hyderabad to Middle India' yatra offers a transformative journey through some of India's most revered spiritual sites...",
    "yatraStarting": "Hyderabad",
    "yatraEnding": "Hyderabad",
    "registrationOpen": "01-08-2024, 08:00 AM",
    "registrationClosed": "10-08-2024, 08:00 AM",
    "depature": "17-08-2024, 12:00 PM",
    "arrival": "22-08-2024, 05:30 AM",
    "yatraCost": "35000",
    "status": "Cancelled",
    "yatraHighlights": [
      "Mahakaleshwar Temple, Ujjain: Experience the divine atmosphere...",
      "Siddhavat, Ujjain: Engage in spiritual rituals...",
      "Mandu’s Architectural Marvels...",
    ],
    "destinations": ["Ujjain", "Mandu", "Khajuraho", "Sanchi", "Gwalior"],
    "images": [
      "https://firebasestorage.googleapis.com/v0/b/example/image1.jpg",
      "https://firebasestorage.googleapis.com/v0/b/example/image2.jpg"
    ]
  };
  bool isInterested = false;
  String? interestDocId;

  @override
  void initState() {
    super.initState();
    _checkInterestStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _requestPermissions(context);
    });
  }

  Future<void> _checkInterestStatus() async {
    try {
      // Get user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) return;

      // Check if the user already expressed interest
      var querySnapshot = await FirebaseFirestore.instance
          .collection('interested')
          .where('yatraId', isEqualTo: widget.yatraId)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isInterested = true;
          interestDocId = querySnapshot.docs.first.id;
        });
      } else {
        setState(() {
          isInterested = false;
          interestDocId = null;
        });
      }
    } catch (e) {
      print('Error checking interest status: $e');
    }
  }

  Future<void> _submitInterest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) return;

      var interestData = {
        'yatraId': widget.yatraId,
        'userId': userId,
        'interested': true,
        'addressed': false,
        'status': "",
        'description': "",
        'timestamp': FieldValue.serverTimestamp(),
      };

      var docRef = await FirebaseFirestore.instance
          .collection('interested')
          .add(interestData);

      setState(() {
        isInterested = true;
        interestDocId = docRef.id;
      });

      _showAlertDialog('Your interest has been recorded!');
    } catch (e) {
      print('Error submitting interest: $e');
    }
  }

  Future<void> _removeInterest() async {
    try {
      if (interestDocId == null) return;

      await FirebaseFirestore.instance
          .collection('interested')
          .doc(interestDocId)
          .delete();

      setState(() {
        isInterested = false;
        interestDocId = null;
      });

      _showAlertDialog('Your interest was removed.');
    } catch (e) {
      print('Error removing interest: $e');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Information'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Generate PDF
  // Future<File> _generatePdf() async {
  //   final pdf = pw.Document();

  //   // Add content to the PDF
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text(
  //               widget.yatraData['yatraTitle'] ?? 'Yatra Details',
  //               style:
  //                   pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(height: 16),
  //             pw.Text(
  //                 "Overview: ${widget.yatraData['yatraOverview'] ?? 'N/A'}"),
  //             pw.SizedBox(height: 8),
  //             pw.Text(
  //                 "Starting Point: ${widget.yatraData['yatraStarting'] ?? 'N/A'}"),
  //             pw.Text(
  //                 "Ending Point: ${widget.yatraData['yatraEnding'] ?? 'N/A'}"),
  //             pw.SizedBox(height: 8),
  //             pw.Text("Departure: ${widget.yatraData['depature'] ?? 'N/A'}"),
  //             pw.Text("Arrival: ${widget.yatraData['arrival'] ?? 'N/A'}"),
  //             pw.SizedBox(height: 8),
  //             pw.Text("Cost: ₹${widget.yatraData['yatraCost'] ?? 'N/A'}"),
  //             pw.Text(
  //                 "Seats: ${widget.yatraData['filledSeats'] ?? 'N/A'}/${widget.yatraData['maxSeats'] ?? 'N/A'}"),
  //             pw.SizedBox(height: 16),
  //             pw.Text("Destinations:",
  //                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //             pw.Bullet(
  //                 text: (widget.yatraData['destinations'] as List<dynamic>?)
  //                         ?.join(", ") ??
  //                     'N/A'),
  //             pw.SizedBox(height: 16),
  //             pw.Text("Highlights:",
  //                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //             ...((widget.yatraData['yatraHighlights'] as List<dynamic>?) ?? [])
  //                 .map((highlight) => pw.Bullet(text: highlight))
  //                 .toList(),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   // Save the PDF to external storage
  //   final outputDir = await _getStorageDirectory();
  //   final file = File("${outputDir.path}/yatra_details.pdf");
  //   await file.writeAsBytes(await pdf.save());

  //   return file;
  // }

  // // Get the external storage directory
  // Future<Directory> _getStorageDirectory() async {
  //   // Request storage permissions
  //   if (await Permission.storage.request().isGranted) {
  //     if (Platform.isAndroid) {
  //       final directory = await getExternalStorageDirectory();
  //       return directory ?? await getApplicationDocumentsDirectory();
  //     } else {
  //       return await getApplicationDocumentsDirectory();
  //     }
  //   } else {
  //     throw Exception('Storage permission not granted');
  //   }
  // }

  // // Download and save the PDF
  // Future<void> _downloadPdf(BuildContext context) async {
  //   try {
  //     final file = await _generatePdf();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('PDF saved at: ${file.path}')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to generate PDF: $e')),
  //     );
  //   }
  // }

  // // Request permission and handle PDF download
  // Future<void> _requestPermissions(BuildContext context) async {
  //   final status = await Permission.storage.request();

  //   if (status.isGranted) {
  //     // Permission granted, continue with PDF download logic
  //     _downloadPdf(context); // Pass context here
  //   } else {
  //     // Permission denied, show a message to the user
  //     print('Storage permission is required.');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Storage permission is required to download PDF.')),
  //     );
  //   }
  // }

// @override
// void initState() {
//   super.initState();
//   // Request permission before starting the PDF download process
//   _requestPermissions();
// }

  @override
  Widget build(
    BuildContext context,
  ) {
    final String status = widget.yatraData['status'] ?? '';
    final List<String> inclusions = [
      'Welcome drink on Arrival at hotel (non-Alcoholic)',
      'Accommodation on Double sharing basis at hotels.',
      'Meals (Daily Breakfast)',
      'All hotel taxes.',
      'Driver T. A. D. A, Fuel Charges, Parking Fee, State Taxes',
      'Sightseeing as per above Itinerary by Individual Vehicle',
      'All taxes except 5% GST',
    ];

    final List<String> exclusions = [
      'Expenses of personal nature such as tipping, porters, laundry, telephones, Cameras fees etc.',
      'Entrance fees at any point.',
      'Any kind of insurance.',
      'Any Train, Airline’s fare, Ferry charges, Boating etc.',
      'Any claim or delay charges due to natural calamities, landslide, road blockage etc.',
      'Rates are not Valid during Peak Season and festival holidays.',
    ];

    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Colors.green,
      //     title: Text(
      //       'Yatra Details',
      //       style: GoogleFonts.poppins(
      //           fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
      //     )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 20,
                  )
                  // IconButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     icon: const Icon(
                  //       Icons.arrow_back,
                  //       color: Colors.white,
                  //       size: 25,
                  //     )),
                  // Text(
                  //   'Yatra Details',
                  //   style: GoogleFonts.poppins(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black),
                  // )
                ],
              ),
              Stack(children: [
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.yatraData['images']?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(
                          widget.yatraData['images'][index],
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 5,
                  right: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          width: 170,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)),
                                      color: Colors.green,
                                      border: Border.all(
                                        color: Colors.green,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.wb_sunny,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '5 Days',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.nightlight_round,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '4 Nights',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.green,
                                    )),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 3),
                                  child: Text(
                                    'Status  ',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Container(
                                height: 25,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 3),
                                  child: Text(
                                    widget.yatraData['status'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.yatraData['yatraTitle'] ?? 'Yatra Details',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            width: 150,
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5)),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.green,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        'Yatra Id',
                                        style: GoogleFonts.poppins(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                      color: Colors.green,
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        widget.yatraData['yatraId'] ?? 'N/A',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        //   width: 100,
                        //   child: ElevatedButton(
                        //       onPressed: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) =>
                        //                     const YatraGallery()));
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //           backgroundColor: HexColor("#018a3c"),
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10))),
                        //       child: Text(
                        //         'Gallery',
                        //         style: GoogleFonts.poppins(
                        //             color: Colors.white,
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.w500),
                        //       )),
                        // )
                      ],
                    ),
                    // Text('Yatra Id',style: GoogleFonts.poppins(color: Colors.black ,fontSize: 16,fontWeight: FontWeight.w500),),
                    //  Text('YYP108',style: GoogleFonts.poppins(color: HexColor("#018a3c"),fontSize: 14,fontWeight: FontWeight.w500),),

                    const SizedBox(
                      height: 15,
                    ),

                    //  const  Divider(color: Colors.grey,thickness: 1.0,),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.departure_board,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      'Starting',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.yatraData['yatraStarting'] ??
                                          'N/A',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      'Ending',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.yatraData['yatraEnding'] ?? 'N/A',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Depature date',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.yatraData['depature'] ?? 'N/A',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      'Arrival date',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.yatraData['arrival'] ?? 'N/A',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 25),
                                      child: Icon(
                                        Icons.directions_bus,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Seats availabile',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.yatraData['maxSeats'] ?? 'N/A',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.currency_rupee,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      'Pricing',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          color: Colors.grey.shade600,
                                          size: 15,
                                        ),
                                        Text(
                                          widget.yatraData['yatraCost'] ??
                                              'N/A',
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          'PP',
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    ReadMoreWidget(
                      longtext: widget.yatraData['yatraOverview'] ?? 'N/A',
                      shorttext: widget.yatraData['title'] ?? 'N/A',
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),

                    Text(
                      'Itinerary',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // for (var day in yatraData['itineraryDetails'] ?? [])
                    //   Padding(
                    //     padding: const EdgeInsets.only(bottom: 8.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Text('Day ${day['day']}: ${day['title']}',
                    //                 style: TextStyle(
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Colors.green)),
                    //           ],
                    //         ),
                    //         Text(day['subject']),
                    //       ],
                    //     ),
                    //   ),
                    widget.yatraData['itineraryDetails'] != null &&
                            widget.yatraData['itineraryDetails'].isNotEmpty
                        ? QuillEditor(
                            controller: QuillController(
                              readOnly: true,
                              document: Document.fromJson(jsonDecode(
                                  widget.yatraData['itineraryDetails'])),
                              selection:
                                  const TextSelection.collapsed(offset: 0),
                            ),
                            scrollController: ScrollController(),
                            focusNode: FocusNode(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "No itinerary details added.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                    // const SizedBox(
                    //   height: 200,
                    //   width: double.infinity,
                    //   child: Center(
                    //     child: Text(
                    //       'Itinerary details are not added',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox.shrink(),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 16),
                    Text('Destinations:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                    for (var destination
                        in widget.yatraData['destinations'] ?? [])
                      Text('- $destination'),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Highlights:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    for (var highlight
                        in widget.yatraData['yatraHighlights'] ?? [])
                      Text('- $highlight'),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    YatraInclusionExclusion(
                      inclusions: inclusions,
                      exclusions: exclusions,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 0.5,
                            dashLength: 1.5,
                            dashColor: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: Column(
                              children: [
                                _buildNoteRow(
                                  context,
                                  'Men: For men the dress code is dhoti or pyjamas with upper cloth.',
                                ),
                                _buildNoteRow(
                                  context,
                                  'Women: For women the preferred dress code is saree or half-saree with blouse or churidar with pyjama and upper cloth.',
                                ),
                                _buildNoteRow(
                                  context,
                                  'No Age limit restrictions.',
                                ),
                                _buildNoteRow(
                                  context,
                                  'Pilgrims who book for Darshan should bring the printed copy of their receipt.',
                                ),
                                _buildNoteRow(
                                  context,
                                  'All devotees required to carry original Photo ID proof at the time of reporting.',
                                ),
                                _buildNoteRow(
                                  context,
                                  'Most temples do not allow electronic gadgets like mobile phones, cameras, etc. inside the temple.',
                                ),
                                _buildNoteRow(
                                  context,
                                  'Darshan tickets are non-transferable.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    if (status == 'Registration Open' || status == 'New') ...[
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed:
                              isInterested ? _removeInterest : _submitInterest,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                isInterested ? Colors.red : Colors.green,
                          ),
                          child: Text(
                            isInterested
                                ? "I am not interested"
                                : "I am interested",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ] else
                      const SizedBox.shrink(),
                    ElevatedButton(
                      onPressed: () async {
                        final pdfGenerator = PdfGenerator();
                        await pdfGenerator.generateAndSavePdf(yatraData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("PDF downloaded successfully!")),
                        );
                      },
                      child: Text("Download PDF"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteRow(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.circle,
            color: Colors.green,
            size: 8,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class YatraInclusionExclusion extends StatefulWidget {
  final List<String> inclusions;
  final List<String> exclusions;

  const YatraInclusionExclusion({
    Key? key,
    required this.inclusions,
    required this.exclusions,
  }) : super(key: key);

  @override
  _YatraInclusionExclusionState createState() =>
      _YatraInclusionExclusionState();
}

class _YatraInclusionExclusionState extends State<YatraInclusionExclusion> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inclusions & Exclusions',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inclusions',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ...widget.inclusions.map((point) => Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 10,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        )),
                    const SizedBox(height: 10),
                    Text(
                      'Exclusions',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ...widget.exclusions.map((point) => Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 10,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        )),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 5),
            const DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 0.5,
              dashLength: 1.5,
              dashColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
