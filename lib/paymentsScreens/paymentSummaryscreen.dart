import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yogayatra/paymentsScreens/payamountscreen.dart';

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
       title: Text('Payment Summary',style: GoogleFonts.poppins(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(right: 15,left: 15),
        child: Column(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const SizedBox(height: 10,),
                          
                             Row(
                              children: [
                                Text('Yatra Id :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                                const SizedBox(width: 10,),
                                 Text(
                                   'YYP120',
                                   style: GoogleFonts.poppins(
                                     color: Colors.black,
                                     fontWeight: FontWeight.w400,
                                     fontSize: 14,
                                   ),
                                   
                                 ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Text('Travel Date :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                               const SizedBox(width: 10,),
                                Text(
                                  '25-03-2024',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  
                                ),
                              ],
                            ),
                                 const SizedBox(height: 5,),
                            Row(
                              children: [
                                Text('No.of persons :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                                    const SizedBox(width: 10,),
                                Text(
                                  '3',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                        
                              ],
                            ),

                            const SizedBox(height: 10,),
                            
                          ],
                        ),
                      ),

                     GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const PayAmountScreen(totalAmount: 0, numberOfPeople: 0,)));
                      },
                       child: Chip(
                      side: BorderSide.none,
                      elevation: 3,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(0),
                    backgroundColor: HexColor('#018a3c'),
                     shadowColor: Colors.black,
                     label: Text(
                 '     Pay Now   ',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13),
                       ), 
                       ),
                     ), 
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25,),

            Stack(
              clipBehavior: Clip.none,
              children:[ 
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
                      const SizedBox(height: 15,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Yatra Cost :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                             Container( width: 150,
                               color: Colors.white,
                               child:  Row(
                                children: [
                                const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                              Text('31,500.0',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                    ],
                              )
                             ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Amount Paid :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 150,
                               color: Colors.white,
                               child:  Row(
                                    children: [
                             const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                               Text('10,500.0',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                    ],
                                   )
                             ),
                          ],
                        ),
                             const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Due :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 150,
                               color: Colors.white,
                               child:  Row(
                                    children: [
                             const Icon(Icons.currency_rupee,color: Colors.red,size: 15,),
                               Text('21,000.0',style: GoogleFonts.poppins(color: Colors.red,fontSize: 14,fontWeight: FontWeight.w400),),
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
          child: Text("Amount",style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),
        ),
        )))
          ]),

          const SizedBox(height: 25,),

            Stack(
              clipBehavior: Clip.none,
              children:[ 
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
                      const SizedBox(height: 15,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                             Container( width: 160,
                               color: Colors.white,
                               child:  Text('27-02-2024',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                
                             ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Amount Paid :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 160,
                               color: Colors.white,
                               child:  Row(
                                    children: [
                             const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                               Text('10,500.0',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                    ],
                                   )
                             ),
                          ],
                        ),
                       const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Mode :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 160,
                               color: Colors.white,
                               child: Text('PayTm',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                             ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Transcation No :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                            Container( width: 160,
                               color: Colors.white,
                               child: Text('pay_NfNFzXXZqX41FN',style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                             ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                      ],
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
          child: Text("Installment 1",style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),
        ),
        )))
          ]),

          ],
        ),
        )),
    );
  }
}


                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Yatra Id :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                      //      Container( width: 150,
                      //        color: Colors.white,
                      //        child: Text(
                      //          'YYP120',
                      //          style: GoogleFonts.poppins(
                      //            color: Colors.black,
                      //            fontWeight: FontWeight.w400,
                      //            fontSize: 14,
                      //          ),
                      //          textAlign: TextAlign.left,
                      //        ),
                      //      ),
                      //   ],
                      // ),
                      // const SizedBox(height: 5,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Travel Date :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                      //     Container( width: 150,
                      //        color: Colors.white,
                      //        child: Text(
                      //          '25-03-2024',
                      //          style: GoogleFonts.poppins(
                      //            color: Colors.black,
                      //            fontWeight: FontWeight.w400,
                      //            fontSize: 14,
                      //          ),
                      //          textAlign: TextAlign.left,
                      //        ),
                      //      ),
                      //   ],
                      // ),
                      //      const SizedBox(height: 5,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('No.of persons :',style: GoogleFonts.poppins(color: Colors.black ,fontWeight: FontWeight.w500,fontSize: 14),),
                      //     Container( width: 150,
                      //        color: Colors.white,
                      //        child: Text(
                      //          '3',
                      //          style: GoogleFonts.poppins(
                      //            color: Colors.black,
                      //            fontWeight: FontWeight.w400,
                      //            fontSize: 14,
                      //          ),
                      //          textAlign: TextAlign.left,
                      //        ),
                      //      ),
                  
                      //   ],
                      // ),