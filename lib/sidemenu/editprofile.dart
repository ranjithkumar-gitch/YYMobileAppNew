import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? userProfileData;

  const EditProfilePage({Key? key, this.userProfileData}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isSaving = false;
  File? _frontIdProof;
  File? _backIdProof;
  File? _profilePic;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _aadharController;
  late TextEditingController _bloodGroupController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userProfileData?['firstName'] ?? '');
    _emailController =
        TextEditingController(text: widget.userProfileData?['emailId'] ?? '');
    _mobileController = TextEditingController(
        text: widget.userProfileData?['mobileNumber'] ?? '');
    _dobController =
        TextEditingController(text: widget.userProfileData?['dob'] ?? '');
    _genderController =
        TextEditingController(text: widget.userProfileData?['gender'] ?? '');
    _cityController =
        TextEditingController(text: widget.userProfileData?['city'] ?? '');
    _stateController =
        TextEditingController(text: widget.userProfileData?['state'] ?? '');
    _aadharController = TextEditingController(
        text: widget.userProfileData?['aadharNumber'] ?? '');
    _bloodGroupController = TextEditingController(
        text: widget.userProfileData?['bloodGroup'] ?? '');
  }

  Future<void> _pickProfilePic() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePic = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true; // Show progress bar
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) return;

    try {
      String? profilePicUrl;
      // String? frontIdProofUrl;
      // String? backIdProofUrl;
      List<String> idProofUrls = [];
      // Upload Profile Picture
      if (_profilePic != null) {
        String profilePicFileName = 'ProfilePics/$userId.jpg';
        TaskSnapshot snapshot =
            await _storage.ref(profilePicFileName).putFile(_profilePic!);
        profilePicUrl = await snapshot.ref.getDownloadURL();
      }

      // Upload Front ID Proof
      if (_frontIdProof != null) {
        String frontFileName = 'Govt_Id_Proof Images/$userId-Front.jpg';
        TaskSnapshot snapshot =
            await _storage.ref(frontFileName).putFile(_frontIdProof!);
        idProofUrls.add(await snapshot.ref.getDownloadURL());
      }

      if (_backIdProof != null) {
        String backFileName = 'Govt_Id_Proof Images/$userId-Back.jpg';
        TaskSnapshot snapshot =
            await _storage.ref(backFileName).putFile(_backIdProof!);
        idProofUrls.add(await snapshot.ref.getDownloadURL());
      }

      // Update Firestore Document
      // await _firestore.collection('users').doc(userId).update({
      //   'firstName': _nameController.text,
      //   'emailId': _emailController.text,
      //   'mobileNumber': _mobileController.text,
      //   'dob': _dobController.text,
      //   'gender': _genderController.text,
      //   'city': _cityController.text,
      //   'state': _stateController.text,
      //   'aadharNumber': _aadharController.text,
      //   'bloodGroup': _bloodGroupController.text,
      //   if (profilePicUrl != null) 'profilePic': profilePicUrl,
      //   'idProofImages': FieldValue.arrayUnion(idProofUrls),
      // });
      final docRef = _firestore.collection('users').doc(userId);

      await docRef.set({
        'firstName': _nameController.text,
        'emailId': _emailController.text,
        'mobileNumber': _mobileController.text,
        'dob': _dobController.text,
        'gender': _genderController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'aadharNumber': _aadharController.text,
        'bloodGroup': _bloodGroupController.text,
        if (profilePicUrl != null) 'profilePic': profilePicUrl,
        'idProofImages': FieldValue.arrayUnion(idProofUrls),
      }, SetOptions(merge: true));

      Navigator.pop(context);
    } catch (e) {
      print('Error updating profile: $e');
    } finally {
      setState(() {
        _isSaving = false; // Hide progress bar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileAvatar(),
                const SizedBox(height: 20),
                _buildEditableRow('Full Name', _nameController, Icons.person),
                _buildEditableRow('Email', _emailController, Icons.mail),
                _buildEditableRow(
                    'Mobile Number', _mobileController, Icons.phone),
                _buildEditableRow('Date of Birth', _dobController,
                    Icons.calendar_today_outlined),
                _buildEditableRow('Gender', _genderController, Icons.people),
                _buildEditableRow('City', _cityController, Icons.location_city),
                _buildEditableRow('State', _stateController, Icons.place),
                _buildEditableRow(
                    'Aadhar Number', _aadharController, Icons.credit_card),
                _buildEditableRow(
                    'Blood Group', _bloodGroupController, Icons.bloodtype),
                const SizedBox(height: 20),
                Text(
                  'Upload Govt ID Proof',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildImageUploader(
                      label: 'Front Side',
                      file: _frontIdProof,
                      onTap: () => _pickIdProof(isFront: true),
                    ),
                    _buildImageUploader(
                      label: 'Back Side',
                      file: _backIdProof,
                      onTap: () => _pickIdProof(isFront: false),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#018a3c'),
                    fixedSize: const Size(200, 50),
                  ),
                  child: Text(
                    'SAVE CHANGES',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (_isSaving)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[200],
          backgroundImage: _profilePic != null
              ? FileImage(_profilePic!)
              : (widget.userProfileData?['profilePic'] != null
                  ? NetworkImage(widget.userProfileData!['profilePic'])
                      as ImageProvider
                  : null),
          child: _profilePic == null &&
                  widget.userProfileData?['profilePic'] == null
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 10,
          child: GestureDetector(
            onTap: _pickProfilePic,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: HexColor('#018a3c'),
              child:
                  const Icon(Icons.camera_alt, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableRow(
      String title, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: HexColor('#018a3c')),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, color: HexColor('#018a3c'), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  isDense: true,
                ),
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImageUploader({
    required String label,
    required File? file,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: HexColor('#018a3c'), width: 2),
            ),
            child: file == null
                ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                : Image.file(file, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIdProof({required bool isFront}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontIdProof = File(pickedFile.path);
        } else {
          _backIdProof = File(pickedFile.path);
        }
      });
    }
  }
}
