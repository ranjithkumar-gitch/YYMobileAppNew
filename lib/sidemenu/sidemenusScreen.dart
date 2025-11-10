// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:yogayatra/loginscrenns/loginscreen.dart';
// import 'package:yogayatra/sidemenu/galleryscreen.dart';
// import 'package:yogayatra/sidemenu/profileScreen.dart';
// import 'package:yogayatra/sidemenu/tabviewyatra/yatras.dart';

// class SideMenuScreen extends StatelessWidget {
//    SideMenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration:  BoxDecoration(
//               color: HexColor('#018a3c'),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 15,
//                 ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                    const SizedBox(
//                       width: 55.0,
//                       height: 55.0,
//                       child:

//                 CircleAvatar(
//                 backgroundColor: Colors.white,
//                 backgroundImage: NetworkImage(
//                  'https://media.istockphoto.com/id/937499062/photo/successful-smiling-young-handsome-american-guy-banker-in-formal-outfit-on-pure-background-with.webp?b=1&s=170667a&w=0&k=20&c=velS9SQECLQ4EY0TbDW5DEuhDEtsCRx4ejVZKLtX4TQ='
//                 ),
//                 radius: 10,
//               )
//                  ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.arrow_forward_ios),
//                       color: Colors.white,
//                       iconSize: 25,
//                     )
//                   ],
//                 ),

//                 const SizedBox(
//                   height: 10,
//                 ),

//                 const Text(
//                   "Hello Sai",
//                   style:  TextStyle(color: Colors.white, fontSize: 16),
//                 ),

//                 const SizedBox(
//                   height: 5,
//                 ),

//                 const Text(
//                   "saivarun@gmail.com",
//                   style:  TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading:  Icon(
//               Icons.person,
//               color: HexColor('#018a3c')
//             ),
//           title : Text('My Profile',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//             onTap: () => {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                  builder: (context) => const ProfilePage()))
//             },
//           ),

//           //   ListTile(
//           //   leading:  Icon(
//           //     Icons.self_improvement,
//           //     color: HexColor('#018a3c')
//           //   ),
//           // title : Text('Yatras ',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//           //   onTap: () => {
//           //      Navigator.push(
//           //         context,
//           //         MaterialPageRoute(
//           //        builder: (context) => const Yatras()))
//           //   },
//           // ),

//            ListTile(
//             leading:  Icon(
//               Icons.self_improvement,
//               color: HexColor('#018a3c'),
//             ),
//           title : Text('Adhyatama Yoga',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//             onTap: () => {
//              Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                  builder: (context) => const GalleryScreen()))
//             },
//           ),

//           ListTile(
//             leading:  Icon(
//               Icons.payments,
//               color: HexColor('#018a3c'),
//             ),
//           title : Text('Payments',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//             onTap: () => {
//             //  Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //      builder: (context) => const PrivacyandPolicy()))
//             },
//           ),
//            ListTile(
//             leading:  Icon(
//               Icons.help_center,
//               color: HexColor('#018a3c'),
//             ),
//           title : Text('Help Desk ',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//             onTap: () => {
//               //  Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //    builder: (context) => const TermsandConditions()))
//             },
//           ),

//           ListTile(
//             leading:  Icon(
//               Icons.verified_user,
//               color: HexColor('#018a3c'),
//             ),
//           title : Text('Privacy Policy ',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//             onTap: () => {
//               //  Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //    builder: (context) => const TermsandConditions()))
//             },
//           ),

//           ListTile(
//             leading:  Icon(
//               Icons.settings,
//               color: HexColor('#018a3c'),
//             ),
//           title : Text('Terms & Conditions ',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//             onTap: () => {
//               //  Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //    builder: (context) => const TermsandConditions()))
//             },
//           ),

//           ListTile(
//             leading:  Icon(
//               Icons.share,
//               color: HexColor('#018a3c'),
//             ),
//           title : Text('Share App',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
//             onTap: () => {
//               //  Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //    builder: (context) => const TermsandConditions()))
//             },
//           ),

//           GestureDetector(
//             onTap: () {
//                showDialog(
//         context: context,
//           builder: (BuildContext context) {
//         return AlertDialog(
//         shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(15)),
//          title: Center(
//        child: Text('Log Out ?',style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black),)),
//          content:  Padding(
//         padding: const EdgeInsets.only(left: 15,),
//        child: Text(' Are you sure want to logout ?',style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),) ),

//                     actions: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                               child: OutlinedButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   style: OutlinedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                                       side: BorderSide(
//                                  color: HexColor('#018a3c')),),
//                                   child: const  Text(
//                                     "Not now",
//                                     style: TextStyle(color: Colors.black),
//                                   ))),

//                                SizedBox(
//                               child: ElevatedButton(
//                                   onPressed: () {
//                                      Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                           const LoginScreen(),
//                                             ));

//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                                       backgroundColor: HexColor('#018a3c')),
//                                   child:  Text("Logout",style: GoogleFonts.poppins(color: Colors.white),)))
//                         ],
//                       )
//                     ],
//                   );
//                 },
//               );
//       },

//             child: ListTile(
//               leading:  Icon(
//                 Icons.exit_to_app,
//                 color: HexColor('#018a3c'),
//                 size: 25,
//               ),
//               title :  Text('Logout',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),

//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yogayatra/dashboard/landingScreen.dart';
import 'package:yogayatra/loginscrenns/loginscreen.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';

import 'package:yogayatra/sidemenu/interestedYatrasList.dart';
import 'package:yogayatra/sidemenu/myTayraList.dart';
import 'package:yogayatra/sidemenu/profileScreen.dart';
import 'package:yogayatra/sidemenu/settingsPage.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({Key? key}) : super(key: key);

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userProfileData;

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: HexColor('#018a3c'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: userProfileData?['profilePic'] != null
                          ? NetworkImage(userProfileData!['profilePic'])
                          : const NetworkImage(
                              'https://via.placeholder.com/150',
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                      color: Colors.white,
                      iconSize: 25,
                    ),
                  ],
                ),
                // const SizedBox(height: 5),
                Text(
                  userProfileData?['firstName'] ?? 'Hello, User',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                // const SizedBox(height: 5),
                Text(
                  userProfileData?['emailId'] ?? 'user@example.com',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: HexColor('#018a3c')),
            title: Text(
              'My Profile',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.self_improvement, color: HexColor('#018a3c')),
          //   title: Text(
          //     'Adhyatama Yoga',
          //     style: GoogleFonts.poppins(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.black,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const GalleryScreen()),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.my_library_add, color: HexColor('#018a3c')),
            title: Text(
              'My Yatra List',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyYatraList()),
              // );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.my_library_add, color: HexColor('#018a3c')),
          //   title: Text(
          //     'Add Center',
          //     style: GoogleFonts.poppins(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.black,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => LandingScreen()),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.favorite, color: HexColor('#018a3c')),
            title: Text(
              'Interested Yatra List',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InterestedYatrasScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.my_library_add, color: HexColor('#018a3c')),
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: HexColor('#018a3c')),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              // Add logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Log Out?',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    content: Text(
                      'Are you sure you want to log out?',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          logout();
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => LoginScreen()),
                          // );
                        },
                        child: const Text('Log Out'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    try {
      // Retrieve the userId from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        // Update Firestore user document to mark logged out
        await _firestore.collection('users').doc(userId).update({
          'loggedIn': false,
          'deviceId': null,
        });

        // Clear SharedPreferences
        await prefs.clear();

        // Navigate back to the login screen

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: User ID not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }
}
