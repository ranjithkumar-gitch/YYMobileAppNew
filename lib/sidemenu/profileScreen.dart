// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:yogayatra/sidemenu/editprofile.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Map<String, dynamic>? userProfileData;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserProfile();
//   }

//   Future<void> _fetchUserProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('userId');

//     if (userId == null || userId.isEmpty) {
//       print('Error: userId is null or empty');
//       return;
//     }

//     try {
//       DocumentSnapshot userProfile =
//           await _firestore.collection('users').doc(userId).get();

//       setState(() {
//         userProfileData = userProfile.data() as Map<String, dynamic>?;
//       });
//     } catch (e) {
//       print('Error fetching user profile: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //     leading: IconButton(
//       //         onPressed: () {
//       //           Navigator.pop(context);
//       //         },
//       //         icon: const Icon(
//       //           Icons.arrow_back,
//       //           color: Colors.black,
//       //           size: 25,
//       //         )),
//       //     backgroundColor: Colors.white,
//       //     centerTitle: false,
//       //     title: Text(
//       //       'Profile Details',
//       //       style: GoogleFonts.poppins(
//       //           fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
//       //     )),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: userProfileData != null
//               ? Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       const SizedBox(height: 10),
//                       CircleAvatar(
//                         radius: 65.0,
//                         backgroundColor: Colors.grey,
//                         backgroundImage: NetworkImage(
//                           userProfileData?['profilePic'] ??
//                               'https://via.placeholder.com/150',
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         margin: const EdgeInsets.all(15.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ProfileDetailRow(
//                               title: 'Full Name',
//                               value: userProfileData?['firstName'] ?? '',
//                               icon: Icons.person,
//                             ),
//                             ProfileDetailRow(
//                               title: 'Gender',
//                               value: userProfileData?['gender'] ?? '',
//                               icon: Icons.people,
//                             ),
//                             ProfileDetailRow(
//                               title: 'Date of Birth',
//                               value: userProfileData?['dob'] ?? '',
//                               icon: Icons.date_range,
//                             ),
//                             ProfileDetailRow(
//                               title: 'Aadhar Number',
//                               value: userProfileData?['aadharNumber'] ?? '',
//                               icon: Icons.date_range,
//                             ),
//                             ProfileDetailRow(
//                               title: 'Blood Group',
//                               value: userProfileData?['bloodGroup'] ?? '',
//                               icon: Icons.bloodtype,
//                             ),
//                             ProfileDetailRow(
//                               title: 'Phone Number',
//                               value: userProfileData?['mobileNumber'] ?? '',
//                               icon: Icons.phone,
//                             ),
//                             ProfileDetailRow(
//                               title: 'Email',
//                               value: userProfileData?['emailId'] ?? '',
//                               icon: Icons.mail,
//                             ),
//                             ProfileDetailRow(
//                               title: 'City',
//                               value: userProfileData?['city'] ?? '',
//                               icon: Icons.location_city,
//                             ),
//                             ProfileDetailRow(
//                               title: 'State',
//                               value: userProfileData?['state'] ?? '',
//                               icon: Icons.place,
//                             ),
//                             const SizedBox(height: 30),
//                             Align(
//                               alignment: Alignment.bottomCenter,
//                               child: ElevatedButton(
//                                 onPressed: () async {
//                                   await Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => EditProfilePage(
//                                         userProfileData: userProfileData,
//                                       ),
//                                     ),
//                                   );
//                                   // Refresh profile data after editing
//                                   _fetchUserProfile();
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   backgroundColor: HexColor('#018a3c'),
//                                   fixedSize: const Size(358, 48),
//                                 ),
//                                 child: Text(
//                                   'EDIT PROFILE',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const Center(child: CircularProgressIndicator()),
//         ),
//       ),
//     );
//   }
// }

// class ProfileDetailRow extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;

//   const ProfileDetailRow({
//     Key? key,
//     required this.title,
//     required this.value,
//     required this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: HexColor('#018a3c')),
//         ),
//         const SizedBox(height: 4),
//         Row(
//           children: [
//             Icon(icon, color: HexColor('#018a3c'), size: 20),
//             const SizedBox(width: 10),
//             Text(
//               value,
//               style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black),
//             ),
//           ],
//         ),
//         const Divider(height: 20, thickness: 1),
//       ],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yogayatra/sidemenu/editprofile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userProfileData;
  double _fontSize = 14; // Initial font size

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2; // Increase font size by 2
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if (_fontSize > 8)
        _fontSize -= 2; // Decrease font size by 2 but not below 8
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) {
      print('Error: userId is null or empty');
      return;
    }

    try {
      DocumentSnapshot userProfile =
          await _firestore.collection('users').doc(userId).get();

      setState(() {
        userProfileData = userProfile.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: userProfileData != null
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    userProfileData?['profilePic'].isNotEmpty
                        ? CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(userProfileData!['profilePic']))
                        : CircleAvatar(
                            radius: 50, // Adjust size as needed
                            backgroundColor:
                                Colors.blue, // Customize background color
                            child: Text(
                              userProfileData?['firstName'][0] ??
                                  '', // First letter of the name
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    // CircleAvatar(
                    //   radius: 65.0,
                    //   backgroundColor: Colors.grey,
                    //   backgroundImage: NetworkImage(
                    //     userProfileData?['profilePic'] ??
                    //         'https://via.placeholder.com/150',
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // Text(userProfileData?['firstName'][0] ?? '',
                    //     style: GoogleFonts.poppins(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w600,
                    //         color: Colors.black)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          ..._buildProfileDetails(),
                          const SizedBox(height: 20),
                          if (userProfileData?['idProofImages'] != null)
                            _buildIdProofSection(),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    userProfileData: userProfileData,
                                  ),
                                ),
                              );
                              // Refresh profile data after editing
                              _fetchUserProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: HexColor('#018a3c'),
                              fixedSize: const Size(358, 48),
                            ),
                            child: Text(
                              'EDIT PROFILE',
                              style: GoogleFonts.poppins(
                                // fontSize: _fontSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Text(
                    //       'Text Size',
                    //       style: GoogleFonts.poppins(
                    //         fontSize: _fontSize,
                    //         fontWeight: FontWeight.w700,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         ElevatedButton(
                    //           onPressed: _decreaseFontSize,
                    //           child: Text("Smaller"),
                    //         ),
                    //         SizedBox(width: 10),
                    //         ElevatedButton(
                    //           onPressed: _increaseFontSize,
                    //           child: Text("Bigger"),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 10),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  List<Widget> _buildProfileDetails() {
    final fields = [
      {'title': 'Full Name', 'value': 'firstName', 'icon': Icons.person},
      {'title': 'Gender', 'value': 'gender', 'icon': Icons.people},
      {'title': 'Date of Birth', 'value': 'dob', 'icon': Icons.date_range},
      {
        'title': 'Aadhar Number',
        'value': 'aadharNumber',
        'icon': Icons.perm_identity
      },
      {'title': 'Blood Group', 'value': 'bloodGroup', 'icon': Icons.bloodtype},
      {'title': 'Phone Number', 'value': 'mobileNumber', 'icon': Icons.phone},
      {'title': 'Email', 'value': 'emailId', 'icon': Icons.mail},
      {'title': 'City', 'value': 'city', 'icon': Icons.location_city},
      {'title': 'State', 'value': 'state', 'icon': Icons.place},
      {'title': 'Address', 'value': 'address', 'icon': Icons.home},
    ];

    return fields
        .map((field) => ProfileDetailRow(
              title: field['title'] as String? ?? '',
              value: userProfileData?[field['value']] ?? '',
              icon: field['icon'] as IconData,
            ))
        .toList();
  }

  // Widget _buildIdProofSection() {
  //   List<dynamic> idProofImages = userProfileData?['idProofImages'] ?? [];
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'ID Proof Images',
  //         style: GoogleFonts.poppins(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //           color: HexColor('#018a3c'),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       SizedBox(
  //         height: 120,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: idProofImages.length,
  //           itemBuilder: (context, index) {
  //             // return Padding(
  //             //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
  //             //   child: GestureDetector(
  //             //     onTap: () => _showImagePreview(context, idProofImages[index]),
  //             //     child: Image.network(
  //             //       idProofImages[index],
  //             //       width: 100,
  //             //       height: 100,
  //             //       fit: BoxFit.cover,
  //             //     ),
  //             //   ),
  //             // );
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 5.0),
  //               child: GestureDetector(
  //                 onTap: () => _showImagePreview(context, idProofImages[index]),
  //                 child: Container(
  //                   width: 100, // Match the width of the image
  //                   height: 100, // Match the height of the image
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                         color: Colors.green, width: 3), // Green border
  //                     borderRadius:
  //                         BorderRadius.circular(8), // Optional rounded corners
  //                   ),
  //                   child: ClipRRect(
  //                     borderRadius:
  //                         BorderRadius.circular(8), // Match the border radius
  //                     child: Image.network(
  //                       idProofImages[index],
  //                       width: 100,
  //                       height: 100,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildIdProofSection() {
    dynamic idProofData = userProfileData?['idProofImages'];

    if (idProofData is List<dynamic>) {
      // Handle the case where idProofImages is a List
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID Proof Images',
            style: GoogleFonts.poppins(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
              color: HexColor('#018a3c'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: idProofData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () => _showImagePreview(context, idProofData[index]),
                    child: Image.network(
                      idProofData[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (idProofData is Map<String, dynamic>) {
      // Handle the case where idProofImages is a Map
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID Proof Images',
            style: GoogleFonts.poppins(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
              color: HexColor('#018a3c'),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: idProofData.values.map<Widget>((imageUrl) {
              return GestureDetector(
                onTap: () => _showImagePreview(context, imageUrl),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else {
      return const SizedBox
          .shrink(); // If idProofImages is null or unsupported type
    }
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    );
  }
}

class ProfileDetailRow extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;

  const ProfileDetailRow({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  State<ProfileDetailRow> createState() => _ProfileDetailRowState();
}

class _ProfileDetailRowState extends State<ProfileDetailRow> {
  double _fontSize = 14;
  void _increaseFontSize() {
    setState(() {
      _fontSize += 2; // Increase font size by 2
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if (_fontSize > 8)
        _fontSize -= 2; // Decrease font size by 2 but not below 8
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            // fontSize: _fontSize,
            fontWeight: FontWeight.w500,
            color: HexColor('#018a3c'),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              widget.icon, color: HexColor('#018a3c'),
              // size: 20
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                widget.value,
                style: GoogleFonts.poppins(
                  // fontSize: _fontSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}
