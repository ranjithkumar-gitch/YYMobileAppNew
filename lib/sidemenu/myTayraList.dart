import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
import 'package:yogayatra/sidemenu/myYatraListDetailsScreen.dart';

class MyYatraList extends StatefulWidget {
  @override
  _MyYatraListState createState() => _MyYatraListState();
}

class _MyYatraListState extends State<MyYatraList> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await SharedPrefServices.init(); // Initialize shared preferences
    setState(() {
      userId = SharedPrefServices.getuserId().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'My Yatras',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: userId == null || userId!.isEmpty
          ? const Center(child: Text('No user ID found. Please log in.'))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUserYatras(userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No yatras found.'));
                } else {
                  List<Map<String, dynamic>> yatrasList = snapshot.data!;
                  return ListView.builder(
                    itemCount: yatrasList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = yatrasList[index];
                      final yatraTitle = data['yatraTitle'] ?? 'No Title';
                      final yatraId = data['yatraId'] ?? 'No Id';
                      final yatraCost = data['yatraCost'] ?? 'No yatraCost';
                      final imageUrl =
                          (data['images'] != null && data['images'].isNotEmpty)
                              ? data['images'][0]
                              : 'https://via.placeholder.com/150';

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // YatraDetailsScreen(
                                  //   yatraData: data,
                                  //   yatraId: yatraId,
                                  // ),
                                  YatraDetailsAndTransactionsScreen(
                                yatraData: data,
                                yatraId: yatraId,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  yatraTitle,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ID: $yatraId',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      '₹$yatraCost/person',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
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

  // Fetch yatras list from user's collection
  Future<List<Map<String, dynamic>>> fetchUserYatras(String userId) async {
    try {
      // Fetch user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Get yatraIds from the user's document
      List<dynamic> yatraIds = userData['myYatras'] ?? [];

      if (yatraIds.isEmpty) return [];

      // Use whereIn to fetch all yatra details in a single query
      QuerySnapshot yatraSnapshot = await FirebaseFirestore.instance
          .collection('yatras')
          .where('yatraId', whereIn: yatraIds)
          .get();

      // Map the documents to a list of maps
      return yatraSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching user yatras: $e');
      return [];
    }
  }
}
