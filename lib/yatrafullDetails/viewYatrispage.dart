import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewYatrisPage extends StatefulWidget {
  final String yatraId;
  const ViewYatrisPage({Key? key, required this.yatraId}) : super(key: key);

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
  // Future<void> _fetchYatris() async {
  //   try {
  //     // 🔍 Fetch users whose 'myYatras' array contains this yatraId
  //     final usersSnap = await _firestore
  //         .collection('users')
  //         .where('myYatras', arrayContains: widget.yatraId)
  //         .get();

  //     final List<Map<String, dynamic>> users = usersSnap.docs.map((doc) {
  //       final data = doc.data();
  //       data['id'] = doc.id;
  //       return data;
  //     }).toList();

  //     setState(() {
  //       _yatriList = users;
  //       _loading = false;
  //     });
  //   } catch (e) {
  //     debugPrint('Error fetching yatris: $e');
  //     setState(() => _loading = false);
  //   }
  // }
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
          'Yatris for ${widget.yatraId}',
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
              : ListView.builder(
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

                    // return Card(
                    //   margin: const EdgeInsets.symmetric(
                    //       horizontal: 16, vertical: 8),
                    //   elevation: 3,
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       backgroundImage: user['profilePic'] != null &&
                    //               user['profilePic'].toString().isNotEmpty
                    //           ? NetworkImage(user['profilePic'])
                    //           : const AssetImage('assets/default_avatar.png')
                    //               as ImageProvider,
                    //     ),
                    //     title: Text(
                    //       name.isNotEmpty ? name : 'Unknown',
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.bold, color: Colors.green),
                    //     ),
                    //     subtitle: Text(
                    //       'Phone: $phone\nAge: $age\nGender: $gender',
                    //     ),
                    //     isThreeLine: true,
                    //   ),
                    // );
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Image
                            SizedBox(
                              height: 130,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: user['profilePic'] != null &&
                                        user['profilePic'].toString().isNotEmpty
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
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name
                                    Text(
                                      name.isNotEmpty ? name : 'Unknown',
                                      style: GoogleFonts.poppins(
                                        color: Colors.green.shade800,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),

                                    // Phone, Age, Gender
                                    Text(
                                      'Phone: $phone\nAge: $age\nGender: $gender',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Buttons Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // View Details Button
                                        GestureDetector(
                                          child: Chip(
                                            side: BorderSide.none,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.all(0),
                                            backgroundColor: Colors.orange,
                                            label: Text(
                                              ' View details ',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Call Button
                                        GestureDetector(
                                          child: Chip(
                                            side: BorderSide.none,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.all(0),
                                            backgroundColor: Colors.green,
                                            label: Row(
                                              children: [
                                                const Icon(
                                                  Icons.call,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                Text(
                                                  ' Call ',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
