// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure this is imported
// import 'package:google_fonts/google_fonts.dart';
// import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
// import 'package:yogayatra/dashboard/dashboardScreen.dart';
// import 'package:yogayatra/dashboard/landingScreen.dart';
// import 'package:yogayatra/dashboard/notificationPage.dart';
// import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
// import 'package:yogayatra/sidemenu/profileScreen.dart';
// import 'package:yogayatra/sidemenu/sidemenusScreen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
// //
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   late TabController _tabController;
//   Map<String, dynamic>? userProfileData;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this); // 3 tabs
//     // var userDoc = SharedPrefServices.getuserId().toString();
//     String userId = SharedPrefServices.getuserId.toString();
//     _fetchUserProfileData(userId);
//   }

//   // Function to fetch user profile data from Firestore using aadharNumber
//   Future<void> _fetchUserProfileData(String userId) async {
//     try {
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('users') // Replace with your Firestore collection
//           .doc(userId) // Dynamically pass the user ID
//           .get();

//       if (docSnapshot.exists) {
//         setState(() {
//           userProfileData = docSnapshot.data() as Map<String, dynamic>;
//         });
//       } else {
//         print("User document does not exist.");
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//     }
//   }

//   // Function to show the creditNote in an alert dialog
//   void _showCreditDialog() {
//     if (userProfileData != null) {
//       // Retrieve the credit note, default to 0.00 if not found or invalid
//       double creditNote = double.tryParse(
//               userProfileData?['creditNote']?.toString() ?? '0.00') ??
//           0.00;

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//               'Your Wallet Amount',
//               style: GoogleFonts.poppins(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             content: Text(
//               'Your wallet balance is ₹${creditNote.toStringAsFixed(2)}',
//               style: GoogleFonts.poppins(fontSize: 16),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text(
//                   'Close',
//                   style: GoogleFonts.poppins(fontSize: 16),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       // If user data is null, show an error dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//               'Error',
//               style: GoogleFonts.poppins(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             content: Text(
//               'Unable to fetch wallet balance. Please try again later.',
//               style: GoogleFonts.poppins(fontSize: 16),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text(
//                   'Close',
//                   style: GoogleFonts.poppins(fontSize: 16),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.green,
//         leading: Padding(
//           padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
//           child: GestureDetector(
//             onTap: () {
//               scaffoldKey.currentState?.openDrawer();
//             },
//             child: CircleAvatar(
//               radius: 35,
//               backgroundColor: Colors.white,
//               backgroundImage: userProfileData?['profilePic'] != null
//                   ? NetworkImage(userProfileData!['profilePic'])
//                   : const NetworkImage('https://via.placeholder.com/150'),
//             ),
//           ),
//         ),
//         title: Text(
//           'YogaYatra',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 25,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationPage()),
//               );
//             },
//             icon:
//                 const Icon(Icons.notifications, color: Colors.white, size: 25),
//           ),
//           IconButton(
//             onPressed: _showCreditDialog, // Open the dialog on press
//             icon: const Icon(Icons.credit_card,
//                 color: Colors.white, size: 25), // Credit icon
//           ),
//         ],
//       ),
//       drawer: SideMenuScreen(),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           LandingScreen(),
//           DashboardScreen(),
//           ProfilePage(),
//         ],
//       ),
//       bottomNavigationBar: MotionTabBar(
//         initialSelectedTab: "Home",
//         labels: const ["Home", "All Yatras", "Profile"],
//         icons: const [Icons.home, Icons.temple_hindu, Icons.person],
//         tabSize: 50,
//         tabBarHeight: 60,
//         textStyle: const TextStyle(
//           fontSize: 14,
//           color: Colors.black,
//           fontWeight: FontWeight.w500,
//         ),
//         tabIconColor: Colors.grey,
//         tabSelectedColor: Colors.green,
//         tabIconSize: 28,
//         tabBarColor: Colors.white,
//         onTabItemSelected: (int index) {
//           setState(() {
//             _tabController.index = index;
//           });
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yogayatra/dashboard/dashboardScreen.dart';
import 'package:yogayatra/dashboard/landingScreen.dart';
import 'package:yogayatra/dashboard/notificationPage.dart';
import 'package:yogayatra/sidemenu/profileScreen.dart';
import 'package:yogayatra/sidemenu/sidemenusScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  Map<String, dynamic>? userProfileData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs
    _getUserId(); // Fetch user ID dynamically
  }

  // Fetch user ID dynamically from SharedPreferences
  Future<void> _getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        _fetchUserProfileData(userId);
      } else {
        print("User ID not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error fetching user ID: $e");
    }
  }

  // Fetch user profile data from Firestore using userId
  Future<void> _fetchUserProfileData(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users') // Firestore collection name
          .doc(userId) // User ID
          .get();

      if (docSnapshot.exists) {
        setState(() {
          userProfileData = docSnapshot.data() as Map<String, dynamic>;
        });
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching user profile data: $e");
    }
  }

  // Display wallet balance in an alert dialog
  void _showCreditDialog() {
    if (userProfileData != null) {
      double creditNote = double.tryParse(
              userProfileData?['creditNote']?.toString() ?? '0.00') ??
          0.00;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Your Wallet Amount',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Your wallet balance is ₹${creditNote.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Show an error message if userProfileData is null
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Unable to fetch wallet balance. Please try again later.',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          child: GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: userProfileData?['profilePic'] != null
                  ? NetworkImage(userProfileData!['profilePic'])
                  : const NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
        ),
        title: Text(
          'YogaYatra',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            icon:
                const Icon(Icons.notifications, color: Colors.white, size: 25),
          ),
          IconButton(
            onPressed: _showCreditDialog, // Open the dialog on press
            icon: const Icon(Icons.credit_card,
                color: Colors.white, size: 25), // Credit icon
          ),
        ],
      ),
      drawer: SideMenuScreen(),
      body: TabBarView(
        controller: _tabController,
        children: [
          LandingScreen(),
          DashboardScreen(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Home",
        labels: const ["Home", "All Yatras", "Profile"],
        icons: const [Icons.home, Icons.temple_hindu, Icons.person],
        tabSize: 50,
        tabBarHeight: 60,
        textStyle: const TextStyle(
          // fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.grey,
        tabSelectedColor: Colors.green,
        tabIconSize: 28,
        tabBarColor: Colors.white,
        onTabItemSelected: (int index) {
          setState(() {
            _tabController.index = index;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
