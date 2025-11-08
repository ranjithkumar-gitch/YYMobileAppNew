import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';

class InterestedYatrasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Interested Yatras List',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchInterestedYatras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No interested yatras found.'));
          } else {
            List<Map<String, dynamic>> interestedYatras = snapshot.data!;

            return ListView.builder(
              itemCount: interestedYatras.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = interestedYatras[index];
                final yatraId = data['yatraId'] ?? 'No Title';
                final yatraTitle = data['yatraTitle'] ?? 'No Title';
                final status = data['status'] ??
                    'Not Registered'; // Default value if missing
                final timestamp = formatTimestamp(data['timestamp']);
                final imageUrl =
                    (data['images'] != null && data['images'].isNotEmpty)
                        ? data['images'][0]
                        : 'https://via.placeholder.com/150';

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YatraDetailsScreen(
                          yatraData: data,
                          yatraId: yatraId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            yatraTitle,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //   child: Text(
                        //     'Status: $status',
                        //     style: GoogleFonts.poppins(
                        //       fontWeight: FontWeight.w400,
                        //       fontSize: 14,
                        //       color: status.toLowerCase() == 'registered'
                        //           ? Colors.green
                        //           : Colors
                        //               .red, // Default to red if not registered
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            status.toLowerCase() == 'registered'
                                ? 'Status: $status'
                                : 'Status: Not Registered',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: status.toLowerCase() == 'registered'
                                  ? Colors.green
                                  : Colors
                                      .red, // Default to red if not registered
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Interested On: $timestamp'),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Helper method to format timestamp
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    DateTime date = timestamp.toDate();
    return '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}:${date.second}';
  }

  // Fetch interested yatras with the status from the 'interested' collection
  Future<List<Map<String, dynamic>>> fetchInterestedYatras() async {
    try {
      QuerySnapshot interestedSnapshot = await FirebaseFirestore.instance
          .collection('interested')
          .where('interested', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> interestedYatras = [];

      for (var doc in interestedSnapshot.docs) {
        Map<String, dynamic> interestedData =
            doc.data() as Map<String, dynamic>;

        // Fetch related yatra details
        QuerySnapshot yatraSnapshot = await FirebaseFirestore.instance
            .collection('yatras')
            .where('yatraId', isEqualTo: interestedData['yatraId'])
            .get();

        if (yatraSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> yatraDetails =
              yatraSnapshot.docs.first.data() as Map<String, dynamic>;

          // Merge data while keeping the 'status' from 'interested'
          interestedYatras.add({
            'interestedId': doc.id,
            ...yatraDetails,
            ...interestedData,
          });
        }
      }

      return interestedYatras;
    } catch (e) {
      print('Error fetching interested yatras: $e');
      return [];
    }
  }
}
