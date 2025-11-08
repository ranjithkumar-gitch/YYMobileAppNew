import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogayatra/fontsizManager/fontsizeManager.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Adjust Font Size',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: 20,
              ),
              // Column(
              //   children: [
              //     ElevatedButton(

              //       onPressed: () => FontSizeManager.increaseFontSize(),
              //       style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         backgroundColor: Colors.green,
              //       ),
              //       child: Text(
              //         'Increase Font Size',
              //         style: GoogleFonts.poppins(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 16,
              //         ),
              //       ),
              //     ),
              //     ElevatedButton(
              //       onPressed: () => FontSizeManager.decreaseFontSize(),
              //       style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         backgroundColor: Colors.green,
              //       ),
              //       child: Text(
              //         'Decrease Font Size',
              //         style: GoogleFonts.poppins(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 16,
              //         ),
              //       ),
              //     ),
              //     ElevatedButton(
              //       onPressed: () => FontSizeManager.resetFontSize(),
              //       style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         backgroundColor: Colors.green,
              //       ),
              //       child: Text(
              //         'Reset Font Size',
              //         style: GoogleFonts.poppins(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 16,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Column(
                children: [
                  SizedBox(
                    width: double
                        .infinity, // Ensures the button stretches to the container's width
                    child: ElevatedButton(
                      onPressed: () => FontSizeManager.increaseFontSize(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Increase Font Size',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing between buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => FontSizeManager.decreaseFontSize(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Decrease Font Size',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => FontSizeManager.resetFontSize(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Reset Font Size',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // const Row(
              //   children: [
              //     ElevatedButton(
              //       onPressed: FontSizeManager.decreaseFontSize,
              //       child: Text('A-'),
              //     ),
              //     SizedBox(width: 8),
              //     ElevatedButton(
              //       onPressed: FontSizeManager.increaseFontSize,
              //       child: Text('A+'),
              //     ),
              //     SizedBox(width: 8),
              //     ElevatedButton(
              //       onPressed: FontSizeManager.resetFontSize,
              //       child: Text('Reset'),
              //     ),
              //   ],
              // ),
              SizedBox(height: 16),
              ValueListenableBuilder<double>(
                valueListenable: FontSizeManager.fontSizeNotifier,
                builder: (context, fontSize, child) {
                  return Text(
                    'Current Font Size: ${fontSize.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: fontSize),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
