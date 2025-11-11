import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
import 'package:yogayatra/viewpaymentdetails.dart';

import 'package:yogayatra/widgets/readmore.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yogayatra/yatrafullDetails/mapView.dart';
import 'package:yogayatra/yatrafullDetails/pdfGenerator.dart';

import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_quill/flutter_quill.dart';

class YatraDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> yatraData;
  final String yatraId;

  const YatraDetailsScreen({
    Key? key,
    required this.yatraData,
    required this.yatraId,
  }) : super(key: key);

  @override
  State<YatraDetailsScreen> createState() => _YatraDetailsScreenState();
}

class _YatraDetailsScreenState extends State<YatraDetailsScreen> {
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
  String calculateDaysAndNights(
      String departureDateTimeStr, String arrivalDateTimeStr) {
    if (departureDateTimeStr.isEmpty || arrivalDateTimeStr.isEmpty) {
      return 'N/A';
    }

    try {
      final dateFormat = DateFormat("dd-MM-yyyy, hh:mm a");

      final departureDateTime = dateFormat.parse(departureDateTimeStr);
      final arrivalDateTime = dateFormat.parse(arrivalDateTimeStr);

      final departureDate = DateTime(departureDateTime.year,
          departureDateTime.month, departureDateTime.day);
      final arrivalDate = DateTime(
          arrivalDateTime.year, arrivalDateTime.month, arrivalDateTime.day);

      final difference = arrivalDate.difference(departureDate).inDays;
      final days = difference + 1;
      final nights = difference;

      return "$nights Nights , $days Days";
    } catch (e) {
      return 'Invalid date';
    }
  }

  bool isInterested = false;
  String? interestDocId;

  late String yatraDuration;

  @override
  void initState() {
    super.initState();
    _checkInterestStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _requestPermissions(context);
    });
    yatraDuration = calculateDaysAndNights(
      widget.yatraData['depature'] ?? '',
      widget.yatraData['arrival'] ?? '',
    );
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

  @override
  Widget build(
    BuildContext context,
  ) {
    List<String> durationParts = yatraDuration.split(',');
    String nights = durationParts.length > 0 ? durationParts[0].trim() : 'N/A';
    String days = durationParts.length > 1 ? durationParts[1].trim() : 'N/A';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Yatra Details',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // SizedBox(
                  //   height: 20,
                  // )
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
                                          days,
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
                                          nights,
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
                          color: Colors.green,
                          // fontSize: 16,
                          fontWeight: FontWeight.bold),
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
                                            // fontSize: 16,
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
                                            // fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    //  const  Divider(color: Colors.grey,thickness: 1.0,),

                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(color: Colors.grey)),
                    //   child: Column(
                    //     children: [
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //       Container(
                    //         margin: const EdgeInsets.only(right: 15, left: 15),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 const Icon(
                    //                   Icons.departure_board,
                    //                   color: Colors.green,
                    //                 ),
                    //                 Text(
                    //                   'Starting',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Colors.black,
                    //                       // fontSize: 15,
                    //                       fontWeight: FontWeight.w500),
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 Text(
                    //                   widget.yatraData['yatraStarting'] ??
                    //                       'N/A',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Colors.grey.shade600,
                    //                       fontSize: 14,
                    //                       fontWeight: FontWeight.w400),
                    //                 ),
                    //               ],
                    //             ),
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 const Icon(
                    //                   Icons.location_on,
                    //                   color: Colors.green,
                    //                 ),
                    //                 Text(
                    //                   'Ending',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Colors.black,
                    //                       // fontSize: 15,
                    //                       fontWeight: FontWeight.w500),
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 Text(
                    //                   widget.yatraData['yatraEnding'] ?? 'N/A',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Colors.grey.shade600,
                    //                       // fontSize: 14,
                    //                       fontWeight: FontWeight.w400),
                    //                 ),
                    //               ],
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //       Container(
                    //         margin: const EdgeInsets.only(right: 15, left: 15),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 const Padding(
                    //                   padding: EdgeInsets.only(right: 25),
                    //                   child: Icon(
                    //                     Icons.directions_bus,
                    //                     color: Colors.green,
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   'Seats availabile',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Colors.black,
                    //                       // fontSize: 15,
                    //                       fontWeight: FontWeight.w500),
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 Text(
                    //                   widget.yatraData['maxSeats'] ?? 'N/A',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Colors.grey.shade600,
                    //                       // fontSize: 14,
                    //                       fontWeight: FontWeight.w400),
                    //                 ),
                    //               ],
                    //             ),
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 const Icon(
                    //                   Icons.currency_rupee,
                    //                   color: Colors.green,
                    //                 ),
                    //                 Text(
                    //                   'Pricing',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Colors.black,
                    //                       // fontSize: 15,
                    //                       fontWeight: FontWeight.w500),
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Icon(
                    //                       Icons.currency_rupee,
                    //                       color: Colors.grey.shade600,
                    //                       // size: 15,
                    //                     ),
                    //                     Text(
                    //                       widget.yatraData['yatraCost'] ??
                    //                           'N/A',
                    //                       style: GoogleFonts.poppins(
                    //                           color: Colors.grey.shade600,
                    //                           // fontSize: 14,
                    //                           fontWeight: FontWeight.w400),
                    //                     ),
                    //                     Text(
                    //                       'PP',
                    //                       style: GoogleFonts.poppins(
                    //                           color: Colors.grey.shade600,
                    //                           // fontSize: 14,
                    //                           fontWeight: FontWeight.w400),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ],
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 20,
                    //       ),
                    //       Container(
                    //         margin: const EdgeInsets.only(right: 15, left: 15),
                    //         child: Column(
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 const Padding(
                    //                   padding: EdgeInsets.only(right: 20),
                    //                   child: Icon(
                    //                     Icons.calendar_month,
                    //                     color: Colors.green,
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   children: [
                    //                     Text(
                    //                       'Depature date ',
                    //                       style: GoogleFonts.poppins(
                    //                           color: Colors.black,
                    //                           // fontSize: 15,
                    //                           fontWeight: FontWeight.w500),
                    //                     ),
                    //                     Text(
                    //                       widget.yatraData['depature'] ?? 'N/A',
                    //                       style: GoogleFonts.poppins(
                    //                           color: Colors.grey.shade600,
                    //                           // fontSize: 14,
                    //                           fontWeight: FontWeight.w400),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 20,
                    //             ),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 const Padding(
                    //                   padding: EdgeInsets.only(right: 20),
                    //                   child: Icon(
                    //                     Icons.calendar_month,
                    //                     color: Colors.green,
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   children: [
                    //                     Text(
                    //                       'Arrival date ',
                    //                       style: GoogleFonts.poppins(
                    //                           color: Colors.black,
                    //                           // fontSize: 15,
                    //                           fontWeight: FontWeight.w500),
                    //                     ),
                    //                     Text(
                    //                       widget.yatraData['arrival'] ?? 'N/A',
                    //                       style: GoogleFonts.poppins(
                    //                           color: Colors.grey.shade600,
                    //                           // fontSize: 14,
                    //                           fontWeight: FontWeight.w400),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// 🔹 Starting & Ending Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.departure_board,
                                      color: Colors.green, size: 28),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Starting',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    widget.yatraData['yatraStarting'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: Colors.grey.shade300,
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.green, size: 28),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Ending',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    widget.yatraData['yatraEnding'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// 🔹 Seats & Pricing Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.directions_bus,
                                      color: Colors.green, size: 28),
                                  const SizedBox(height: 6),
                                  Center(
                                    child: Text(
                                      'Seats Available',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.yatraData['maxSeats'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: Colors.grey.shade300,
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.currency_rupee,
                                      color: Colors.green, size: 28),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Pricing',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.currency_rupee,
                                          color: Colors.grey.shade600,
                                          size: 16),
                                      Text(
                                        widget.yatraData['yatraCost'] ?? 'N/A',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        ' /Person',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// 🔹 Dates Section
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_month,
                                      color: Colors.green, size: 26),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Departure Date',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        widget.yatraData['depature'] ?? 'N/A',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_month,
                                      color: Colors.green, size: 26),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Arrival Date',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        widget.yatraData['arrival'] ?? 'N/A',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Coordinator details',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 2),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      widget.yatraData['coordinatorName'] ??
                                          'Rajendranath',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      final phone =
                                          widget.yatraData['coordinatorPhone'];
                                      if (phone != null && phone.isNotEmpty) {
                                        launchUrl(Uri.parse('tel:$phone'));
                                      }
                                    },
                                    child: const Icon(
                                      Icons.call,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.chat,
                                      color: Colors.green,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          /// 🔹 Coordinator Mobile Number
                          Row(
                            children: [
                              const Icon(Icons.phone_android,
                                  color: Colors.grey, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "+919999399993",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          /// 🔹 Coordinator Email
                          Row(
                            children: [
                              const Icon(Icons.email,
                                  color: Colors.grey, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "rajendranath@gmail.com" ?? 'N/A',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
                        // fontSize: 16,
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
                                // fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),

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
                                // fontSize: 16,
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
                    // if (status == 'Registration Open' || status == 'New') ...[
                    //   SizedBox(
                    //     width: double.infinity,
                    //     height: 45,
                    //     child: ElevatedButton(
                    //       onPressed:
                    //           isInterested ? _removeInterest : _submitInterest,
                    //       style: ElevatedButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //         backgroundColor:
                    //             isInterested ? Colors.red : Colors.green,
                    //       ),
                    //       child: Text(
                    //         isInterested
                    //             ? "I am not interested"
                    //             : "I am interested",
                    //         style: GoogleFonts.poppins(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(height: 15),
                    // ] else
                    //   const SizedBox.shrink(),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentDetailsScreen()),
                          );
                        },
                        child: Text(
                          'View Payment Details',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        exportToPDF(context, widget.yatraData);
                        // final pdfGenerator = PdfGenerator();
                        // await pdfGenerator.generateAndSavePdf(yatraData);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content: Text("PDF downloaded successfully!")),
                        // );
                      },
                      child: Center(
                        child: Text(
                          "Download PDF",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    const SizedBox(height: 15),
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
                  // fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> exportToPDF(
      BuildContext context, Map<String, dynamic> yatraFullDetails) async {
    try {
      final pdf = pw.Document();
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

      // Extract and process data
      final yatraId = yatraFullDetails['yatraId'] ?? 'yatraId';

      final title = yatraFullDetails['yatraTitle'] ?? 'Yatra';
      final overview =
          yatraFullDetails['yatraOverview'] ?? 'No overview available.';
      final destinations =
          (yatraFullDetails['destinations'] as List<dynamic>).join(' - ');
      final departureDate = yatraFullDetails['depature'];
      final arrivalDate = yatraFullDetails['arrival'];

      // Format dates
      final inputFormat = DateFormat('dd-MM-yyyy, HH:mm a');
      final departure = inputFormat.parse(departureDate);
      final arrival = inputFormat.parse(arrivalDate);

      final formattedDeparture = DateFormat('dd MMM').format(departure);
      final formattedArrival = DateFormat('dd MMM yyyy').format(arrival);
      final dateRange = '$formattedDeparture - $formattedArrival';

      // Extract itinerary details
      final plainTextItinerary =
          yatraFullDetails['itineraryDetails']?.isNotEmpty == true
              ? getPlainTextFromQuillEditor(
                  QuillController(
                    readOnly: true,
                    document: Document.fromJson(
                        jsonDecode(yatraFullDetails['itineraryDetails'])),
                    selection: const TextSelection.collapsed(offset: 0),
                  ),
                )
              : 'No itinerary details available.';

      // Split long texts for better rendering
      final itineraryChunks = splitTextByWords(plainTextItinerary, 150);

      // Notes for Yatra
      final notes = [
        'Men: Dress code is dhoti or pyjamas with upper cloth.',
        'Women: Preferred dress code is saree, half-saree with blouse, or churidar with upper cloth.',
        'No age restrictions.',
        'Carry original Photo ID proof at the time of reporting.',
        'Temples do not allow electronic gadgets like mobiles or cameras inside.',
        'Darshan tickets are non-transferable.',
      ];

      // Table data
      final tableHeaders = ['Title', 'Details'];
      final tableData = [
        ['Starting', yatraFullDetails['yatraStarting']],
        ['Ending', yatraFullDetails['yatraEnding']],
        ['Status', yatraFullDetails['status']],
        ['Registration Open', yatraFullDetails['registrationOpen']],
        ['Registration Closed', yatraFullDetails['registrationClosed']],
        [
          'Cost',
          NumberFormat.decimalPattern('en_IN').format(
              int.tryParse(yatraFullDetails['yatraCost'].toString() ?? '') ?? 0)
        ],
        ['Maximum Seats', yatraFullDetails['maxSeats']],
        ['Minimum Seats', yatraFullDetails['miniSeats']],
        ['Booked Seats', yatraFullDetails['filledSeats'].toString()],
        [
          'Available Seats',
          (int.parse(yatraFullDetails['currentSeats'].toString()) -
                  int.parse(yatraFullDetails['filledSeats'].toString()))
              .toString()
        ],
        ['Departure', departureDate],
        ['Arrival', arrivalDate],
      ];

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          header: (context) {
            return pw.Header(
              outlineColor: pw.GridPaper.lineColor,
              level: 0,
              child: pw.Center(
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          yatraId,
                          style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(
                          width: 5,
                        ),
                        pw.Text(
                          title,
                          style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.SizedBox(
                      width: 300,
                      child: pw.Column(
                        children: [
                          pw.Text(
                            '$destinations',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            dateRange,
                            style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          build: (context) => [
            pw.SizedBox(height: 15),
            pw.Text(
              'Yatra Overview:',
              style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              overview,
              style: const pw.TextStyle(
                  fontSize: 12, height: 2.0, color: PdfColors.black),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Inclusions:',
              style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black),
            ),
            pw.SizedBox(height: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: inclusions
                  .map((inclusion) => pw.Bullet(
                        text: inclusion,
                        style: const pw.TextStyle(
                            fontSize: 12, color: PdfColors.black),
                        bulletColor: PdfColors.green,
                      ))
                  .toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Exclusions:',
              style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black),
            ),
            pw.SizedBox(height: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: exclusions
                  .map((exclusion) => pw.Bullet(
                        text: exclusion,
                        style: const pw.TextStyle(
                            fontSize: 12, color: PdfColors.black),
                        bulletColor: PdfColors.red,
                      ))
                  .toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Note:',
              style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black),
            ),
            pw.SizedBox(height: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: notes
                  .map((note) => pw.Bullet(
                        text: note,
                        style: const pw.TextStyle(
                            fontSize: 12, color: PdfColors.black),
                        bulletColor: PdfColors.grey,
                      ))
                  .toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Yatra Details:',
              style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black),
            ),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: PdfColors.green),
              cellStyle: const pw.TextStyle(fontSize: 12),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
              },
            ),
            pw.SizedBox(height: 20),
            // pw.Text(
            //   'Itinerary Details:',
            //   style: pw.TextStyle(
            //       fontSize: 15,
            //       fontWeight: pw.FontWeight.bold,
            //       color: PdfColors.black),
            // ),
            pw.SizedBox(height: 5),
            // if (itineraryStyledText.isNotEmpty)
            //   ..._renderRichText(itineraryStyledText)
            // else
            //   pw.Text(
            //     'Itinerary Details Not Updated',
            //     style: pw.TextStyle(
            //       fontSize: 12,
            //       fontStyle: pw.FontStyle.normal,
            //       color: PdfColors.black,
            //     ),
            //   ),

            // pw.Paragraph(
            //   text: itineraryChunks.join(' '),
            //   style: pw.TextStyle(
            //     fontSize: 12,
            //     color: PdfColors.black,
            //     height: 1.5,
            //   ),
            // ),
            pw.SizedBox(height: 5),
          ],
        ),
      );

      // Save PDF to mobile storage
      // final directory = await getApplicationDocumentsDirectory();
      // final filePath = '${directory.path}/YatraView.pdf';
      // final file = File(filePath);
      // await file.writeAsBytes(await pdf.save());
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/YatraView.pdf';
      await File(filePath).writeAsBytes(await pdf.save());
      print(filePath);
      // Show success message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('PDF saved at $filePath')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error exporting PDF: $e')));
    }
  }

  List<String> splitTextByWords(String text, int maxLength) {
    List<String> chunks = [];
    StringBuffer currentChunk = StringBuffer();
    for (var word in text.split(' ')) {
      if ((currentChunk.length + word.length + 1) <= maxLength) {
        if (currentChunk.isNotEmpty) currentChunk.write(' ');
        currentChunk.write(word);
      } else {
        chunks.add(currentChunk.toString());
        currentChunk.clear();
        currentChunk.write(word);
      }
    }
    if (currentChunk.isNotEmpty) chunks.add(currentChunk.toString());
    return chunks;
  }

  String getPlainTextFromQuillEditor(QuillController controller) {
    return controller.document.toPlainText();
  }

  Future<List<Map<String, dynamic>>> fetchNavigationPlaces() async {
    final yatraDoc = await FirebaseFirestore.instance
        .collection('yatras')
        .doc(SharedPrefServices.getuserId().toString())
        .get();
    print(SharedPrefServices.getuserId().toString());
    final data = yatraDoc.data()!;
    return List<Map<String, dynamic>>.from(data['navigationPlaces']);
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
                    // fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Icon(
                //   _isExpanded
                //       ? Icons.keyboard_arrow_up
                //       : Icons.keyboard_arrow_down,
                //   color: Colors.black,
                // ),
              ],
            ),
            // if (_isExpanded) ...[
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inclusions',
                    style: GoogleFonts.poppins(
                      // fontSize: 14,
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
                                // size: 10,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  point,
                                  style: GoogleFonts.poppins(
                                    // fontSize: 14,
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
                      // fontSize: 14,
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
                                // size: 10,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  point,
                                  style: GoogleFonts.poppins(
                                    // fontSize: 14,
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
