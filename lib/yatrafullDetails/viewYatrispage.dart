import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewYatrisPage extends StatefulWidget {
  final String yatraId;
  final String yatratitle;
  const ViewYatrisPage(
      {Key? key, required this.yatraId, required this.yatratitle})
      : super(key: key);

  @override
  State<ViewYatrisPage> createState() => _ViewYatrisPageState();
}

class _ViewYatrisPageState extends State<ViewYatrisPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = true;
  List<Map<String, dynamic>> _yatriList = [];

  @override
  void initState() {
    super.initState();
    _fetchYatris();
  }

  Future<String?> _getProfileUrl(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching profile pic URL: $e');
      return null;
    }
  }

  Future<void> _fetchYatris() async {
    try {
      final usersSnap = await _firestore
          .collection('users')
          .where('myYatras', arrayContains: widget.yatraId)
          .get();

      List<Map<String, dynamic>> users = [];

      for (var doc in usersSnap.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // If profilePic is a path, get its download URL
        if (data['profilePic'] != null &&
            data['profilePic'].toString().isNotEmpty) {
          final url = await _getProfileUrl(data['profilePic']);
          if (url != null) data['profilePic'] = url;
        }

        users.add(data);
      }

      setState(() {
        _yatriList = users;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching yatris: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: Colors.green,
          elevation: 0,
          title: Text(
            'List of Yatris',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat, color: Colors.white),
            ),
          ],
          centerTitle: true,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _yatriList.isEmpty
                ? const Center(child: Text('No Yatris found'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.yatratitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _yatriList.length,
                            itemBuilder: (context, index) {
                              final user = _yatriList[index];
                              final name =
                                  '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'
                                      .trim();
                              final age = user['age'] ?? 'N/A';
                              final phone = user['mobileNumber'] ?? 'N/A';
                              // final relation = user['relationwithPrimary'] ?? '';
                              final gender = user['gender'] ?? '';

                              final bloodGroup = user['bloodGroup'] ?? '';

                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Profile Image
                                          SizedBox(
                                            height: 130,
                                            width: 120,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              child:
                                                  user['profilePic'] != null &&
                                                          user['profilePic']
                                                              .toString()
                                                              .isNotEmpty
                                                      ? Image.network(
                                                          user['profilePic'],
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'images/avathar.jpg',
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                          ),

                                          // Content Section
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Name
                                                  Text(
                                                    name.isNotEmpty
                                                        ? name
                                                        : 'Unknown',
                                                    style: GoogleFonts.poppins(
                                                      color:
                                                          Colors.green.shade800,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),

                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Phone",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text("Age",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text("Gender",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(": $phone",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(": $age",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(": $gender",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ]));
  }
}
