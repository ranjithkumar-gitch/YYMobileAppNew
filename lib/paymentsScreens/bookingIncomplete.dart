import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yogayatra/paymentsScreens/payamountscreen.dart';


class BookingIncomplete extends StatefulWidget {
  final double totalAmount;
  final int numberOfPeople;
  const BookingIncomplete({super.key,required this.totalAmount, required this.numberOfPeople});
  


  @override
  State<BookingIncomplete> createState() => _BookingIncompleteState();
}

class _BookingIncompleteState extends State<BookingIncomplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.white,
  body: SafeArea(
    child: Container(
      margin: const EdgeInsets.only(right: 15,left: 15),
     child:  Column(
      children: [
        const SizedBox(height: 200,),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.red,
        child: Icon(Icons.clear,color: Colors.white,size: 35,),),
         const SizedBox(height: 10,),
        Text('Booking Not Complete ',style: GoogleFonts.poppins(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w600),),
        const SizedBox(height: 10,),
        Text('Your booking has not been confirmed. ',style: GoogleFonts.poppins(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
        const SizedBox(height: 10,),
        Text('Please review the payment details. ',style: GoogleFonts.poppins(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
        const SizedBox(height: 40,),

        SizedBox(
         height: 45, width: double.infinity,
          child: ElevatedButton(onPressed: (){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  PayAmountScreen(totalAmount: widget.totalAmount,numberOfPeople: widget.numberOfPeople,)));
          },  style: ElevatedButton.styleFrom(backgroundColor:   HexColor('#018a3c')),
          child: Text('Pay now',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500))),
        ),
        //  SizedBox(
        //     height: 45, width: 160,
        //    child: ElevatedButton(onPressed: (){},  style: ElevatedButton.styleFrom(backgroundColor:   HexColor('#018a3c')),
        //     child: Text('My Yatras',style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500))),
        //  )
        
      ],
     ),
    ),
  ),
    );
  }
}