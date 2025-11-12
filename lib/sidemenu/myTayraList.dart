import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yogayatra/oldscreens/landingScreen.dart';
import 'package:yogayatra/sidemenu/profileScreen.dart';
import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
import 'package:yogayatra/sidemenu/myYatraListDetailsScreen.dart';

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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Depature Date: $date'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Text('Arrival Date: $date2'),
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
                  'My Yatras List',
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
