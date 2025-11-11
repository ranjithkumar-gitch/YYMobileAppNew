// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:yogayatra/sidemenu/sidemenusScreen.dart';
// import 'package:yogayatra/widgets/myYatracard.dart';
// import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';

// class DashboardScreen extends StatefulWidget {
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   int _selectedIndex = 0; // Track the selected tab index

//   void searchDaterange() {
//     // Implement date range search logic
//   }

//   void searchCategories() {
//     // Implement category search logic
//   }

//   // Function to handle bottom navigation bar item taps
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

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
//       key: scaffoldKey,
//       backgroundColor: Colors.grey.shade100,
//       extendBody: true,
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
//               backgroundImage: userProfileData?['profilePicUrl'] != null
//                   ? NetworkImage(userProfileData!['profilePicUrl'])
//                   : const NetworkImage(
//                       'https://via.placeholder.com/150',
//                     ),
//             ),
//           ),
//         ),
//         title: Text(
//           'YogaYatra',
//           style: GoogleFonts.poppins(
//               color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon:
//                 const Icon(Icons.notifications, color: Colors.white, size: 25),
//           ),
//         ],
//       ),
//       drawer: SideMenuScreen(),

//       // Main content based on selected index
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           // Home Screen
//           Column(
//             children: [
//               // "All Yatras" Header with Filter Popup
//               SizedBox(
//                 height: 60,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Yatras List',
//                         style: GoogleFonts.poppins(
//                           color: Color(0xFF018a3c), // HexColor as Color
//                           fontSize: 19,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     PopupMenuButton<int>(
//                       icon: Icon(
//                         Icons.filter_list,
//                         color: Color(0xFF018a3c),
//                         size: 25,
//                       ),
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                           value: 1,
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                               searchDaterange();
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("Date Range",
//                                     style: TextStyle(fontSize: 16)),
//                                 SizedBox(width: 10),
//                                 Icon(Icons.keyboard_arrow_right, size: 25),
//                               ],
//                             ),
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: 2,
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                               searchCategories();
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("Status", style: TextStyle(fontSize: 16)),
//                                 SizedBox(width: 10),
//                                 Icon(Icons.keyboard_arrow_right, size: 25),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('yatras')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(child: Text('No yatras available'));
//                     }
//                     final yatras = snapshot.data!.docs;
//                     return ListView.builder(
//                       itemCount: yatras.length,
//                       itemBuilder: (context, index) {
//                         final yatra = yatras[index];
//                         final title = yatra['yatraTitle'] ?? 'No Title';
//                         final yatraId = yatra['yatraId'] ?? 'No ID';
//                         final date = yatra['depature'] ?? 'No Date';
//                         final price = yatra['yatraCost'] ?? 'No Price';
//                         final status = yatra['status'] ?? 'No Status';
//                         final imageUrl = (yatra['images'] != null &&
//                                 yatra['images'].isNotEmpty)
//                             ? yatra['images'][0]
//                             : 'https://via.placeholder.com/150'; // Placeholder if no image

//                         return CustomMyCard(
//                           imageUrl: imageUrl,
//                           id: yatraId,
//                           title: title,
//                           date: date,
//                           price: price,
//                           status: status,
//                           onTap: () {
//                             final data = yatra.data();
//                             if (data != null && data is Map<String, dynamic>) {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => YatraDetailsScreen(
//                                     yatraData: data,
//                                     yatraId: yatraId,
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               // Handle the error appropriately, e.g., show a dialog
//                               print("Invalid Yatra data");
//                             }
//                           },

//                           // onTap: () {
//                           //   Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //       builder: (context) => YatraDetailsScreen(
//                           //         yatraTitle: yatra['yatraTitle'],
//                           //         yatraId: yatra['yatraId'],
//                           //         depature: yatra['depature'],
//                           //         yatraCost: yatra['yatraCost'],
//                           //         status: yatra['status'],
//                           //         images: yatra['images'],
//                           //       ),
//                           //     ),
//                           //   );
//                           // },
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),

//       // BottomNavigationBar
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yogayatra/dashboard/landingScreen.dart';
import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';
import 'package:yogayatra/sidemenu/profileScreen.dart';
import 'package:yogayatra/sidemenu/sidemenusScreen.dart';

// class DashboardScreen extends StatefulWidget {
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen>
//     with SingleTickerProviderStateMixin {
//   int _selectedIndex = 1;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final List<Widget> _screens = [
//     DashboardScreen(),
//     LandingScreen(),
//     ProfilePage(),
//   ];

//   late TabController _tabController;
//   String? _selectedStatus;
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _fetchUserProfile();
//   }

//   Stream<QuerySnapshot> _getFilteredYatras(bool isFirstTab) {
//     final List<String> defaultStatusFilter = isFirstTab
//         ? ['Draft', 'New', 'Registration Open', 'Ongoing']
//         : ['Registration Closed', 'Completed', 'Postponed', 'Cancelled'];

//     Query query = _firestore
//         .collection('yatras')
//         .where('status', whereIn: defaultStatusFilter)
//       ..orderBy('depature', descending: false);

//     if (_selectedStatus != null) {
//       query = query.where('status', isEqualTo: _selectedStatus);
//     }

//     return query.snapshots();
//   }

//   Widget _buildFilterButton() {
//     return PopupMenuButton<String>(
//       icon: const Icon(Icons.filter_list, color: Colors.green),
//       onSelected: (value) {
//         setState(() {
//           _selectedStatus = value == 'All' ? null : value;
//         });
//       },
//       itemBuilder: (context) => [
//         const PopupMenuItem(value: 'All', child: Text('All')),
//         const PopupMenuItem(value: 'Draft', child: Text('Draft')),
//         const PopupMenuItem(value: 'New', child: Text('New')),
//         const PopupMenuItem(
//             value: 'Registration Open', child: Text('Registration Open')),
//         const PopupMenuItem(value: 'Ongoing', child: Text('Ongoing')),
//         const PopupMenuItem(
//             value: 'Registration Closed', child: Text('Registration Closed')),
//         const PopupMenuItem(value: 'Completed', child: Text('Completed')),
//         const PopupMenuItem(value: 'Postponed', child: Text('Postponed')),
//         const PopupMenuItem(value: 'Cancelled', child: Text('Cancelled')),
//       ],
//     );
//   }

//   Widget _buildYatraList(bool isFirstTab) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _getFilteredYatras(isFirstTab),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No yatras found.'));
//         }
//         final yatras = snapshot.data!.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();

//         return ListView.builder(
//           itemCount: yatras.length,
//           itemBuilder: (context, index) {
//             final yatra = yatras[index];
//             final yatraId = yatra['yatraId'] ?? 'No Title';
//             final yatraCost = yatra['yatraCost'] ?? 'No Title';

//             final title = yatra['yatraTitle'] ?? 'No Title';

//             final date = yatra['depature'] ?? 'No Date';
//             final date2 = yatra['arrival'] ?? 'No Date';

//             final status = yatra['status'] ?? 'No Status';
//             final imageUrl =
//                 (yatra['images'] != null && yatra['images'].isNotEmpty)
//                     ? yatra['images'][0]
//                     : 'https://via.placeholder.com/150';

//             return InkWell(
//               onTap: () {
//                 // Perform the desired action here, e.g., navigate to details page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => YatraDetailsScreen(
//                       yatraData: yatra,
//                       yatraId: yatraId,
//                     ),
//                   ),
//                 );
//               },
//               child: Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Stack(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.network(
//                           imageUrl,
//                           height: 150,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment
//                               .spaceBetween, // Ensures left and right alignment
//                           children: [
//                             // Title aligned to the left
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0),
//                                 child: Text(
//                                   yatraId,
//                                   style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.green,
//                                   ),
//                                   textAlign: TextAlign
//                                       .left, // Aligns the text to the start
//                                   overflow: TextOverflow
//                                       .ellipsis, // Ensures text doesn't overflow
//                                 ),
//                               ),
//                             ),
//                             // Yatra cost aligned to the right
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize
//                                     .min, // Prevents the row from stretching
//                                 children: [
//                                   Icon(
//                                     Icons.currency_rupee, // Rupee icon
//                                     size: 16,
//                                     color: Colors.red, // Adjust color if needed
//                                   ),
//                                   Text(
//                                     '$yatraCost/person', // Cost text with per person
//                                     style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.red),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: Text(
//                             title,
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Text('Depature Date: $date'),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10),
//                           child: Text('Arrival Date: $date2'),
//                         ),
//                       ],
//                     ),
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: getStatusBackgroundColor(status),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           status,
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

// // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Map<String, dynamic>? userProfileData;

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
//       key: scaffoldKey,
//       // appBar: AppBar(
//       //   elevation: 0,
//       //   backgroundColor: Colors.green,
//       //   leading: Padding(
//       //     padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
//       //     child: GestureDetector(
//       //       onTap: () {
//       //         scaffoldKey.currentState?.openDrawer();
//       //       },
//       //       child: CircleAvatar(
//       //         radius: 35,
//       //         backgroundColor: Colors.white,
//       //         backgroundImage: userProfileData?['profilePic'] != null
//       //             ? NetworkImage(userProfileData!['profilePic'])
//       //             : const NetworkImage(
//       //                 'https://via.placeholder.com/150',
//       //               ),
//       //       ),
//       //     ),
//       //   ),
//       //   title: Text(
//       //     'YogaYatra',
//       //     style: GoogleFonts.poppins(
//       //       color: Colors.white,
//       //       fontSize: 25,
//       //       fontWeight: FontWeight.w500,
//       //     ),
//       //   ),
//       //   centerTitle: true,
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {},
//       //       icon:
//       //           const Icon(Icons.notifications, color: Colors.white, size: 25),
//       //     ),
//       //   ],
//       // ),
//       // drawer: SideMenuScreen(),
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
//       //       'All Yatras List',
//       //       style: GoogleFonts.poppins(
//       //           fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
//       //     )),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'All Yatras List',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.green,
//                   ),
//                 ),
//                 _buildFilterButton(),
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.grey[200],
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.green,
//               unselectedLabelColor: Colors.black,
//               indicatorColor: Colors.green,
//               tabs: const [
//                 Tab(text: 'Active Yatras'),
//                 Tab(text: 'Past Yatras'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildYatraList(true), // Active Yatras
//                 _buildYatraList(false), // Archived Yatras
//               ],
//             ),
//           ),
//         ],
//       ),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   currentIndex: _selectedIndex,
//       //   onTap: _onItemTapped,
//       //   items: const [
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.temple_hindu),
//       //       label: 'All Yatras',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.home),
//       //       label: 'Home',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.person),
//       //       label: 'Profile',
//       //     ),
//       //   ],
//       // ),
//     );
//   }

//   Color getStatusBackgroundColor(String status) {
//     switch (status) {
//       case 'New':
//         return Colors.orange[400]!;
//       case 'Registration Open':
//         return Colors.lightGreen;
//       case 'Ongoing':
//         return Colors.green;
//       case 'Completed':
//       case 'Cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey; // Default for unknown statuses
//     }
//   }
// }
class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _screens = [
    DashboardScreen(),
    LandingScreen(),
    ProfilePage(),
  ];

  String? _selectedStatus;
  Map<String, dynamic>? userProfileData;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Stream<QuerySnapshot> _getFilteredYatras() {
    final List<String> defaultStatusFilter = [
      'Draft',
      'New',
      'Registration Open',
      'Ongoing',
      'Registration Closed',
      'Completed',
      'Postponed',
      'Cancelled'
    ];

    Query query = _firestore
        .collection('yatras')
        .where('status', whereIn: defaultStatusFilter)
      ..orderBy('depature', descending: false);

    if (_selectedStatus != null) {
      query = query.where('status', isEqualTo: _selectedStatus);
    }

    return query.snapshots();
  }

  Widget _buildFilterButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list, color: Colors.green),
      onSelected: (value) {
        setState(() {
          _selectedStatus = value == 'All' ? null : value;
        });
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'All', child: Text('All')),
        const PopupMenuItem(value: 'Draft', child: Text('Draft')),
        const PopupMenuItem(value: 'New', child: Text('New')),
        const PopupMenuItem(
            value: 'Registration Open', child: Text('Registration Open')),
        const PopupMenuItem(value: 'Ongoing', child: Text('Ongoing')),
        const PopupMenuItem(
            value: 'Registration Closed', child: Text('Registration Closed')),
        const PopupMenuItem(value: 'Completed', child: Text('Completed')),
        const PopupMenuItem(value: 'Postponed', child: Text('Postponed')),
        const PopupMenuItem(value: 'Cancelled', child: Text('Cancelled')),
      ],
    );
  }

  Widget _buildYatraList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getFilteredYatras(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No yatras found.'));
        }

        final yatras = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        return ListView.builder(
          itemCount: yatras.length,
          itemBuilder: (context, index) {
            final yatra = yatras[index];
            final yatraId = yatra['yatraId'] ?? 'No Title';
            final yatraCost = yatra['yatraCost'] ?? 'N/A';
            final title = yatra['yatraTitle'] ?? 'No Title';
            final date = yatra['depature'] ?? 'No Date';
            final date2 = yatra['arrival'] ?? 'No Date';
            final status = yatra['status'] ?? 'No Status';
            final imageUrl =
                (yatra['images'] != null && yatra['images'].isNotEmpty)
                    ? yatra['images'][0]
                    : 'https://via.placeholder.com/150';

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YatraDetailsScreen(
                      yatraData: yatra,
                      yatraId: yatraId,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  yatraId,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.currency_rupee,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    '$yatraCost/person',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.green),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Depature Date: $date',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            'Arrival Date: $date2',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: getStatusBackgroundColor(status),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
      key: scaffoldKey,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Yatras',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                _buildFilterButton(),
              ],
            ),
          ),
          Expanded(child: _buildYatraList()),
        ],
      ),
    );
  }

  Color getStatusBackgroundColor(String status) {
    switch (status) {
      case 'New':
        return Colors.orange[400]!;
      case 'Registration Open':
        return Colors.lightGreen;
      case 'Ongoing':
        return Colors.green;
      case 'Completed':
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
