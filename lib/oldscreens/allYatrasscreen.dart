import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yogayatra/yatrafullDetails/yatraDetailsScreen.dart';

import 'package:yogayatra/exampleMyyatra.dart';

import 'package:yogayatra/widgets/allYatracard.dart';
import 'package:intl/intl.dart';
import 'package:yogayatra/widgets/myYatracard.dart';

class AllYatraScreen extends StatefulWidget {
  const AllYatraScreen({super.key, required List<Map<String, dynamic>> yatras});

  @override
  State<AllYatraScreen> createState() => _AllYatraScreenState();
}

class _AllYatraScreenState extends State<AllYatraScreen> {
  TextEditingController date = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  bool scheduled = false;
  bool confirm = false;
  bool cancel = false;
  bool pending = false;
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(right: 15, left: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Yatras',
                        style: GoogleFonts.poppins(
                            color: HexColor("#018a3c"),
                            fontSize: 19,
                            fontWeight: FontWeight.w500),
                      ),
                      PopupMenuButton<int>(
                        icon: Icon(
                          Icons.filter_list,
                          color: HexColor("#018a3c"),
                          size: 25,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);

                                searchDaterange();
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date Range",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                searchcategories();
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Status",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),

              const SizedBox(
                height: 10,
              ),
              // const CustomCard(
              //     imageUrl:
              //         'https://i0.wp.com/exploremyways.com/wp-content/uploads/2017/09/Puri-yatra.jpg?resize=640%2C426&ssl=1',
              //     id: 'YYP212',
              //     title: 'Hyderabad - Puri Jagannath YogaYatra ',
              //     date: '18 Jan - 25 Jan 2024',
              //     price: '25,000',
              //     availability: 'Total : 25 to 60 seats filled'),
              // const SizedBox(
              //   height: 10,
              // ),
              // const CustomCard(
              //     imageUrl:
              //         'https://imgmedia.lbb.in/media/2020/03/5e65d3c9dbd2496a507869ba_1583731657886.jpg',
              //     id: 'YYP224',
              //     title: 'Tamil Nadu - Kerala YogaYatra ',
              //     date: '24 Mar - 29 Mar 2024',
              //     price: '10,000',
              //     availability: 'Total : 25 to 60 seats filled'),
              // const SizedBox(
              //   height: 10,
              // ),
              // const CustomCard(
              //     imageUrl:
              //         'https://img-cdn.thepublive.com/fit-in/640x430/filters:format(webp)/theframes/media/media_files/QB0KW0UDfmsisRy1c8EM.png',
              //     id: 'YYP230',
              //     title: 'Coimbatore - Kerala YogaYatra ',
              //     date: '12 Apr - 20 Apr 2024',
              //     price: '40,000',
              //     availability: 'Total : 25 to 60 seats filled'),
              // const SizedBox(
              //   height: 10,
              // ),
              // const CustomCard(
              //     imageUrl:
              //         'https://media.licdn.com/dms/image/D4D12AQG1UdH1Ne9YQQ/article-cover_image-shrink_600_2000/0/1664778136938?e=2147483647&v=beta&t=PhSdYtlm4BybdofP0pArBKuUP14DXfLL4MwKDEmvsYE',
              //     id: 'YYP235',
              //     title: 'Madurai - Kanyakumari YogaYatra ',
              //     date: '10 May - 20 May 2024',
              //     price: '30,000',
              //     availability: 'Total : 25 to 60 seats filled'),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchDaterange() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date Range",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.clear,
                              size: 25,
                              color: Colors.black,
                            ),
                          )
                        ])),
                const SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Start Date",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: 150,
                            child: TextFormField(
                                controller: startDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                    color: HexColor("#018a3c"),
                                  ),
                                  hintText: 'Select date',
                                  hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                ),
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2101),
                                  );

                                  if (pickeddate != null) {
                                    final formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickeddate);
                                    startDate.text = formattedDate;
                                    // setState(() {
                                    //   startDate.text = formattedDate;
                                    // });
                                  }
                                }),
                          ),
                        ])),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "End Date",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: 150,
                            child: TextFormField(
                                controller: endDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.calendar_month,
                                      color: HexColor("#018a3c")),
                                  hintText: 'Select date',
                                  hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                ),
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2101),
                                  );

                                  if (pickeddate != null) {
                                    final formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickeddate);
                                    endDate.text = formattedDate;
                                    // setState(() {

                                    // });
                                  }
                                }),
                          ),
                        ])),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () {
                        if (startDate.text.toString().isEmpty ||
                            endDate.text.toString().isEmpty) {
                        } else if (startDate.text.toString().isNotEmpty &&
                            endDate.text.toString().isNotEmpty) {
                          setState(() {});

                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("#018a3c"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      child: Text("Submit",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void searchcategories() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return SizedBox(
              height: 330,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 15, left: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              )
                            ])),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(
                                  "Scheduled",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                activeColor: HexColor("#018a3c"),
                                checkColor: Colors.white,
                                value: scheduled,
                                onChanged: (value) {
                                  setState(() {
                                    scheduled = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(
                                  "Confirmed",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                activeColor: HexColor("#018a3c"),
                                checkColor: Colors.white,
                                value: confirm,
                                onChanged: (value) {
                                  setState(() {
                                    confirm = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(
                                  "Cancelled",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                activeColor: HexColor("#018a3c"),
                                checkColor: Colors.white,
                                value: cancel,
                                onChanged: (value) {
                                  setState(() {
                                    cancel = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(
                                  "Pending",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                activeColor: HexColor("#018a3c"),
                                checkColor: Colors.white,
                                value: pending,
                                onChanged: (value) {
                                  setState(() {
                                    pending = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(
                                  "Completed",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                activeColor: HexColor("#018a3c"),
                                checkColor: Colors.white,
                                value: completed,
                                onChanged: (value) {
                                  setState(() {
                                    completed = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {});

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#018a3c"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          child: Text("Submit",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
