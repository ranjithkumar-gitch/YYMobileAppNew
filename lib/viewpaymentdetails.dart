import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yogayatra/razorpay.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  Map<String, dynamic>? matchedTraveller;
  List<Map<String, dynamic>> transactions = [];
  Razorpay? _razorpay;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Successful: ${response.paymentId}',
        timeInSecForIosWeb: 30);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Error: ${response.code} - ${response.message}',
        timeInSecForIosWeb: 5);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External Wallet: ${response.walletName}");',
        timeInSecForIosWeb: 5);
  }

  // void openCheckout() {
  //   var options = {
  //     'key': 'rzp_test_RZa3mGbco9w4Ms',
  //     'amount': _getDueAmountInPaise(),
  //     'name': 'YogaYatra',
  //     'description': 'Test Payment',
  //     'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
  //   };

  //   try {
  //     _razorpay?.open(options);
  //   } catch (e) {
  //     debugPrint('Error: ${e.toString()}');
  //   }
  // }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_RZa3mGbco9w4Ms',
      'amount': (amount * 100).toInt(),
      'name': 'YogaYatra',
      'description': 'Custom Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@example.com',
      },
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  int _getDueAmountInPaise() {
    final dueAmount =
        double.tryParse(matchedTraveller?['dueAmount']?.toString() ?? '0') ??
            0.0;
    return (dueAmount * 100).toInt();
  }

  @override
  void initState() {
    super.initState();
    _fetchTravellerData();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _fetchTravellerData() async {
    await SharedPrefServices.init();
    String? currentDocId = SharedPrefServices.getDocumentId();

    if (currentDocId == null || currentDocId.isEmpty) {
      debugPrint(' No docId found in SharedPreferences');
      return;
    }

    final snapshot =
        await FirebaseFirestore.instance.collection('travellers').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      List<dynamic> docIds = data['docIds'] ?? [];

      if (docIds.contains(currentDocId)) {
        setState(() {
          matchedTraveller = data;
        });
        _fetchTransactionsForTraveller(doc.id);
        break;
      }
    }
  }

  Future<void> _fetchTransactionsForTraveller(String travellerDocId) async {
    try {
      final transSnapshot = await FirebaseFirestore.instance
          .collection('transcations')
          .where('travellerId', isEqualTo: travellerDocId)
          .orderBy('transcationRegister', descending: true)
          .get();

      setState(() {
        transactions = transSnapshot.docs.map((e) => e.data()).toList();
      });

      debugPrint(" ${transactions.length} transactions found for traveller");
    } catch (e) {
      debugPrint("Error fetching transactions: $e");
    }
  }

  final numberFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 0,
  );

  String formatAmount(dynamic value) {
    final parsedValue = double.tryParse(value?.toString() ?? '0') ?? 0;
    return numberFormat.format(parsedValue);
  }

  @override
  Widget build(BuildContext context) {
    final hasDue = matchedTraveller != null &&
        double.tryParse(matchedTraveller!['dueAmount']?.toString() ?? '0')! > 0;
    return Scaffold(
      backgroundColor: HexColor('#F8F9FA'),
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          "Payment Details",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: matchedTraveller == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _travellerSummaryCard(),
                  const SizedBox(height: 25),
                  if (transactions.isNotEmpty)
                    Text(
                      "Transaction History",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 10),
                  ...transactions.map((txn) => _transactionCard(txn)).toList(),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
      floatingActionButton: hasDue
          ? Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    final due = double.tryParse(
                            matchedTraveller?['dueAmount']?.toString() ??
                                '0') ??
                        0.0;

                    showAmountDialog(due);
                  },
                  child: Text(
                    "Pay Now",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _travellerSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _paymentRow("Yatra ID :", matchedTraveller!['yatraId'] ?? ""),
          _paymentRow("Total Yatris :",
              (matchedTraveller!['numberofYatris'] ?? 0).toString()),
          _paymentRow(
              "Primary Include :", matchedTraveller!['primaryInclude'] ?? ""),
          _paymentRow("Yatra Cost (per person) :",
              formatAmount(matchedTraveller!['yatraCost'])),
          const SizedBox(height: 10),
          const DottedLine(dashColor: Colors.grey),
          const SizedBox(height: 10),
          _paymentRow("Total (Incl. Taxes) :",
              formatAmount(matchedTraveller!['grandTotal'])),
          _paymentRow(
              "Paid Amount :", formatAmount(matchedTraveller!['paidAmount'])),
          _paymentRow(
              "Due Amount :", formatAmount(matchedTraveller!['dueAmount'])),
        ],
      ),
    );
  }

  Widget _transactionCard(Map<String, dynamic> txn) {
    final ValueNotifier<bool> _isExpanded = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (context, expanded, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            // onTap: () => _isExpanded.value = !expanded,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Txn ID :",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              " ${txn['transactionId'] ?? ''}",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  // if (expanded) ...[
                  Divider(
                      thickness: 1, height: 20, color: Colors.grey.shade300),
                  _paymentRow(
                    "Receipt Date:",
                    _formatDate(txn['transcationRegister'] ?? 'N/A'),
                  ),
                  _paymentRow("Receipt No:", txn['receiptNumber'] ?? 'N/A'),
                  _paymentRow("Payment Mode:", txn['paymentType'] ?? 'N/A'),
                  _paymentRow(
                      "Total Amount:", formatAmount(txn['totalAmount'] ?? '0')),
                  _paymentRow(
                      "Paid Amount:", formatAmount(txn['paidAmount'] ?? '0')),
                  _paymentRow(
                      "Due Amount:", formatAmount(txn['dueAmount'] ?? '0')),
                  if ((txn['notes'] ?? '').isNotEmpty)
                    _paymentRow("Notes:", txn['notes']),
                  const SizedBox(height: 10),
                  if (txn['images'] != null && txn['images'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transcation Images:",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: txn['images'].length,
                            itemBuilder: (context, index) {
                              final imgUrl = txn['images'][index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imgUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
                // ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showAmountDialog(double dueAmount) {
    final TextEditingController amountController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Enter Payment Amount",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Amount: ${formatAmount(dueAmount.toStringAsFixed(2))}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter amount",
                      errorText: errorMessage,
                      filled: true,
                      fillColor: HexColor("#F4F8F5"),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.green.shade200, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.green.shade300, width: 1.3),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      final entered = double.tryParse(value) ?? 0;

                      if (entered > dueAmount) {
                        setState(() {
                          errorMessage =
                              "Amount cannot be greater than due amount (₹$dueAmount)";
                        });
                      } else {
                        setState(() {
                          errorMessage = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Colors.green, fontFamily: "inter"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final enteredAmount =
                            double.tryParse(amountController.text) ?? 0;

                        if (enteredAmount <= 0) {
                          setState(() {
                            errorMessage = "Please enter valid amount";
                          });
                          return;
                        }

                        if (enteredAmount > dueAmount) {
                          setState(() {
                            errorMessage =
                                "Amount cannot be greater than due amount";
                          });
                          return;
                        }

                        Navigator.pop(context);
                        openCheckout(enteredAmount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style:
                            TextStyle(color: Colors.white, fontFamily: "inter"),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _paymentRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.grey[800],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(dynamic timestamp) {
  if (timestamp == null) return "NA";
  if (timestamp is Timestamp) {
    final date = timestamp.toDate();
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
  return timestamp.toString();
}
