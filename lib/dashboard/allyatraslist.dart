import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';
import 'package:intl/intl.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';

class AllYatrasList extends StatefulWidget {
  const AllYatrasList({Key? key}) : super(key: key);

  @override
  _AllYatrasListState createState() => _AllYatrasListState();
}

class _AllYatrasListState extends State<AllYatrasList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _yatraDetails = [];
  bool _loading = true;
  String? _selectedStatus;
  @override
  void initState() {
    super.initState();
    _fetchYatrasForLoggedInUser();
  }

  Future<void> _fetchYatrasForLoggedInUser() async {
    await SharedPrefServices.init();

    setState(() => _loading = true);

    try {
      Query query = _firestore.collection('yatras');

      if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
        query = query.where('status', isEqualTo: _selectedStatus);
      }

      QuerySnapshot snapshot = await query.get();

      setState(() {
        _yatraDetails = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching yatras: $e");
      setState(() => _loading = false);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'registration open':
        return Colors.green;
      case 'registration closed':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green))
                : _yatraDetails.isEmpty
                    ? Center(
                        child: Text(
                          "No Yatras Found",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _yatraDetails.length,
                        itemBuilder: (context, index) {
                          final yatra = _yatraDetails[index];
                          final imageUrl = (yatra['images'] != null &&
                                  yatra['images'].isNotEmpty)
                              ? yatra['images'][0]
                              : 'https://via.placeholder.com/400';
                          final title = yatra['yatraTitle'] ?? 'Unknown Yatra';
                          final cost = yatra['yatraCost'] ?? '0';
                          final formattedCost = NumberFormat.currency(
                            locale: 'en_IN',
                            symbol: '₹ ',
                            decimalDigits: 0,
                          ).format(double.tryParse(cost) ?? 0);

                          final date = yatra['depature'] ?? 'N/A';
                          final date2 = yatra['arrival'] ?? 'N/A';
                          final status = yatra['status'] ?? 'N/A';

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => YatraDetailsScreen(
                                        yatraData: yatra,
                                        yatraId: yatra['yatraId'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Image.network(
                                              imageUrl,
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      margin: EdgeInsets.zero,
                                                      elevation: 1,
                                                      child: Container(
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3,
                                                                      vertical:
                                                                          0),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          5),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'Yatra Id ',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3,
                                                                      vertical:
                                                                          0),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          5),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                yatra['yatraId'] ??
                                                                    '',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$formattedCost / Person',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  title,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.green.shade500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 90,
                                                      child: Text(
                                                        'Departure :',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        date,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 90,
                                                      child: Text(
                                                        'Arrival :',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        date2,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            status,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
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
