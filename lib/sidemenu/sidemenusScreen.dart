import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yogayatra/loginscrenns/loginscreen.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
import 'package:yogayatra/sidemenu/donations_screen.dart';
import 'package:yogayatra/sidemenu/profileScreen.dart';
import 'package:yogayatra/sidemenu/settingsPage.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({Key? key}) : super(key: key);

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final String firstName = SharedPrefServices.getFirstName() ?? '';
    final String email = SharedPrefServices.getEmailId() ?? '';
    final String mobile = SharedPrefServices.getMobileNumber() ?? '';
    final String profilePic = SharedPrefServices.getProfilePic() ?? '';
    final String firstLetter =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: profilePic.isNotEmpty
                          ? NetworkImage(profilePic)
                          : null,
                      child: profilePic.isEmpty
                          ? Text(
                              firstLetter,
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_forward_ios),
                      color: Colors.white,
                      iconSize: 25,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  firstName.isNotEmpty ? firstName : 'Hello, User',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  email.isNotEmpty ? email : mobile,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: Text(
              'My Profile',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism, color: Colors.green),
            title: Text(
              'Donations',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DonationsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.green),
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.green),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Are you sure you want to logout ?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "inter",
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.green, fontFamily: "inter"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    SharedPrefServices.clearUserFromSharedPrefs();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontFamily: "inter"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
