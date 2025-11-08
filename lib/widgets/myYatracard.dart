import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomMyCard extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String title;
  final String date;
  final String price;
  final String status;
  final VoidCallback onTap;

  const CustomMyCard({
    Key? key,
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.onTap,
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
                            color: Colors.green,
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
                            onTap: onTap,
                            // onTap: () {
                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const FullMyYatraDetails()));
                            // },
                            child: Chip(
                              side: BorderSide.none,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(0),
                              backgroundColor: Colors.green,
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
                                    fontWeight: FontWeight.w500),
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
