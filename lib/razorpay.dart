import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPay extends StatefulWidget {
  const RazorPay({super.key});

  @override
  State<RazorPay> createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
    Razorpay? _razorpay ;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Payment Successful: ${response.paymentId}',timeInSecForIosWeb: 30);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
      Fluttertoast.showToast(msg: 'Payment Error: ${response.code} - ${response.message}',timeInSecForIosWeb: 5);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
        Fluttertoast.showToast(msg: 'External Wallet: ${response.walletName}");',timeInSecForIosWeb: 5);

  }

   void openCheckout() {
    var options = {
      'key': 'rzp_test_aM11MjzWV8aLqv', 
      'amount': 30000, 
      'name': 'Balaji',
      'description': 'Test Payment',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm','PhonePay']
      }
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
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.teal,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
      title: Text("RazorPay Payments",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),),
    

    body:  Center(
        child: SizedBox(
          height: 45, width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              openCheckout();
            },
            child:  Text('Pay Now',style: GoogleFonts.poppins(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
          ),
        ),
      ),
    );
  }
}