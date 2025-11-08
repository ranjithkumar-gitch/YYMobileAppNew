// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:yogayatra/dashboard/dashboardScreen.dart';

// class LandingScreen extends StatefulWidget {
//   @override
//   State<LandingScreen> createState() => _LandingScreenState();
// }

// class _LandingScreenState extends State<LandingScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Fetch top 3 yatras
//   Stream<QuerySnapshot> _getTopYatras() {
//     return _firestore
//         .collection('yatras')
//         .orderBy('depature', descending: false)
//         .limit(3)
//         .snapshots();
//   }

//   // Fetch ads with "Image" format
//   // Stream<QuerySnapshot> _fetchAds() {
//   //   return _firestore
//   //       .collection('adscenter')
//   //       .where('adFormat', isEqualTo: 'Image')
//   //       .orderBy('dateCreated', descending: true)
//   //       .snapshots();
//   // }
//   Stream<QuerySnapshot> _fetchAds({String adFormat = 'Image'}) {
//     try {
//       return _firestore
//           .collection('adscenter')
//           .where('adFormat', isEqualTo: adFormat)
//           .snapshots();
//     } catch (e) {
//       print('Error fetching ads: $e');
//       // Return an empty stream in case of an error
//       return Stream.empty();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(
//       //     'Yoga Yatra',
//       //     style: GoogleFonts.poppins(
//       //       fontSize: 20,
//       //       fontWeight: FontWeight.w500,
//       //     ),
//       //   ),
//       //   backgroundColor: Colors.green,
//       //   centerTitle: true,
//       // ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top Yatras Section
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Top Yatras',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.green,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.arrow_forward, color: Colors.green),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => DashboardScreen()),
//                         );
//                       },
//                       child: Text(
//                         'View All',
//                         style: GoogleFonts.poppins(
//                             color: Colors.green, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 200,
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _getTopYatras(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No yatras available.'));
//                 }

//                 final yatras = snapshot.data!.docs
//                     .map((doc) => doc.data() as Map<String, dynamic>)
//                     .toList();

//                 return ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: yatras.length,
//                   itemBuilder: (context, index) {
//                     final yatra = yatras[index];
//                     final imageUrl =
//                         (yatra['images'] != null && yatra['images'].isNotEmpty)
//                             ? yatra['images'][0]
//                             : 'https://via.placeholder.com/150';
//                     final yatraTitle = yatra['yatraTitle'] ?? 'No Title';
//                     final yatraId = yatra['yatraId'] ?? 'No yatraId';
//                     final yatraCost = yatra['yatraCost'] ?? 'No yatraId';

//                     return Card(
//                       margin: const EdgeInsets.all(8),
//                       elevation: 4,
//                       child: Column(
//                         // crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.network(
//                             imageUrl,
//                             height: 120,
//                             width: 350,
//                             fit: BoxFit.cover,
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               yatraTitle,
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Text(
//                                 //   'ID: $yatraId',
//                                 //   style: GoogleFonts.poppins(
//                                 //     fontWeight: FontWeight.w400,
//                                 //     fontSize: 14,
//                                 //     color: Colors.green,
//                                 //   ),
//                                 // ),
//                                 Text(
//                                   '₹$yatraCost/person',
//                                   style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 14,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Ads Section
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Advertisements',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.green,
//               ),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _fetchAds(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No ads available.'));
//                 }

//                 final ads = snapshot.data!.docs
//                     .map((doc) => doc.data() as Map<String, dynamic>)
//                     .toList();

//                 return ListView.builder(
//                   itemCount: ads.length,
//                   itemBuilder: (context, index) {
//                     final ad = ads[index];
//                     final imageUrl = ad['imageUrl'] ?? '';
//                     final description =
//                         ad['description'] ?? 'No Description Available';

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       elevation: 4,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Ad Image
//                           if (imageUrl.isNotEmpty)
//                             Image.network(
//                               imageUrl,
//                               height: 200,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           // Ad Description
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               description,
//                               style: GoogleFonts.poppins(fontSize: 14),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogayatra/dashboard/dashboardScreen.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch top 3 yatras
  Stream<QuerySnapshot> _getTopYatras() {
    return _firestore
        .collection('yatras')
        .orderBy('depature', descending: false)
        .limit(3)
        .snapshots();
  }

  // Fetch ads with "Image" format
  Stream<QuerySnapshot> _fetchAds({String adFormat = 'Image'}) {
    try {
      return _firestore
          .collection('adscenter')
          .where('adFormat', isEqualTo: adFormat)
          .snapshots();
    } catch (e) {
      print('Error fetching ads: $e');
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Yatras Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Yatras',
                    style: GoogleFonts.poppins(
                      // fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward, color: Colors.green),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardScreen()),
                          );
                        },
                        child: Text(
                          'View All',
                          style: GoogleFonts.poppins(
                              color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: _getTopYatras(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No yatras available.'));
                  }

                  final yatras = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: yatras.length,
                    itemBuilder: (context, index) {
                      final yatra = yatras[index];
                      final imageUrl = (yatra['images'] != null &&
                              yatra['images'].isNotEmpty)
                          ? yatra['images'][0]
                          : 'https://via.placeholder.com/150';
                      final yatraTitle = yatra['yatraTitle'] ?? 'No Title';
                      final yatraCost = yatra['yatraCost'] ?? 'No Cost';

                      return Card(
                        margin: const EdgeInsets.all(8),
                        elevation: 4,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Image.network(
                                  imageUrl,
                                  height: 120,
                                  width: 350,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    yatraTitle,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      // fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '₹$yatraCost/person',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      // fontSize: 14,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Ads Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Advertisements',
                style: GoogleFonts.poppins(
                  // fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _fetchAds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No ads available.'));
                }

                final ads = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    final imageUrl = ad['imageUrl'] ?? '';
                    final description =
                        ad['description'] ?? 'No Description Available';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imageUrl.isNotEmpty)
                            Image.network(
                              imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              description,
                              // style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
