import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class DayContainer extends StatefulWidget {
  final int dayNumber;
  final String title;
  final String description;
  final String imageUrl;

  DayContainer({
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  _DayContainerState createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${widget.dayNumber}',
              style: GoogleFonts.poppins(
                color: HexColor("#018a3c"),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.imageUrl,
                        height: 150,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.description),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
