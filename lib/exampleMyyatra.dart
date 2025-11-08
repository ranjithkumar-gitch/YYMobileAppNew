import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yogayatra/paymentsScreens/bookingSummary.dart';

import 'package:yogayatra/widgets/expanddays.dart';
import 'package:yogayatra/widgets/readmore.dart';

class RegisteredStatusScreen extends StatefulWidget {
  final double totalAmount;
  final int numberOfPeople;
  const RegisteredStatusScreen(
      {super.key, required this.totalAmount, required this.numberOfPeople});

  @override
  State<RegisteredStatusScreen> createState() => _RegisteredStatusScreenState();
}

class _RegisteredStatusScreenState extends State<RegisteredStatusScreen> {
  @override
  Widget build(BuildContext context) {
    final List<LatLng> waypoints = [
      const LatLng(17.3850, 78.4867),
      const LatLng(17.3276, 78.6047),
      const LatLng(17.3642, 79.6797),
      const LatLng(17.0888, 79.6149),
      const LatLng(17.0568, 79.2685),
    ];

    final Polyline polyline = Polyline(
        polylineId: const PolylineId('waypoints'),
        color: Colors.blue,
        points: waypoints,
        width: 5);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 25,
                      )),
                  Text(
                    'Yatra Details',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              Stack(children: [
                Image.network(
                  'https://www.holidify.com/images/bgImages/SHIRDI.jpg',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                                      color: HexColor("#018a3c"),
                                      border: Border.all(
                                          color: HexColor("#018a3c"))),
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
                                    color: HexColor("#018a3c"),
                                    border:
                                        Border.all(color: HexColor("#018a3c"))),
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
                                    'Registered ',
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
                      'Hyderabad - Shiridi YogaYatra',
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
                                            color: HexColor("#018a3c"))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        'Yatra Id',
                                        style: GoogleFonts.poppins(
                                            color: HexColor("#018a3c"),
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
                                      color: HexColor("#018a3c"),
                                      border: Border.all(
                                          color: HexColor("#018a3c")),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        'YYP120',
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
                        SizedBox(
                          height: 30,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const YatraGallery()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#018a3c"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                'Gallery',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              )),
                        )
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
                                      'Origin',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Hyderabad',
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
                                      'Destination',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Shiridi',
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
                                      'MAR 25-2024',
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
                                      'MAR 29-2024',
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
                                      '10 of 50',
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
                                          '10,000/-',
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

                    const ReadMoreWidget(
                      longtext:
                          'Embarking on a 5-day journey from Hyderabad to Shirdi offers a profound spiritual experience with visits to significant temples and historical sites along the way. Beginning in Hyderabad, travelers can explore the ancient Bhadrachalam Temple dedicated to Lord Rama before continuing to Warangal, where the Thousand Pillar Temple and Warangal Fort stand as testaments to the region\'s rich heritage. Further, in Karimnagar, the Elgandal Fort and Kondagattu Anjaneya Swamy Temple provide glimpses into the area\'s historical and religious significance. Journeying on to Medak, visitors can marvel at the grandeur of the Medak Cathedral and pay homage at various ancient temples dotting the landscape. Finally, arriving in Shirdi, pilgrims find solace at the revered Sai Baba Temple complex, immersing themselves in the teachings and spirituality of the beloved saint. This meticulously crafted itinerary promises a blend of cultural exploration, historical appreciation, and spiritual enlightenment, making the Hyderabad to Shirdi tour a deeply enriching experience for the soul.',
                      shorttext:
                          'Bhadrachalam, Warangal, Karimnagar, Medak, Shiridi, Hyderabad',
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      'Itinerary',
                      style: TextStyle(
                        color: HexColor("#018a3c"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    DayContainer(
                      dayNumber: 1,
                      title: 'Arrive in Bhadrachalam',
                      description:
                          'Arrive in Bhadrachalam by AC bus coach. Check into accommodation rooms. Visit Lord Rama Temple . Enjoy breakfast, lunch, and dinner provided. Special darshan at the temple. Indulge in evening snacks. Overnight stay in Bhadrachalam, after enroute to Papikondalu ride along the Godavari River, meandering through the towering hills and experiencing the beauty of the Papikondalu up close.',
                      imageUrl:
                          'https://bhadrachalaramadasu.com/wp-content/uploads/2014/10/rrr.jpg',
                    ),

                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1.0,
                    ),

                    DayContainer(
                      dayNumber: 2,
                      title: 'Bhadrachalam to Warangal',
                      description:
                          'Arrive in Bhadrachalam by AC bus coach. Check into accommodation rooms. Visit Lord Rama Temple . Enjoy breakfast, lunch, and dinner provided. Special darshan at the temple. Indulge in evening snacks. Overnight stay in Bhadrachalam, after enroute to Papikondalu ride along the Godavari River, meandering through the towering hills and experiencing the beauty of the Papikondalu up close.',
                      imageUrl:
                          'https://bhadrachalaramadasu.com/wp-content/uploads/2014/10/rrr.jpg',
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1.0,
                    ),

                    DayContainer(
                      dayNumber: 3,
                      title: 'Warangal to Karminagar',
                      description:
                          'Arrive in Bhadrachalam by AC bus coach. Check into accommodation rooms. Visit Lord Rama Temple . Enjoy breakfast, lunch, and dinner provided. Special darshan at the temple. Indulge in evening snacks. Overnight stay in Bhadrachalam, after enroute to Papikondalu ride along the Godavari River, meandering through the towering hills and experiencing the beauty of the Papikondalu up close.',
                      imageUrl:
                          'https://bhadrachalaramadasu.com/wp-content/uploads/2014/10/rrr.jpg',
                    ),

                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1.0,
                    ),

                    DayContainer(
                      dayNumber: 4,
                      title: 'Karimnagar to Shiridi',
                      description:
                          'Arrive in Bhadrachalam by AC bus coach. Check into accommodation rooms. Visit Lord Rama Temple . Enjoy breakfast, lunch, and dinner provided. Special darshan at the temple. Indulge in evening snacks. Overnight stay in Bhadrachalam, after enroute to Papikondalu ride along the Godavari River, meandering through the towering hills and experiencing the beauty of the Papikondalu up close.',
                      imageUrl:
                          'https://bhadrachalaramadasu.com/wp-content/uploads/2014/10/rrr.jpg',
                    ),

                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1.0,
                    ),

                    DayContainer(
                      dayNumber: 5,
                      title: 'Return to Hyderabad',
                      description:
                          'Arrive in Bhadrachalam by AC bus coach. Check into accommodation rooms. Visit Lord Rama Temple . Enjoy breakfast, lunch, and dinner provided. Special darshan at the temple. Indulge in evening snacks. Overnight stay in Bhadrachalam, after enroute to Papikondalu ride along the Godavari River, meandering through the towering hills and experiencing the beauty of the Papikondalu up close.',
                      imageUrl:
                          'https://bhadrachalaramadasu.com/wp-content/uploads/2014/10/rrr.jpg',
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1.0,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      'Inclusions',
                      style: TextStyle(
                        color: HexColor("#018a3c"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: HexColor("#018a3c"),
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '9 nights accommodation',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: HexColor("#018a3c"),
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'All entrance fees to sacred sites',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: HexColor("#018a3c"),
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'All local transportation',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: HexColor("#018a3c"),
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Daily meals, drinks, snacks, & mineral water',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: HexColor("#018a3c"),
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Transport by A.C Hi Tech Coach',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      'Exclusions',
                      style: TextStyle(
                        color: HexColor("#018a3c"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      child: const Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 16,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                'Expenses of personal nature such as telephones,Cameras fees.etc',
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Any kind of entry tickets 5% GST.',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Anything not mentioned in inclusions.',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      'Payment terms',
                      style: TextStyle(
                        color: HexColor("#018a3c"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    const Text(
                      'You can pay by  Debit Card / Credit Card/ Internet Banking /NEFT/ UPI/ Wallet ',
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Map view',
                      style: TextStyle(
                        color: HexColor("#018a3c"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(17.3850, 78.4867),
                            zoom: 10,
                          ),
                          onTap: (_) {
                            _launchGoogleMap();
                          },
                          markers: {
                            const Marker(
                              markerId: MarkerId('Hyderabad'),
                              position: LatLng(17.3850, 78.4867),
                              infoWindow: InfoWindow(title: 'Hyderabad'),
                            ),
                            const Marker(
                              markerId: MarkerId('Hayathnagar'),
                              position: LatLng(17.3276, 78.6047),
                              infoWindow: InfoWindow(title: 'Hayathnagar'),
                            ),
                            const Marker(
                              markerId: MarkerId('Choutuppal'),
                              position: LatLng(17.3642, 79.6797),
                              infoWindow: InfoWindow(title: 'Choutuppal'),
                            ),
                            const Marker(
                              markerId: MarkerId('Chityala'),
                              position: LatLng(17.0888, 79.6149),
                              infoWindow: InfoWindow(title: 'Chityala'),
                            ),
                            const Marker(
                              markerId: MarkerId('Nalgonda'),
                              position: LatLng(17.0568, 79.2685),
                              infoWindow: InfoWindow(title: 'Nalgonda'),
                            ),
                          },
                          polylines: {
                            polyline,
                          },
                        ),
                      ),
                    ),

                    // Container(
                    //       height: 250,width: double.infinity,
                    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(10),
                    //         child: Image.network('https://www.google.com/maps/d/thumbnail?mid=1QjCTuKQXLiMWNynPuFGkmyt6SLQ&hl=en_US',fit: BoxFit.cover,)),
                    //       ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),

                    Text(
                      'Guidelines for travelers',
                      style: TextStyle(
                        color: HexColor("#018a3c"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      child: const Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.description,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                'Please take care of all your personal belongings & liggage throughout the trip',
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.description,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                'It is advisable to dress properly while visiting the temple to avoid inconvenience',
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.description,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                'Carry any personal medication/a samll firsst aid kit for emergencies',
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookingSummary(
                                          totalAmount: widget.totalAmount,
                                          numberOfPeople:
                                              widget.numberOfPeople)));
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: HexColor('#018a3c')),
                            child: Text(
                              "PAY NOW",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ))),

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

  _launchGoogleMap() async {
    const hyderabadCoordinates = "17.346963818901653, 78.55060023176189";
    const filmcityCoordintaes = "17.311621895586608, 78.68248350544282";
    const choutuppalCoordinates = "17.25437900517632, 78.89564602552935";
    const chityalaCoordinates = "17.2321768099796, 79.12663453073752";
    const nalgondaCoordinates = "17.057625015167677, 79.2689302656816";

    const googleMapUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$hyderabadCoordinates&destination=$nalgondaCoordinates&waypoints=$filmcityCoordintaes|$choutuppalCoordinates|$chityalaCoordinates';

    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}
