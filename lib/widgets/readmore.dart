import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ReadMoreWidget extends StatefulWidget {
  final String longtext;
  final String shorttext;

  const ReadMoreWidget({
    super.key,
    required this.longtext,
    required this.shorttext,
  });

  @override
  _ReadMoreWidgetState createState() => _ReadMoreWidgetState();
}

class _ReadMoreWidgetState extends State<ReadMoreWidget> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.longtext,
          style: TextStyle(),
          maxLines: isExpanded ? null : 3,
        ),
        // '',

        if (!isExpanded)
          GestureDetector(
            onTap: toggleExpanded,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Read more',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: HexColor("#018a3c"),
                  ),
                ],
              ),
            ),
          ),
        if (isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Destination Covered',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(widget.shorttext,
                  // ,
                  style: TextStyle()),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: toggleExpanded,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Read less',
                        style: TextStyle(
                          color: Colors.green, // Adjust as needed
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: HexColor("#018a3c"), // Adjust as needed
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
