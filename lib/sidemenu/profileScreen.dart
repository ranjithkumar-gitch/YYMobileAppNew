import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yogayatra/sidemenu/editprofile.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorNumberController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyPhoneController =
      TextEditingController();
  final TextEditingController medicalDescriptionController =
      TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    firstNameController.text = SharedPrefServices.getFirstName() ?? '';
    lastNameController.text = SharedPrefServices.getLastName() ?? '';
    emailController.text = SharedPrefServices.getEmailId() ?? '';
    phoneController.text = SharedPrefServices.getMobileNumber() ?? '';
    genderController.text = SharedPrefServices.getGender() ?? '';
    dobController.text = SharedPrefServices.getDob() ?? '';
    ageController.text = SharedPrefServices.getAge() ?? '';
    aadharController.text = SharedPrefServices.getAadharNumber() ?? '';
    bloodGroupController.text = SharedPrefServices.getBloodGroup() ?? '';
    cityController.text = SharedPrefServices.getCity() ?? '';
    stateController.text = SharedPrefServices.getState() ?? '';
    addressController.text = SharedPrefServices.getAddress() ?? '';
    doctorNameController.text = SharedPrefServices.getDoctorName() ?? '';
    doctorNumberController.text = SharedPrefServices.getDoctorNumber() ?? '';
    emergencyNameController.text = SharedPrefServices.getEmergencyName() ?? '';
    emergencyPhoneController.text =
        SharedPrefServices.getEmergencyPhone() ?? '';
    medicalDescriptionController.text =
        SharedPrefServices.getMedicalDescription() ?? '';
    relationController.text = SharedPrefServices.getRelationwithPrimary() ?? '';
    userTypeController.text = SharedPrefServices.getUserType() ?? '';
  }

  String _getUserInitials() {
    final first = SharedPrefServices.getFirstName() ?? '';
    final last = SharedPrefServices.getLastName() ?? '';
    return (first.isNotEmpty ? first[0].toUpperCase() : '') +
        (last.isNotEmpty ? last[0].toUpperCase() : '');
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = SharedPrefServices.getProfilePic();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 22, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "Profile Details",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: HexColor("#E8F5E9"),
                    backgroundImage:
                        (profileImage != null && profileImage.isNotEmpty)
                            ? NetworkImage(profileImage)
                            : null,
                    child: (profileImage == null || profileImage.isEmpty)
                        ? Text(
                            _getUserInitials(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _customTextField(
                controller: firstNameController, label: "First Name"),
            _customTextField(
                controller: lastNameController, label: "Last Name"),
            _customTextField(controller: genderController, label: "Gender"),
            _customTextField(controller: dobController, label: "Date of Birth"),
            _customTextField(controller: ageController, label: "Age"),
            _customTextField(
                controller: aadharController, label: "Aadhar Number"),
            _customTextField(
                controller: bloodGroupController, label: "Blood Group"),
            _customTextField(
                controller: phoneController, label: "Mobile Number"),
            _customTextField(controller: emailController, label: "Email"),
            _customTextField(controller: cityController, label: "City"),
            _customTextField(controller: stateController, label: "State"),
            _customTextField(controller: addressController, label: "Address"),
            _customTextField(
                controller: relationController, label: "Relation with Primary"),
            _customTextField(
                controller: userTypeController, label: "User Type"),
            const SizedBox(height: 10),

            // ✅ Medical & Emergency
            Divider(color: Colors.grey.shade400),
            const SizedBox(height: 5),
            Text("Medical Details",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.green)),
            const SizedBox(height: 10),
            _customTextField(
                controller: doctorNameController, label: "Doctor Name"),
            _customTextField(
                controller: doctorNumberController, label: "Doctor Number"),
            _customTextField(
                controller: medicalDescriptionController,
                label: "Medical Description"),
            const SizedBox(height: 10),

            Divider(color: Colors.grey.shade400),
            const SizedBox(height: 5),
            Text("Emergency Contact",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.green)),
            const SizedBox(height: 10),
            _customTextField(
                controller: emergencyNameController,
                label: "Emergency Contact Name"),
            _customTextField(
                controller: emergencyPhoneController,
                label: "Emergency Contact Number"),

            const SizedBox(height: 25),

            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(
                          userProfileData: {
                            'firstName': firstNameController.text,
                            'lastName': lastNameController.text,
                            'emailId': emailController.text,
                            'mobileNumber': phoneController.text,
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Edit Profile",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 13),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: HexColor("#F4F8F5"),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Colors.green.shade300, width: 1.3),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
