import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyYatrasListScreen extends StatefulWidget {
  const MyYatrasListScreen({Key? key}) : super(key: key);

  @override
  _MyYatrasListScreenState createState() => _MyYatrasListScreenState();
}

class _MyYatrasListScreenState extends State<MyYatrasListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedStatus;
  List<Map<String, dynamic>> _yatraDetails = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTravellerYatras();
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

  Future<void> _fetchTravellerYatras() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      // Step 1: Fetch traveller docs that include this user
      final travellerSnapshot = await _firestore
          .collection('travellers')
          .where('docIds', arrayContains: userId)
          .get();

      if (travellerSnapshot.docs.isEmpty) {
        setState(() => _loading = false);
        return;
      }

      List<Map<String, dynamic>> yatras = [];

      // Step 2: For each traveller document, get the corresponding Yatra
      for (var travellerDoc in travellerSnapshot.docs) {
        final travellerData = travellerDoc.data();
        final yatraId = travellerData['yatraId'];

        if (yatraId != null) {
          final yatraSnapshot = await _firestore
              .collection('yatras')
              .where('yatraId', isEqualTo: yatraId)
              .get();

          if (yatraSnapshot.docs.isNotEmpty) {
            final yatraData = yatraSnapshot.docs.first.data();
            yatras.add(yatraData);
          }
        }
      }

      setState(() {
        _yatraDetails = yatras;
        _loading = false;
      });
    } catch (e) {
      print("Error fetching Yatras: $e");
      setState(() => _loading = false);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'registration open':
        return Colors.green;
      case 'registration closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _yatraDetails.isEmpty
              ? const Center(child: Text('No Yatras found'))
              : ListView.builder(
                  itemCount: _yatraDetails.length,
                  itemBuilder: (context, index) {
                    final yatra = _yatraDetails[index];
                    final imageUrl =
                        (yatra['images'] != null && yatra['images'].isNotEmpty)
                            ? yatra['images'][0]
                            : 'https://via.placeholder.com/400';
                    final title = yatra['yatraTitle'] ?? 'Unknown Yatra';
                    final cost = yatra['yatraCost'] ?? '0';
                    final date = yatra['depature'] ?? 'N/A';
                    final date2 = yatra['arrival'] ?? 'N/A';
                    final status = yatra['status'] ?? 'N/A';

                    return Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Yatras',
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
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            yatra['yatraId'] ?? '',
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
                                              '$cost /person',
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
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Departure Date: $date',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text(
                                      'Arrival Date: $date2',
                                      style: const TextStyle(fontSize: 15),
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
                      ],
                    );
                  },
                ),
    );
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
}
