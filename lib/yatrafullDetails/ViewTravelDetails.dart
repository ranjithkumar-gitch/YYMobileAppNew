// import 'package:flutter/material.dart';

// class TravelDetails extends StatefulWidget {
//   const TravelDetails({super.key});

//   @override
//   State<TravelDetails> createState() => _TravelDetailsState();
// }

// class _TravelDetailsState extends State<TravelDetails>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff7f2f5),
//       appBar: AppBar(
//         backgroundColor: const Color(0xfff7f2f5),
//         elevation: 0,
//         title:
//             const Text('Travel Details', style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.black),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.deepPurple,
//           labelColor: Colors.black,
//           tabs: const [
//             Tab(text: 'Onward Train'),
//             Tab(text: 'Accommodation'),
//             Tab(text: 'Return Train'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _ticketCard(),
//           _accommodationCard(),
//           _returnTicketCard(),
//         ],
//       ),
//     );
//   }

//   Widget _ticketCard() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _header('8639219'),
//           const SizedBox(height: 16),
//           _passengerCard(
//             name: 'Rahul Kumar',
//             seat: 'C2 / Seat 34',
//             bookingCode: 'A7390',
//           ),
//           const SizedBox(height: 20),
//           _trainJourney(
//             departureTime: '06:00 AM',
//             departureDate: 'Sat, 15 Feb',
//             fromCity: 'Chennai',
//             fromStation: 'Chennai Central',
//             duration: '4 h 25 m',
//             arrivalTime: '10:25 AM',
//             arrivalDate: 'Sat, 15 Feb',
//             toCity: 'Bangalore',
//             toStation: 'Bangalore City',
//           )
//         ],
//       ),
//     );
//   }

//   Widget _returnTicketCard() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _header('9876543'),
//           const SizedBox(height: 16),
//           _passengerCard(
//             name: 'Rahul Kumar',
//             seat: 'D1 / Seat 22',
//             bookingCode: 'R5621',
//           ),
//           const SizedBox(height: 20),
//           _trainJourney(
//             departureTime: '03:00 PM',
//             departureDate: 'Tue, 18 Feb',
//             fromCity: 'Bangalore',
//             fromStation: 'Bangalore City',
//             duration: '4 h 25 m',
//             arrivalTime: '07:25 PM',
//             arrivalDate: 'Tue, 18 Feb',
//             toCity: 'Chennai',
//             toStation: 'Chennai Central',
//           )
//         ],
//       ),
//     );
//   }

//   Widget _accommodationCard() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _header('HTL789456'),
//           const SizedBox(height: 16),
//           _hotelCard(
//             hotelName: 'The Grand Residency',
//             location: 'MG Road, Bangalore',
//             checkIn: '15 Feb 2025',
//             checkOut: '18 Feb 2025',
//             roomType: 'Deluxe Suite',
//             guestName: 'Rahul Kumar',
//           )
//         ],
//       ),
//     );
//   }

//   Widget _header(String id) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('ID $id',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _passengerCard(
//       {required String name,
//       required String seat,
//       required String bookingCode}) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xffe9b7b9),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _labelValue('Full Name', name),
//               _labelValue('Seat Place', seat),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             height: 70,
//             color: Colors.white,
//           ),
//           const SizedBox(height: 8),
//           Center(
//             child: Text('Booking Code $bookingCode',
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _hotelCard(
//       {required String hotelName,
//       required String location,
//       required String checkIn,
//       required String checkOut,
//       required String roomType,
//       required String guestName}) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _labelValue('Hotel Name', hotelName),
//           _labelValue('Location', location),
//           _labelValue('Check-in', checkIn),
//           _labelValue('Check-out', checkOut),
//           _labelValue('Room Type', roomType),
//           _labelValue('Guest Name', guestName),
//         ],
//       ),
//     );
//   }

//   Widget _labelValue(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(color: Colors.black54, fontSize: 12)),
//         const SizedBox(height: 4),
//         Text(value,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _trainJourney({
//     required String departureTime,
//     required String departureDate,
//     required String fromCity,
//     required String fromStation,
//     required String duration,
//     required String arrivalTime,
//     required String arrivalDate,
//     required String toCity,
//     required String toStation,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Train Journey',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(departureTime,
//                       style: const TextStyle(
//                           fontSize: 22, fontWeight: FontWeight.bold)),
//                   Text(departureDate),
//                 ],
//               ),
//               const SizedBox(width: 20),
//               Column(
//                 children: [
//                   const Icon(Icons.radio_button_unchecked,
//                       color: Colors.purple),
//                   Container(width: 2, height: 50, color: Colors.grey),
//                   const Icon(Icons.location_on, color: Colors.purple)
//                 ],
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(fromCity,
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     Text(fromStation,
//                         style: const TextStyle(
//                             fontSize: 12, color: Colors.black54)),
//                     const SizedBox(height: 12),
//                     Text(duration,
//                         style: const TextStyle(color: Colors.purple)),
//                     const SizedBox(height: 12),
//                     Text(toCity,
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     Text(toStation,
//                         style: const TextStyle(
//                             fontSize: 12, color: Colors.black54)),
//                   ],
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Yatri {
  final String name;
  final String phone;
  final String seat;
  final String gender;
  final int age;

  Yatri({
    required this.name,
    required this.phone,
    required this.seat,
    required this.gender,
    required this.age,
  });
}

class TravelDetails extends StatefulWidget {
  const TravelDetails({super.key});

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

class _TravelDetailsState extends State<TravelDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Yatri> yatris = [
    Yatri(
        name: 'Ranjith Kumar',
        phone: '9876543210',
        seat: 'C2 / 34',
        gender: 'Male',
        age: 28),
    Yatri(
        name: 'Suresh Babu',
        phone: '9000012345',
        seat: 'C2 / 35',
        gender: 'Male',
        age: 32),
    Yatri(
        name: 'Meena Devi',
        phone: '9555544332',
        seat: 'C2 / 36',
        gender: 'Female',
        age: 27),
    Yatri(
        name: 'Arun Kumar',
        phone: '8899776655',
        seat: 'C2 / 37',
        gender: 'Male',
        age: 29),
    Yatri(
        name: 'Lakshmi Priya',
        phone: '9090901234',
        seat: 'C2 / 38',
        gender: 'Female',
        age: 26),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f2f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff7f2f5),
        elevation: 0,
        title: Text(
          'Travel Details',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurple,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'Onward Train'),
            Tab(text: 'Accommodation'),
            Tab(text: 'Return Train'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ticketCard(),
          _accommodationCard(),
          _returnTicketCard(),
        ],
      ),
    );
  }

  // ------------------ YATRI LIST ----------------------

  Widget _yatriList() {
    return Column(
      children: yatris.map((y) => _yatriCard(y)).toList(),
    );
  }

  Widget _yatriCard(Yatri y) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _labelValue("Name", y.name),
            _labelValue("Gender", y.gender),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _labelValue("Phone", y.phone),
            _labelValue("Age", y.age.toString()),
          ]),
          const SizedBox(height: 8),
          _labelValue("Seat Number", y.seat),
        ],
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ------------------ DOTTED LINE ----------------------

  Widget _dottedLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashWidth = 6.0;
          final dashCount = (constraints.maxWidth / (dashWidth * 2)).floor();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dashCount,
              (_) => Container(
                width: dashWidth,
                height: 2,
                color: Colors.grey.shade400,
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------ NEW TICKET UI (Flight Style) ----------------------

  Widget _ticketDesign({
    required String from,
    required String fromCity,
    required String to,
    required String toCity,
    required String duration,
    required String date,
    required String time,
    required String seatNumber,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          // TOP BLUE SECTION
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cityBlock(from, fromCity),
                Column(
                  children: [
                    const Icon(Icons.airplanemode_active,
                        color: Colors.white, size: 20),
                    Text(duration,
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                _cityBlock(to, toCity),
              ],
            ),
          ),

          // DOTTED SECTION SPLIT
          Container(
            color: Colors.green,
            padding: const EdgeInsets.only(bottom: 8),
            child: _dottedLine(),
          ),

          // BOTTOM ORANGE SECTION
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffF59A8A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailBlock(date, "Date"),
                _detailBlock(time, "Departure Time"),
                _detailBlock(seatNumber, "Seat"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityBlock(String code, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(code, style: const TextStyle(color: Colors.white, fontSize: 24)),
        Text(city, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _detailBlock(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  // ------------------ PAYMENT CARD ----------------------

  Widget _paymentSection(
      {required String ticketNumber, required String price}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelValue("Ticket Number", ticketNumber),
          const SizedBox(height: 12),
          _labelValue("Payment Method", "VISA •••• 2465"),
          const SizedBox(height: 12),
          _labelValue("Price", price),
        ],
      ),
    );
  }

  // ------------------ TABS CONTENT ----------------------

  Widget _ticketCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ticketDesign(
            from: "CHE",
            fromCity: "Chennai",
            to: "BLR",
            toCity: "Bangalore",
            duration: "4h 25m",
            date: "08 Nov",
            time: "06:00 AM",
            seatNumber: "C2 / 34",
          ),
          const SizedBox(height: 16),
          _yatriList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _returnTicketCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ticketDesign(
            from: "BLR",
            fromCity: "Bangalore",
            to: "CHE",
            toCity: "Chennai",
            duration: "4h 25m",
            date: "18 Feb",
            time: "03:00 PM",
            seatNumber: "D1 / 22",
          ),
          const SizedBox(height: 16),
          _yatriList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _accommodationCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ticketDesign(
            from: "HTL",
            fromCity: "Hotel Check-In",
            to: "RMT",
            toCity: "Room Assigned",
            duration: "3 Nights",
            date: "15 Feb",
            time: "12:00 PM",
            seatNumber: "Room 205",
          ),
          const SizedBox(height: 16),
          _yatriList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
