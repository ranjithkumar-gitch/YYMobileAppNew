import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yogayatra/paymentsScreens/bookingConfirmed.dart';
import 'package:yogayatra/paymentsScreens/bookingIncomplete.dart';
import 'package:yogayatra/paymentsScreens/payamountscreen.dart';
import 'package:yogayatra/paymentsScreens/paymentSummaryscreen.dart';

class BookingSummary extends StatefulWidget {
  final double totalAmount;
  final int numberOfPeople;
  const BookingSummary({super.key,required this.totalAmount, required this.numberOfPeople});

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {

 



   
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
       appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text('Yatra Booking ',style: GoogleFonts.poppins(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
    ),
  backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15,),
      
      //
    
       Container(
        height: 40, width: double.infinity,
        color: HexColor("#018a3c"),
        child: Center(child: Text('Booking Summary',style: GoogleFonts.poppins(color: Colors.white ,fontSize: 16,fontWeight: FontWeight.w500),))),
    
        const SizedBox(height: 15,),
    
       Container(
        margin: const EdgeInsets.only(right: 15,left: 15),
     width: double.infinity,
       color: Colors.white,
       child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
    
      const SizedBox(height: 10,),

      Stack(
        clipBehavior: Clip.none,
        children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            const SizedBox(height: 15,),
            Text('Hyderabad - Shiridi YogaYatra',style: GoogleFonts.poppins(color: Colors.black ,fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5,),
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
      
        const SizedBox(height: 10,),
           ]
           ),
         ),
        ),
        ),
               Positioned(
              top: -10, left: 15,
              child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
         child: Container(
    height: 20, width: 110,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient:  LinearGradient(
        colors: [HexColor('#018a3c'),HexColor('#018a3c')],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,)), 
        child: Padding(
          padding: const EdgeInsets.only(left: 10,top: 0,bottom: 0),
          child: Text("Your Trip ",style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),
        ),
        )))
       ]),

      

      const SizedBox(height: 20,),

      Stack(
        clipBehavior: Clip.none,
        children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            const SizedBox(height: 15,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Yatra Cost :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                 Container( width: 150,
                   color: Colors.white,
                   child: Row(
          children: [
         const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
       Text('10,000.0',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
        ],
        )
           ),
              ],
            ),
          
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('No.of persons cost :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
              Container( width: 150,
                   color: Colors.white,
                   child: Row(
                     children: [
                      const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                       Text(
                        widget.totalAmount.toString(),
                         style: GoogleFonts.poppins(
                           color: Colors.black,
                           fontWeight: FontWeight.w400,
                           fontSize: 14,
                         ),
                         textAlign: TextAlign.left,
                       ),
                     ],
                   ),
                 ),
                ],
               ),

            const SizedBox(height: 5,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('GST and Taxes :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
              Container( width: 150,
                   color: Colors.white,
                   child: Row(
                     children: [
                      const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                       Text(
                         widget.totalAmount != 0 ? "1500.0" : "0.0",
                         style: GoogleFonts.poppins(
                           color: Colors.black,
                           fontWeight: FontWeight.w400,
                           fontSize: 14,
                         ),
                         textAlign: TextAlign.left,
                       ),
                     ],
                   ),
                 ),
                ],
               ),
      
                const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
              Container( width: 150,
                   color: Colors.white,
                   child: Row(
                     children: [
                      const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                       Text(
                        widget.totalAmount != 0 ? (widget.totalAmount + 1500).toString() : "0.0",
                         style: GoogleFonts.poppins(
                           color: Colors.black,
                           fontWeight: FontWeight.w400,
                           fontSize: 14,
                         ),
                         textAlign: TextAlign.left,
                       ),
                     ],
                   ),
                 ),
                ],
               ),
      
        const SizedBox(height: 10,),
           ]
           ),
         ),
        ),
        ),
               Positioned(
              top: -10, left: 15,
              child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
         child: Container(
    height: 20, width: 110,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient:  LinearGradient(
        colors: [HexColor('#018a3c'),HexColor('#018a3c')],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,)), 
        child: Padding(
          padding: const EdgeInsets.only(left: 10,top: 0,bottom: 0),
          child: Text("Price Details ",style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),
        ),
        )))
       ]),
       
    
                const SizedBox(height: 30,),
    
                             SizedBox(
                            height: 45 , width: double.infinity,
                              child:  ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PayAmountScreen(totalAmount: widget.totalAmount + 1500, numberOfPeople: widget.numberOfPeople,)));
                                    },
                                  style: ElevatedButton.styleFrom(
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      backgroundColor:  HexColor('#018a3c')),
                                  child:  Text("Pay Now",style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),))),

                           const SizedBox(height: 20,),
    
                                 SizedBox(
                                height: 45 , width: double.infinity,
                              child:  ElevatedButton(
                                  onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentSummaryScreen()));
                                    },
                                  style: ElevatedButton.styleFrom(
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                backgroundColor:  HexColor('#018a3c')),
                                  child:  Text("Payment Summary",style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),))),

       ],
       ),
       )
  
        ],
      ),
    ),
    );
  }
         }










  //  Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //      Text('Travel Date :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w400,fontSize: 14),),
  //      Text('25 March, 2024',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),),
  //      Text('')
       
  //     ],
  //     ),
    
  //     const SizedBox(height: 5,),
       
  //     Container(
  //     margin: const EdgeInsets.only(right: 175),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //      Text('Number of persons :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w400,fontSize: 14),),
  //      Text(widget.numberOfPeople.toString(),style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),),
  //     ],
  //     ),
  //     ),
    
  //      const SizedBox(height: 10,),
  //     Divider(color: Colors.grey.shade400,height: 1.5,),
  //     const SizedBox(height: 10,),
    
  //     Container(
  //      margin: const EdgeInsets.only(right: 35),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //      Text('Yatra cost :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w400,fontSize: 14),),
  //      Container(
  //       child: Row(
  //         children: [
  //        const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
  //      Text('10,000/-',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
  //      Text('Per Person',style: GoogleFonts.poppins(color: Colors.grey.shade700,fontSize: 14,fontWeight: FontWeight.w400),), ],
  //       )),
       
  //     ],
  //     ),
  //     ),
    
  //     const SizedBox(height: 10,),
    
  //     Container(
  //      margin: const EdgeInsets.only(right: 110),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //      Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //        children: [
  //          Text('No.of persons cost :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w400,fontSize: 14),),
        
  //        Row(
  //          children: [
  //            const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
  //            Text('10,000',style: GoogleFonts.poppins(color: Colors.grey.shade600,fontSize: 14,fontWeight: FontWeight.w500),), 
  //            Icon(Icons.clear,color: Colors.grey.shade600,size: 15,),
  //            Text(' ${widget.numberOfPeople.toString()}',style: GoogleFonts.poppins(color: Colors.grey.shade600,fontSize: 14,fontWeight: FontWeight.w500),),
  //          ],
  //        ),
  //        ],
  //      ),
  //       Container(
  //         child: Row(
  //         children: [
  //      const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
  //       Text(widget.totalAmount.toString(),style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),), ],
  //       )),
  //     ],
  //     ),
  //     ),
    
  //     const SizedBox(height: 10,),
    
  //     Container(
  //      margin: const EdgeInsets.only(right: 140),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
       
  //      Text('GST and Taxes :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w400,fontSize: 14),),
  //      Container(child: Row(
  //         children: [
  //           const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
  //       Text(widget.totalAmount != 0 ? "1500" : "0",style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),),  ],
  //       )),
      
  //     ],
  //     ),
  //     ),
    
  //     const SizedBox(height: 10,),
    
  //     Container(
  //      margin: const EdgeInsets.only(right: 120),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //      Text('Sub-Total :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),),
  //       Container(child: Row(
  //         children: [
  //           const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
  //      Text(widget.totalAmount != 0 ? (widget.totalAmount + 1500).toString() : "0",style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),),  ],
  //       )),
  //     ],
  //     ),
  //     ),



      //   Row(
      //    children: [
      //     Checkbox(
      //           value: partialPay ,
      //           side: BorderSide(color: Colors.grey.shade400, width: 1.5),
      //           checkColor: Colors.white,
      //           activeColor: partialPay ? HexColor('#018a3c') : Colors.grey,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(3)),
      //           onChanged: (value) {
      //           setState(() {
      //                 partialPay = value!;
      //                 if (partialPay) {
      //                   fullPay = false;
      //                 }
      //               });
    
      //           },
      //         ),
    
      //  Row(
      // children: [
      //  const Text(
      //     'Advance Payment (50%)',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w400,
      //       fontSize: 15,
      //     ),
      //   ),
      //   const SizedBox(width: 30),
      //   const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
      //       Text(
      //    widget.totalAmount != 0 ? ((widget.totalAmount + 1500) * 0.5).toStringAsFixed(2) : "0",  
      //    style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),
      //       ),
      // ],
      // ),
      // ],
      // ),
    
      
    
      //    Row(
      //    children: [
      //     Checkbox(
      //           value: fullPay ,
      //           side: BorderSide(color: Colors.grey.shade400, width: 1.5),
      //           checkColor: Colors.white,
      //           activeColor: fullPay ? HexColor('#018a3c') : Colors.grey,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(3)),
      //           onChanged: (value) {
      //              setState(() {
      //                 fullPay = value!;
      //                 if (fullPay) {
      //                   partialPay = false;
      //                 }
      //               });
    
      //           },
      //         ),
    
      //  Row(
      // children: [
      //  const Text(
      //     'Full Payment',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w400,
      //       fontSize: 15,
      //     ),
      //   ),
      //   const SizedBox(width: 30),
      //   const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
          
      //   Text(widget.totalAmount != 0 ? (widget.totalAmount + 1500).toString() : "0",
      //    style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 15),
      //       ),
      // ],
      // ),
      // ],
      // ),
    
      //        Visibility(
      //         visible: partialPay,
      //         child: Row(
      //           children: [
      //             const SizedBox(width: 15), 
      //              Text(
      //               'Amount Due Later',
      //               style: TextStyle(
      //                 color: Colors.grey.shade700,
      //                 fontWeight: FontWeight.w500,
      //                 fontSize: 14,
      //               ),
      //             ),
      //             const SizedBox(width: 10),
      //             Row(
      //               children: [
      //                 const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
          
      //                 Text(
      //                    widget.totalAmount != 0 ? ((widget.totalAmount + 1500) * 0.5).toStringAsFixed(2) : "0", 
      //                   style: GoogleFonts.poppins(
      //                     color: Colors.black,
      //                     fontWeight: FontWeight.w500,
      //                     fontSize: 15,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ), 