import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
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

  void openCheckout() {
    var options = {
      'key': 'rzp_test_RZa3mGbco9w4Ms',
      'amount': '10000',
      'name': 'YogaYatra',
      'description': 'Test Payment',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 22, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "Donate Now",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(right: 15, left: 15),
        child: Column(
          children: [
            ClipRRect(
              child: Image.asset(
                'images/donation.png',
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
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
                  openCheckout();
                },
                child: Text(
                  "Donate Now",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
