// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';

// class YatraViewCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String days;
//   final String date;

//   const YatraViewCard({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//     required this.days,
//     required this.date,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//           width: double.infinity,
//           child: Column(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(10),
//                       topLeft: Radius.circular(10)),
//                   color: Colors.grey,
//                 ),
//                 height: 200,
//                 width: double.infinity,
//                 child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         topLeft: Radius.circular(10)),
//                     child: Image.network(
//                       imageUrl,
//                       fit: BoxFit.cover,
//                     )),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(right: 10, left: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: GoogleFonts.poppins(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(
//                       height: 3,
//                     ),
//                     Text(
//                       days,
//                       style: GoogleFonts.poppins(
//                           color: Colors.grey.shade600,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(
//                       height: 3,
//                     ),
//                     Text(
//                       date,
//                       style: GoogleFonts.poppins(
//                           color: Colors.black,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                             onPressed: () {
//                               //  Navigator.push(context, MaterialPageRoute(builder: (context)=> const YatraView()));
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5)),
//                                 backgroundColor: HexColor('#018a3c')),
//                             child: Text(
//                               "VIEW DETAILS",
//                               style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 16),
//                             ))),
//                     const SizedBox(
//                       height: 3,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
