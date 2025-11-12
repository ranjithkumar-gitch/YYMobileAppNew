import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogayatra/dashboard/homePage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';

class Otp_screen extends StatefulWidget {
  const Otp_screen({super.key});

  @override
  State<Otp_screen> createState() => _Otp_screenState();
}

class _Otp_screenState extends State<Otp_screen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _verifyOtp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context);

    if (_otpController.text != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mobileNumber = prefs.getString('mobileNumber');

      if (mobileNumber == null || mobileNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Mobile number not found in local storage')),
        );
        return;
      }

      var querySnapshot = await _firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: mobileNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found')),
        );
        return;
      }

      var userDoc = querySnapshot.docs.first;
      Map<String, dynamic> userData = userDoc.data();

      await SharedPrefServices.init();
      await SharedPrefServices.setDocumentId(userDoc.id);

      await SharedPrefServices.setUserId(userData['userId'] ?? '');
      await SharedPrefServices.setFirstName(userData['firstName'] ?? '');
      await SharedPrefServices.setLastName(userData['lastName'] ?? '');
      await SharedPrefServices.setGender(userData['gender'] ?? '');
      await SharedPrefServices.setAge(userData['age'] ?? '');
      await SharedPrefServices.setDob(userData['dob'] ?? '');
      await SharedPrefServices.setAadharNumber(userData['aadharNumber'] ?? '');
      await SharedPrefServices.setAddress(userData['address'] ?? '');
      await SharedPrefServices.setBloodGroup(userData['bloodGroup'] ?? '');
      await SharedPrefServices.setCity(userData['city'] ?? '');
      await SharedPrefServices.setCreditNote(userData['creditNote'] ?? '0.00');
      // await SharedPrefServices.setDateofRegister(
      //     userData['dateofRegister'] ?? '');
      await SharedPrefServices.setDoctorName(userData['doctorName'] ?? '');
      await SharedPrefServices.setDoctorNumber(userData['doctorNumber'] ?? '');
      await SharedPrefServices.setEmailId(userData['emailId'] ?? '');
      await SharedPrefServices.setEmergencyName(
          userData['emergencyName'] ?? '');
      await SharedPrefServices.setEmergencyPhone(
          userData['emergencyPhone'] ?? '');
      await SharedPrefServices.setMedicalDescription(
          userData['medicalDescription'] ?? '');
      await SharedPrefServices.setMobileNumber(userData['mobileNumber'] ?? '');
      await SharedPrefServices.setPrimaryId(userData['primaryId'] ?? '');
      await SharedPrefServices.setProfilePic(userData['profilePic'] ?? '');
      await SharedPrefServices.setRelationwithPrimary(
          userData['relationwithPrimary'] ?? '');
      await SharedPrefServices.setState(userData['state'] ?? '');
      await SharedPrefServices.setStatus(userData['status'] ?? '');
      await SharedPrefServices.setUserType(userData['userType'] ?? '');
      await SharedPrefServices.setLoggedIn(true);

      await SharedPrefServices.setIdProofImages(
          List<String>.from(userData['idProofImages'] ?? []));
      await SharedPrefServices.setMyYatras(
          List<String>.from(userData['myYatras'] ?? []));

      print("Shared Preferences Data (YogaYatra User):");
      print("UserId: ${SharedPrefServices.getUserId()}");
      print("First Name: ${SharedPrefServices.getFirstName()}");
      print("Last Name: ${SharedPrefServices.getLastName()}");
      print("Gender: ${SharedPrefServices.getGender()}");
      print("Age: ${SharedPrefServices.getAge()}");
      print("DOB: ${SharedPrefServices.getDob()}");
      print("AadharNumber: ${SharedPrefServices.getAadharNumber()}");
      print("Address: ${SharedPrefServices.getAddress()}");
      print("BloodGroup: ${SharedPrefServices.getBloodGroup()}");
      print("City: ${SharedPrefServices.getCity()}");
      print("CreditNote: ${SharedPrefServices.getCreditNote()}");
      print("DateofRegister: ${SharedPrefServices.getDateofRegister()}");
      print("DoctorName: ${SharedPrefServices.getDoctorName()}");
      print("DoctorNumber: ${SharedPrefServices.getDoctorNumber()}");
      print("EmailId: ${SharedPrefServices.getEmailId()}");
      print("EmergencyName: ${SharedPrefServices.getEmergencyName()}");
      print("EmergencyPhone: ${SharedPrefServices.getEmergencyPhone()}");
      print(
          "MedicalDescription: ${SharedPrefServices.getMedicalDescription()}");
      print("MobileNumber: ${SharedPrefServices.getMobileNumber()}");
      print("PrimaryId: ${SharedPrefServices.getPrimaryId()}");
      print("ProfilePic: ${SharedPrefServices.getProfilePic()}");
      print(
          "RelationwithPrimary: ${SharedPrefServices.getRelationwithPrimary()}");
      print("State: ${SharedPrefServices.getState()}");
      print("Status: ${SharedPrefServices.getStatus()}");
      print("UserType: ${SharedPrefServices.getUserType()}");
      print("LoggedIn: ${SharedPrefServices.getLoggedIn()}");
      print("IdProofImages: ${SharedPrefServices.getIdProofImages()}");
      print("MyYatras: ${SharedPrefServices.getMyYatras()}");
      print("DocumentID: ${SharedPrefServices.getDocumentId()}");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 35),
                    const Text(
                      "Verification Code",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Enter the 6-Digit Code sent to you",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 6,
                  controller: _otpController,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _verifyOtp,
                    child: Text(
                      'VERIFY',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Didn't receive any code?",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Resend OTP",
                        style: GoogleFonts.poppins(
                          color: Colors.orange.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
