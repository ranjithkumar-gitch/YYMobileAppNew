// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class NotificationPage extends StatelessWidget {
//   final List<Map<String, String>> notifications = [
//     {
//       "yatraId": "YY150",
//       "title": "Kedarnath Yatra",
//       "description":
//           "Your booking for Kedarnath Yatra is confirmed. Check details now."
//     },
//     {
//       "yatraId": "YY140",
//       "title": "Rishikesh Retreat",
//       "description":
//           "A peaceful retreat awaits you in Rishikesh. Don't miss out!"
//     },
//     {
//       "yatraId": "YY108",
//       "title": "Haridwar Pilgrimage",
//       "description": "Join us for the sacred Haridwar pilgrimage next weekend."
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Notifications',
//           style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//       ),
//       body: ListView.builder(
//         itemCount: notifications.length,
//         padding: const EdgeInsets.all(10),
//         itemBuilder: (context, index) {
//           final notification = notifications[index];
//           return Card(
//             elevation: 4,
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Yatra ID: ${notification['yatraId']}",
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     notification['title']!,
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     notification['description']!,
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "yatraId": "YY150",
      "title": "Kedarnath Yatra",
      "description":
          "Your booking for Kedarnath Yatra is confirmed. Check details now.",
      "date": "2024-12-17",
      "time": "10:30 AM",
      "imageUrl":
          "https://www.pngitem.com/pimgs/m/195-1951271_hindu-temple-in-kerala-png-transparent-png.png" // Replace with real image URL
    },
    {
      "yatraId": "YY140",
      "title": "Rishikesh Retreat",
      "description":
          "A peaceful retreat awaits you in Rishikesh. Don't miss out!",
      "date": "2024-12-16",
      "time": "03:45 PM",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGKQQCqjihrlk3C4h4U056rj53TSLxS3bs9w&s" // Replace with real image URL
    },
    {
      "yatraId": "YY108",
      "title": "Haridwar Pilgrimage",
      "description": "Join us for the sacred Haridwar pilgrimage next weekend.",
      "date": "2024-12-15",
      "time": "08:00 AM",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTtOmBfTpj-wTAc7mwU0DgbzLv8U-JEf4AVQ&s" // Replace with real image URL
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Yatra Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      notification['imageUrl']!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['title']!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          notification['description']!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date: ${notification['date']}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "Time: ${notification['time']}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
