import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String title;
  final String date;
  final String price;
  final String availability;

  const CustomCard({
    Key? key,
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.date,
    required this.price,
    required this.availability,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        margin: const EdgeInsets.only(right: 5, left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  width: 125,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        id,
                        style: GoogleFonts.poppins(
                            color: HexColor("#018a3c"),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> const FullYatraDetails()));
                            },
                            child: Chip(
                              side: BorderSide.none,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(0),
                              backgroundColor: HexColor('#018a3c'),
                              shadowColor: Colors.black,
                              label: Text(
                                ' View details ',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.currency_rupee,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  Text(
                                    price,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                'Per Person',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),

            //    SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //  onPressed: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const FullYatraDetails()));
            //  },
            //  style: ElevatedButton.styleFrom(
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            //     backgroundColor: HexColor('#018a3c')),
            //   child:  Text("VIEW DETAILS",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),))),
            // const SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}


                //    Row( 
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //    children: [
                //      GestureDetector(
                //       onTap: () {
                //         Navigator.push(context, MaterialPageRoute(builder: (context)=> const FullYatraDetails()));
                //       },
                //        child: Card(
                //         color: HexColor('#018a3c'),
                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                //           child: Text("View details",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13),),
                //         ),
                //        ),
                //      ),

                //      Column(
                //      crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //      children: [
                //        const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                //        Text(price,style: GoogleFonts.poppins(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                //         ],
                //       ),
                //        Text('Per Person',style: GoogleFonts.poppins(color: Colors.grey.shade600,fontSize: 12,fontWeight: FontWeight.w500),),
                //     ],
                //      )
                    
                //    ],
                //  )