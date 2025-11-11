import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart'; // To fetch deviceId
import 'package:yogayatra/registrationscreen/otpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "INDIA",
      example: "IN",
      displayName: "IN",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  /// Fetch unique deviceId for multi-login restriction
  // Future<String> _getDeviceId() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (await deviceInfo.deviceInfo is AndroidDeviceInfo) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     return androidInfo.id!;
  //   } else if (await deviceInfo.deviceInfo is IosDeviceInfo) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     return iosInfo.identifierForVendor!;
  //   }
  //   throw Exception("Unsupported platform for unique device ID");
  // }

  /// Login without OTP, implement multi-login condition
  Future<void> _loginWithoutOtp() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );

    try {
      // Query Firestore for user data
      var querySnapshot = await _firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Navigator.pop(context); // Close the progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number not registered')),
        );
        return;
      }

      // Get the user document and deviceId
      var userDoc = querySnapshot.docs.first;
      String userId = userDoc.id;
      Map<String, dynamic> userData = userDoc.data();
      // String currentDeviceId = await _getDeviceId();

      // Check multi-login condition
      // if (userData['loggedIn'] == true &&
      //     userData['deviceId'] != currentDeviceId) {
      //   Navigator.pop(context); // Close the progress dialog
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('User already logged in on another device!')),
      //   );
      //   return;
      // }

      // Update user document to mark logged in
      await _firestore.collection('users').doc(userId).update({
        'loggedIn': true,
        // 'deviceId': currentDeviceId,
      });

      // Save userId in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('mobileNumber', phoneNumber);

      Navigator.pop(context); // Close the progress dialog

      // Navigate to the dashboard or OTP screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Otp_screen()), // Replace with actual destination
      );
    } catch (e) {
      Navigator.pop(context); // Close the progress dialog in case of error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage('images/yogayatralogo.png'),
                        ),
                        Text(
                          "YogaYatra",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Yatri Login',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Enter your mobile number to login',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 15, 10, 15),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 600),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                            );
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _loginWithoutOtp,
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
