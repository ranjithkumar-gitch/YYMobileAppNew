import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:yogayatra/registrationscreen/otpScreen.dart';
import 'package:image_picker/image_picker.dart';


class RegistrationScreen extends StatefulWidget {
  
 const RegistrationScreen({super.key});


  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
String? gender;
   List<String> cities = ['Male','Female','Other',];

  final TextEditingController phoneController = TextEditingController();
   final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  File? image;
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final qualifiedController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conformController = TextEditingController();

  String age = '0';
  
  String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  @override
  void dispose() {
    super.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    
  }

  return image;
}

  


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: 
      SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.only(right: 15,left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                    size: 25,
                                  )),
                            
                               Text('Yatri Sign In',style: GoogleFonts.poppins(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
                        
                              const  Icon(Icons.arrow_back_ios_sharp,color: Colors.transparent,)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                            
                             Center(
                               child: Stack(
                                clipBehavior: Clip.none,
                                 children:[ image == null
                                 ?  CircleAvatar(
                                     backgroundColor: Colors.grey.shade300,
                                     radius: 50,
                                     child: const Icon(Icons.person,size: 80,color: Colors.grey,),
                                   )
                                 : CircleAvatar(
                                     backgroundImage: FileImage(image!),
                                     radius: 50,
                                   ),
                                 Positioned(
                                  bottom: 10, right: -15,
                                  child: IconButton(onPressed: () => selectImage(), icon: Icon(
                                          Icons.camera_alt,
                                          size: 30,
                                          color: HexColor('#018a3c'),
                                          ),)
                                       ,)
                               ] ),
                             ),
            //
      
                    const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              // name field

                               SizedBox(
                                height: 70,
                                width: double.infinity,
                                child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                   
                                  decoration: InputDecoration(
                                    hintText: "Enter phone number",
                                     hintStyle: TextStyle(color: Colors.grey.shade700,fontSize: 15,fontWeight: FontWeight.w400),
                                     contentPadding: const EdgeInsets.fromLTRB(12, 12, 10, 15),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 15, 10, 15),
                                      child: InkWell(
                                        onTap: () {
                                          showCountryPicker(
                                              context: context,
                                              countryListTheme:
                                               const CountryListThemeData(
                                               bottomSheetHeight: 600),
                                              onSelect: (value) {
                                                setState(() {
                                                  selectedCountry = value;
                                                });
                                                print(selectedCountry);
                                                inspect(selectedCountry);
                                              });
                                        },
                                        child: Text("${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",style: GoogleFonts.poppins(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),)
                                         
                                      ),
                                    ),
                                    suffixIcon: phoneController.text.length > 9
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 12, 10, 15),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green),
                                              child: const Icon(
                                                Icons.done,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
      
                              textFeld(
                                hintText: "Enter your first name",
                                icon: Icons.person,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: firstnameController
                              ),
                          const SizedBox(height: 20,),
                            
                              textFeld(
                                hintText: "Enter your last name",
                                icon: Icons.person,
                                inputType: TextInputType.emailAddress,
                                maxLines: 1,
                                controller: lastnameController,
                                
                              ),  
                         const SizedBox(height: 20,),

                            SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: dateController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: "Pick your date of birth",
                                     hintStyle: TextStyle(color: Colors.grey.shade700,fontSize: 15,fontWeight: FontWeight.w400),
                                     contentPadding: const EdgeInsets.fromLTRB(12, 12, 10, 15),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    prefixIcon:  Padding(
                                      padding: const  EdgeInsets.fromLTRB(
                                          12, 15, 10, 15),
                                      child: Icon(Icons.person,color: HexColor('#018a3c'),),
                                    ),
                                    suffixIcon:  Padding(
                                      padding: const  EdgeInsets.fromLTRB(
                                          12, 15, 10, 15),
                                      child: Icon(Icons.date_range,color: HexColor('#018a3c'),),
                                    )
                                
                                  ),
                                   onTap: () async {
                              var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                     age = calculateAge(date);
                    });
                    dateController.text = DateFormat('MM/dd/yyyy').format(date);
                  }
                }, 
                 ),
                   ),

                             
                  //   dateController.text.isNotEmpty? const SizedBox(height: 20,) : Container(),
                       
                  //      Visibility(
                  //       visible: dateController.text.isNotEmpty,
                  //       child: 
                  //      Container(
                  //    height: 50, width: double.infinity,
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),border: Border.all(color: Colors.grey)
                  //      ),
                  //    child: Padding(
                  //   padding: const EdgeInsets.all(12),
                  //  child: Row(
                  //    children: [
                  //     Icon(
                  //      Icons.person,
                  //    color: HexColor('#018a3c'),
                  //      size: 22,
                  //        ),
                  //        const SizedBox(width: 15,), 
                  //      Text('You are $age years old!',style: GoogleFonts.poppins(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                  //    ],
                  //  ),
                  //      ),),),

                      const SizedBox(height: 20,),       

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey),
                        ),
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                             Padding(
                              padding: const  EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.person,
                                color: HexColor('#018a3c'),
                                size: 22,
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon:  Padding(
                                  padding: const  EdgeInsets.only(left: 78),
                                  child:  Icon(Icons.arrow_drop_down_rounded, color:HexColor('#018a3c'), size: 50),
                                ),
                                hint: Text(
                                  'Select your gender',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                value: gender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    gender = newValue;
                                  });
                                },
                                items: cities.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        value,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
 

                        const SizedBox(height: 20,),
      
                             
      
                              
      
                      const SizedBox(height: 10,),
                              
      
                              
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child:  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: HexColor('#018a3c')),
                      onPressed:() {
                       Navigator.push(
                           context,
                        MaterialPageRoute(
                           builder: (context) =>  Otp_screen(
      
                         )));
                    }, child: Text('Register',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500) ,)),
                          ),
                        ),

                        SizedBox(height: 10,),
                        
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
    
  }) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextFormField(
        cursorColor: Colors.grey,
        cursorWidth: 2,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 12, 10, 15),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 15),
            child: Icon(
              icon,
              size: 22,
              color: HexColor('#018a3c'),
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey)),
          
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600,fontSize: 16,fontWeight: FontWeight.w400),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  
  
}

















