import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
import 'package:yogayatra/sidemenu/myYatraListView.dart';

class YatraDetailsAndTransactionsScreen extends StatefulWidget {
  final Map<String, dynamic> yatraData;
  final String yatraId;

  const YatraDetailsAndTransactionsScreen({
    super.key,
    required this.yatraData,
    required this.yatraId,
  });

  @override
  _YatraDetailsAndTransactionsScreenState createState() =>
      _YatraDetailsAndTransactionsScreenState();
}

class _YatraDetailsAndTransactionsScreenState
    extends State<YatraDetailsAndTransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchTransactions();
  }

  // Fetch transaction details from Firestore
  // Future<void> _fetchTransactions() async {
  //   try {
  //     QuerySnapshot transactionSnapshot = await FirebaseFirestore.instance
  //         .collection('transactions')
  //         .where('yatraId', isEqualTo: widget.yatraId) // Match yatraId
  //         .get();

  //     setState(() {
  //       transactions = transactionSnapshot.docs
  //           .map((doc) => doc.data() as Map<String, dynamic>)
  //           .toList();
  //     });
  //   } catch (e) {
  //     print('Error fetching transactions: $e');
  //   }
  // }
  Future<void> _fetchTransactions() async {
    try {
      // Fetch userId from Shared Preferences
      await SharedPrefServices
          .init(); // Ensure shared preferences are initialized
      final userId = SharedPrefServices.getuserId().toString();

      if (userId.isEmpty) {
        print('User ID not found in shared preferences.');
        return;
      }

      // Fetch transactions where travellerId matches the userId
      QuerySnapshot transactionSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          // .where('yatraId', isEqualTo: widget.yatraId) // Match yatraId
          .where('travellerId',
              isEqualTo: userId) // Match travellerId with userId
          .get();
      if (transactionSnapshot.docs.isEmpty) {
        print(
            'No transactions found for yatraId: ${widget.yatraId} and travellerId: $userId');
      } else {
        print('Transactions found: ${transactionSnapshot.docs.length}');
      }

      setState(() {
        transactions = transactionSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          'Yatra Details & Transactions',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Yatra Details'),
            Tab(text: 'Transactions'),
          ],
          labelColor: Colors.white, // Selected tab text color
          unselectedLabelColor: Colors.black, // Unselected tab text color
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Yatra Details Screen
          // YatraDetailsScreen(
          //   yatraData: widget.yatraData,
          //   yatraId: widget.yatraId,
          // ),
          Myyatralistview(
            yatraData: widget.yatraData,
            yatraId: widget.yatraId,
          ),

          // Tab 2: Transactions
          transactions.isEmpty
              ? const Center(child: Text('No transactions available.'))
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transaction Date: ${transaction['transcationRegister']?.toDate() ?? 'N/A'}",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              "Paid Amount: ₹${transaction['paidAmount']}",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              "Due Amount: ₹${transaction['dueAmount']}",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              "Payment Type: ${transaction['paymentType']}",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              "Total Amount: ₹${transaction['totalAmount']}",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            if (transaction['notes'] != null &&
                                transaction['notes'].isNotEmpty)
                              Text(
                                "Notes: ${transaction['notes']}",
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
