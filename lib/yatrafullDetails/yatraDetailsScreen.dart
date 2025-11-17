import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
import 'package:yogayatra/viewpaymentdetails.dart';

import 'package:yogayatra/widgets/readmore.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:intl/intl.dart';
import 'package:yogayatra/yatrafullDetails/ViewTravelDetails.dart';

import 'package:yogayatra/yatrafullDetails/viewYatrispage.dart';

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
    fetchCoordinatorDetails();
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

  Map<String, dynamic>? coordinatorDetails;
  bool isLoadingCoordinator = true;

  Future<void> fetchCoordinatorDetails() async {
    try {
      final coordinatorId = widget.yatraData['yatraCoordinators'];
      print('yatra cordinator $coordinatorId');
      if (coordinatorId == null || coordinatorId.isEmpty) {
        print('No coordinator ID found in yatra details');
        setState(() {
          isLoadingCoordinator = false;
        });
        return;
      }

      print('Fetching coordinator with ID: $coordinatorId');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('coordinators')
          .where('userId', isEqualTo: coordinatorId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        coordinatorDetails = querySnapshot.docs.first.data();
        print('Fetched Coordinator Details: $coordinatorDetails');
      } else {
        print('No coordinator found for ID: $coordinatorId');
      }
    } catch (e) {
      print('Error fetching coordinator details: $e');
    }

    setState(() {
      isLoadingCoordinator = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    List<String> durationParts = yatraDuration.split(',');
    String nights = durationParts.length > 0 ? durationParts[0].trim() : 'N/A';
    String days = durationParts.length > 1 ? durationParts[1].trim() : 'N/A';
    final String status = widget.yatraData['status'] ?? '';
    final int totalSeats =
        int.tryParse(widget.yatraData['maxSeats'].toString()) ?? 0;
    final int filledSeats =
        int.tryParse(widget.yatraData['filledSeats'].toString()) ?? 0;

    final int availableSeats = totalSeats - filledSeats;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 22,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Yatra Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.chat, color: Colors.white),
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                children: [],
              ),
              Stack(children: [
                Builder(
                  builder: (context) {
                    final List<String> images =
                        (widget.yatraData['images'] is List)
                            ? List<String>.from(widget.yatraData['images'])
                            : [];

                    int _currentIndex = 0;

                    return StatefulBuilder(
                      builder: (context, setStateSB) {
                        return Stack(
                          children: [
                            CarouselSlider(
                              items: images.isNotEmpty
                                  ? images.map<Widget>((imgUrl) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imgUrl,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                            child: Icon(Icons.broken_image,
                                                size: 50),
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  : [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 60,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      )
                                    ],
                              options: CarouselOptions(
                                height: 200,
                                autoPlay: images.length > 1,
                                autoPlayInterval: const Duration(seconds: 3),
                                enlargeCenterPage: true,
                                viewportFraction: 0.9,
                                onPageChanged: (index, reason) {
                                  setStateSB(() => _currentIndex = index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 5,
                  left: 18,
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
                        Flexible(
                          flex: 2,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5)),
                                        color: Colors.green,
                                        border:
                                            Border.all(color: Colors.green)),
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 3),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Status',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 3, top: 3, right: 5),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.yatraData['status'] ?? 'N/A',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          flex: 1,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5)),
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.green)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Yatra Id',
                                        style: GoogleFonts.poppins(
                                            color: Colors.green,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                        color: Colors.green,
                                        border: Border.all(color: Colors.green),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 3),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.yatraData['yatraId'] ?? 'N/A',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Start Location
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      150, // same width for perfect alignment
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.green, size: 28),
                                      SizedBox(width: 6),
                                      Text(
                                        'Start Location',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.yatraData['yatraStarting'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12),

                            // End Location
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.green, size: 28),
                                      SizedBox(width: 6),
                                      Text(
                                        'End Location',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.yatraData['yatraEnding'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12),

                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      const Icon(
                                          Icons.airline_seat_recline_extra,
                                          color: Colors.green,
                                          size: 28),
                                      SizedBox(width: 6),
                                      Text(
                                        'Total Seats',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  widget.yatraData['maxSeats'] ?? 'N/A',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      const Icon(
                                          Icons.airline_seat_recline_extra,
                                          color: Colors.green,
                                          size: 28),
                                      SizedBox(width: 6),
                                      Text(
                                        'Filled Seats',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  widget.yatraData['filledSeats'].toString() ??
                                      'N/A',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      const Icon(
                                          Icons.airline_seat_recline_extra,
                                          color: Colors.green,
                                          size: 28),
                                      SizedBox(width: 6),
                                      Text(
                                        'Available Seats',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  availableSeats.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.currency_rupee,
                                          color: Colors.green, size: 28),
                                      SizedBox(width: 6),
                                      Text(
                                        'Per Person',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.currency_rupee,
                                        color: Colors.grey.shade600, size: 16),
                                    Text(
                                      widget.yatraData['yatraCost'] ?? 'N/A',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.black),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                            // Departure Date
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          color: Colors.green, size: 26),
                                      SizedBox(width: 6),
                                      Text(
                                        'Departure Date',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.yatraData['depature'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),

                            // Arrival Date
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          color: Colors.green, size: 26),
                                      SizedBox(width: 6),
                                      Text(
                                        'Arrival Date',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.yatraData['arrival'] ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
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
                                      "${(coordinatorDetails?['firstName'] ?? '')} ${(coordinatorDetails?['lastName'] ?? '')}",
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
                                          coordinatorDetails?['mobileNumber'] ??
                                              '';
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
                          Row(
                            children: [
                              const Icon(Icons.phone_android,
                                  color: Colors.grey, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                coordinatorDetails?['mobileNumber'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.email,
                                  color: Colors.grey, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  coordinatorDetails?['email'] ?? '',
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentDetailsScreen(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View Payment \nDetails',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () async {
                                exportToPDF(context, widget.yatraData);
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Download \nPDF',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewYatrisPage(
                                        yatraId: widget.yatraId,
                                        yatratitle:
                                            widget.yatraData['yatraTitle']),
                                  ),
                                );
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View \nYatris',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TravelDetails(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View Travel\nDetails',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      'Itinerary Details',
                      style: TextStyle(
                        color: Colors.green,
                        // fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    Text(
                      'Destinations',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    for (var highlights
                        in widget.yatraData['destinations'] ?? [])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    highlights,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Highlights',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    for (var highlights
                        in widget.yatraData['yatraHighlights'] ?? [])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 8,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    highlights,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Inclusions & Exclusions:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inclusions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    for (var inclusions in widget.yatraData['inclusions'] ?? [])
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  ' $inclusions',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Exclusions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    for (var inclusions in widget.yatraData['exclusions'] ?? [])
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  ' $inclusions',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
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

      final notes = [
        'Men: Dress code is dhoti or pyjamas with upper cloth.',
        'Women: Preferred dress code is saree, half-saree with blouse, or churidar with upper cloth.',
        'No age restrictions.',
        'Carry original Photo ID proof at the time of reporting.',
        'Temples do not allow electronic gadgets like mobiles or cameras inside.',
        'Darshan tickets are non-transferable.',
      ];

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
        .doc(SharedPrefServices.getUserId().toString())
        .get();
    print(SharedPrefServices.getUserId().toString());
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
