import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yogayatra/paymentsScreens/bookingConfirmed.dart';
import 'package:yogayatra/paymentsScreens/bookingIncomplete.dart';

class PayAmountScreen extends StatefulWidget {
  final double totalAmount;
  final int numberOfPeople;
  const PayAmountScreen({super.key,required this.totalAmount, required this.numberOfPeople});
  

  @override
  State<PayAmountScreen> createState() => _PayAmountScreenState();
}

class _PayAmountScreenState extends State<PayAmountScreen> {

  String? payment;
   List<String> payments = ['Credit Card','Debit Card','NetBanking','UPI','PayTm'];

  bool valuecheck = false; 


  TextEditingController dateController = TextEditingController();

   TextEditingController amountController = TextEditingController();

  bool todayDate = false;  

  Razorpay? _razorpay ;

   void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Payment Successful: ${response.paymentId}',timeInSecForIosWeb: 8);
     double amountInPaisa = double.parse(amountController.text) * 100;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  BookingConfirmed(paymentId : response.paymentId,totalAmount: amountInPaisa,numberOfPeople : widget.numberOfPeople)));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
   Fluttertoast.showToast(msg: 'Payment Error: ${response.code} - ${response.message}',timeInSecForIosWeb: 5);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  BookingIncomplete(totalAmount: widget.totalAmount,numberOfPeople: widget.numberOfPeople,)));

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
  Fluttertoast.showToast(msg: 'External Wallet: ${response.walletName}");',timeInSecForIosWeb: 5);

  }



  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout() {

  double amountInPaisa = double.parse(amountController.text) * 100;

  

    var options = {
      'key': 'rzp_test_aM11MjzWV8aLqv'  , 
      'amount': amountInPaisa,
      'name': 'YogaYatra',
      'description': 'Yatra Booking ',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'external': {
      'wallets': ['paytm','PhonePay']
      },
      'theme': {
      'color':  '#018a3c',},
    
      // 'image': 'https://i.im.ge/2024/02/22/gmhx0Y.yogayatralogo.png' 

     };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }

    }


   TextInputFormatter amountFormatter() {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (newValue.text == '0' || newValue.text.startsWith('-')) {
      return oldValue;
    }
    int maxLength = 6;
    if (newValue.text.length > maxLength) {
      return oldValue;
    }
    if (!RegExp(r'^[0-9]*$').hasMatch(newValue.text)) {
      return oldValue;
    }
    if (oldValue.text.length > newValue.text.length) {
      return newValue;
    }
    return newValue;
  });
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
        backgroundColor: Colors.white,
       title: Text('Payment Details',style: GoogleFonts.poppins(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(right: 15,left: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const  SizedBox(height: 10,),
            Card(
             elevation: 1,
              color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side:  BorderSide(color: HexColor('#018a3c'))),
                child: Container(
                   width: double.infinity,
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: HexColor('#018a3c')),color:Colors.white),
                  child: Container(
                    margin: const EdgeInsets.only(right: 5,left: 8),
                    child: Column(
                      children: [
                      const SizedBox(height: 10,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Yatra Id :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                             Container( width: 150,
                               color: Colors.white,
                               child: Text(
                                 'YYP120',
                                 style: GoogleFonts.poppins(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w400,
                                   fontSize: 14,
                                 ),
                                 textAlign: TextAlign.left,
                               ),
                             ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Travel Date :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 150,
                               color: Colors.white,
                               child: Text(
                                 '25-03-2024',
                                 style: GoogleFonts.poppins(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w400,
                                   fontSize: 14,
                                 ),
                                 textAlign: TextAlign.left,
                               ),
                             ),
                          ],
                        ),
                             const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('No.of persons :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 150,
                               color: Colors.white,
                               child: Text(
                                 widget.numberOfPeople.toString(),
                                 style: GoogleFonts.poppins(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w400,
                                   fontSize: 14,
                                 ),
                                 textAlign: TextAlign.left,
                               ),
                             ),
                          ],
                        ),
                       const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total amount :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 150,
                               color: Colors.white,
                               child: Row(
                                 children: [
                              const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                         Text(widget.totalAmount.toString(),style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                              ],
                             )
                             ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),
          
             const  SizedBox(height: 15,),
          
                                      Container(
                                          margin: const EdgeInsets.only(left: 5,right: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Amount",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                               Container(child: Row(
                                                            children: [
                                                              Transform.scale(
                                                                scale: 0.8,
                                                                child: Checkbox(
                                                                  activeColor: HexColor('#018a3c'),
                                                                  value: valuecheck,
                                                                  onChanged: (bool? value) {
                                                                    setState(() {
                                                                      valuecheck = value!;
                                                                       if (valuecheck) {
                                                      amountController.text = widget.totalAmount.toString();
                                                             } else {
                                                       amountController.clear();
                                                                     }
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              Text(
                                                                "Full Payment",
                                                                style: GoogleFonts.poppins(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              
                                                            ],
                                                  ),)
                                            ],
                                          ),
                                           ),
          

                                        SizedBox(
                                            height: 40,
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: amountController,
                                               textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                               inputFormatters: [amountFormatter()],
                                             
                                               style: const TextStyle( 
                                            color:  Colors.black, fontSize: 15,fontWeight: FontWeight.w400
                                                 ),
                                              decoration: InputDecoration(
                                                enabled: !valuecheck,
                                                
                                                hintText:  "Enter amount in installments",
                                                 hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.grey.shade600),
                                               contentPadding: const EdgeInsets.fromLTRB(12, 8, 10, 15),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Colors.grey)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Colors.grey)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Colors.grey)),
                                                        disabledBorder: OutlineInputBorder(
                                                         borderRadius: BorderRadius.circular(10),
                                                        borderSide: const BorderSide(color: Colors.grey),
                                                       ),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                                  prefixIcon: Icon(Icons.currency_rupee,color:HexColor('#018a3c'),size: 20,)
                                              ),
                                            ),
                                      ),
          
                                    const SizedBox(height: 15,),
          
                                     Text("Date",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
          
                                       const SizedBox(height: 10,),
          
                                    SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: dateController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: "Pick date",
                                       hintStyle: TextStyle(color: Colors.grey.shade700,fontSize: 15,fontWeight: FontWeight.w400),
                                       contentPadding: const EdgeInsets.fromLTRB(12, 8, 10, 15),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                              
                                    ),
             onTap: () async {
            if (!todayDate) {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                  todayDate = true;
                });
              }
            }
                  },
                   ),
                     ),
          
                  const SizedBox(height: 15,),
                  Text("Payment Mode",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                 const SizedBox(height: 10,),
          
                         Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                height: 40,
                                width: double.infinity,
                                child: 
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                      icon:  Padding(
                                        padding: const  EdgeInsets.only(left: 50,bottom: 10),
                                        child:  Icon(Icons.arrow_drop_down_rounded, color:HexColor('#018a3c'), size: 43),
                                      ),
                                      hint: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Select your payment mode',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      
                                      value: payment,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          payment = newValue;
                                        });
                                      },
                                      items: payments.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Text(
                                              value,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      ),
                                    ),
                                 
                              ),
          
                               const SizedBox(height: 40,),
              
                               SizedBox(
                              height: 45 , width: double.infinity,
                                child:  ElevatedButton(
                                    onPressed: () {
                                      openCheckout();
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> PayAmountScreen()));
                                      },
                                    style: ElevatedButton.styleFrom(
                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        backgroundColor:  HexColor('#018a3c')),
                                    child:  Text("Pay Now",style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),))),
             
          
            
              
            ],
                  ),
          ),
      ),

          
          ),
        );
  
  }
}