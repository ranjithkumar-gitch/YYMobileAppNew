import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static SharedPreferences? prefs;

  // 🔹 Keys
  static const _keyAadharNumber = 'aadharNumber';
  static const _keyAddress = 'address';
  static const _keyAge = 'age';
  static const _keyBloodGroup = 'bloodGroup';
  static const _keyCity = 'city';
  static const _keyCreditNote = 'creditNote';
  static const _keyDateofRegister = 'dateofRegister';
  static const _keyDeviceId = 'deviceId';
  static const _keyDob = 'dob';
  static const _keyDoctorName = 'doctorName';
  static const _keyDoctorNumber = 'doctorNumber';
  static const _keyEmailId = 'emailId';
  static const _keyEmergencyName = 'emergencyName';
  static const _keyEmergencyPhone = 'emergencyPhone';
  static const _keyFirstName = 'firstName';
  static const _keyGender = 'gender';
  static const _keyIdProofImages = 'idProofImages';
  static const _keyLastName = 'lastName';
  static const _keyLoggedIn = 'loggedIn';
  static const _keyMedicalDescription = 'medicalDescription';
  static const _keyMobileNumber = 'mobileNumber';
  static const _keyMyYatras = 'myYatras';
  static const _keyPrimaryId = 'primaryId';
  static const _keyProfilePic = 'profilePic';
  static const _keyRelationwithPrimary = 'relationwithPrimary';
  static const _keyState = 'state';
  static const _keyStatus = 'status';
  static const _keyUserId = 'userId';
  static const _keyUserType = 'userType';
  static const _keydocumentId = 'documentId';

  static Future init() async => prefs = await SharedPreferences.getInstance();

  // 🔹 Setters

  static Future setAadharNumber(String aadharNumber) async =>
      await prefs!.setString(_keyAadharNumber, aadharNumber);

  static Future setDocumentId(String documentId) async =>
      await prefs!.setString(_keydocumentId, documentId);

  static Future setAddress(String address) async =>
      await prefs!.setString(_keyAddress, address);

  static Future setAge(String age) async =>
      await prefs!.setString(_keyAge, age);

  static Future setBloodGroup(String bloodGroup) async =>
      await prefs!.setString(_keyBloodGroup, bloodGroup);

  static Future setCity(String city) async =>
      await prefs!.setString(_keyCity, city);

  static Future setCreditNote(String creditNote) async =>
      await prefs!.setString(_keyCreditNote, creditNote);

  static Future setDateofRegister(String dateofRegister) async =>
      await prefs!.setString(_keyDateofRegister, dateofRegister);

  static Future setDeviceId(String? deviceId) async =>
      await prefs!.setString(_keyDeviceId, deviceId ?? '');

  static Future setDob(String dob) async =>
      await prefs!.setString(_keyDob, dob);

  static Future setDoctorName(String doctorName) async =>
      await prefs!.setString(_keyDoctorName, doctorName);

  static Future setDoctorNumber(String doctorNumber) async =>
      await prefs!.setString(_keyDoctorNumber, doctorNumber);

  static Future setEmailId(String emailId) async =>
      await prefs!.setString(_keyEmailId, emailId);

  static Future setEmergencyName(String emergencyName) async =>
      await prefs!.setString(_keyEmergencyName, emergencyName);

  static Future setEmergencyPhone(String emergencyPhone) async =>
      await prefs!.setString(_keyEmergencyPhone, emergencyPhone);

  static Future setFirstName(String firstName) async =>
      await prefs!.setString(_keyFirstName, firstName);

  static Future setGender(String gender) async =>
      await prefs!.setString(_keyGender, gender);

  static Future setIdProofImages(List<String> idProofImages) async =>
      await prefs!.setStringList(_keyIdProofImages, idProofImages);

  static Future setLastName(String lastName) async =>
      await prefs!.setString(_keyLastName, lastName);

  static Future setLoggedIn(bool loggedIn) async =>
      await prefs!.setBool(_keyLoggedIn, loggedIn);

  static Future setMedicalDescription(String medicalDescription) async =>
      await prefs!.setString(_keyMedicalDescription, medicalDescription);

  static Future setMobileNumber(String mobileNumber) async =>
      await prefs!.setString(_keyMobileNumber, mobileNumber);

  static Future setMyYatras(List<String> myYatras) async =>
      await prefs!.setStringList(_keyMyYatras, myYatras);

  static Future setPrimaryId(String primaryId) async =>
      await prefs!.setString(_keyPrimaryId, primaryId);

  static Future setProfilePic(String profilePic) async =>
      await prefs!.setString(_keyProfilePic, profilePic);

  static Future setRelationwithPrimary(String relationwithPrimary) async =>
      await prefs!.setString(_keyRelationwithPrimary, relationwithPrimary);

  static Future setState(String state) async =>
      await prefs!.setString(_keyState, state);

  static Future setStatus(String status) async =>
      await prefs!.setString(_keyStatus, status);

  static Future setUserId(String userId) async =>
      await prefs!.setString(_keyUserId, userId);

  static Future setUserType(String userType) async =>
      await prefs!.setString(_keyUserType, userType);

  // 🔹 Getters

  static String? getAadharNumber() => prefs!.getString(_keyAadharNumber);
  static String? getDocumentId() => prefs!.getString(_keydocumentId);
  static String? getAddress() => prefs!.getString(_keyAddress);
  static String? getAge() => prefs!.getString(_keyAge);
  static String? getBloodGroup() => prefs!.getString(_keyBloodGroup);
  static String? getCity() => prefs!.getString(_keyCity);
  static String? getCreditNote() => prefs!.getString(_keyCreditNote);
  static String? getDateofRegister() => prefs!.getString(_keyDateofRegister);
  static String? getDeviceId() => prefs!.getString(_keyDeviceId);
  static String? getDob() => prefs!.getString(_keyDob);
  static String? getDoctorName() => prefs!.getString(_keyDoctorName);
  static String? getDoctorNumber() => prefs!.getString(_keyDoctorNumber);
  static String? getEmailId() => prefs!.getString(_keyEmailId);
  static String? getEmergencyName() => prefs!.getString(_keyEmergencyName);
  static String? getEmergencyPhone() => prefs!.getString(_keyEmergencyPhone);
  static String? getFirstName() => prefs!.getString(_keyFirstName);
  static String? getGender() => prefs!.getString(_keyGender);
  static List<String>? getIdProofImages() =>
      prefs!.getStringList(_keyIdProofImages);
  static String? getLastName() => prefs!.getString(_keyLastName);
  static bool getLoggedIn() => prefs!.getBool(_keyLoggedIn) ?? false;
  static String? getMedicalDescription() =>
      prefs!.getString(_keyMedicalDescription);
  static String? getMobileNumber() => prefs!.getString(_keyMobileNumber);
  static List<String>? getMyYatras() => prefs!.getStringList(_keyMyYatras);
  static String? getPrimaryId() => prefs!.getString(_keyPrimaryId);
  static String? getProfilePic() => prefs!.getString(_keyProfilePic);
  static String? getRelationwithPrimary() =>
      prefs!.getString(_keyRelationwithPrimary);
  static String? getState() => prefs!.getString(_keyState);
  static String? getStatus() => prefs!.getString(_keyStatus);
  static String? getUserId() => prefs!.getString(_keyUserId);
  static String? getUserType() => prefs!.getString(_keyUserType);

  static Future<void> clearUserFromSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    await prefs!.clear();
    print('✅ YogaYatra User Data Cleared from SharedPreferences.');
  }
}
