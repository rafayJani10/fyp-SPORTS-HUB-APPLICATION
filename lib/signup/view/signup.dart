import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/UIcomponents/color_utils.dart';
import 'package:fyp/login/view/LoginScreen.dart';
// import 'package:fyp/signup/view/signup.dart';
// import 'package:fyp/signup/view/signup.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../UIcomponents/UIcomponents.dart';
import '../../databaseManager/databaseManager.dart';
import '../../services/NotificationServices.dart';
import '../../useable.dart';



enum userselect {Student , Organiser}
class SignUp extends StatefulWidget {
  const SignUp({super.key, required String title});


@override
State<SignUp> createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {

  bool validateEmail(String email) {

    final pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  var dbmanager = DatabaseManager();
  var networkServices = NotificationServices();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController EnrollmentIdController = TextEditingController();
  TextEditingController DeptController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  userselect? userRole = userselect.Student;
  var userStatus = false;
  Timer? timer;

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringColor("06424c"),
              hexStringColor("104f56"),
              hexStringColor("19676b"),
              hexStringColor("19676b"),
              //  hexStringColor("69EFF8")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  width: double.infinity,
                  //color: Colors.orange,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const RotatedBox(
                            quarterTurns: 3,
                            child: Text("Sign Up",
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            children: const [
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text("We can start",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),),
                              Text("Something   ",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),),
                              Text("New             ",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),),
                            ],
                          ),
                        ],
                      )
                    )
                  )
                ),

                reusableTextField("Full Name", Icons.person_outline, false,
                    fullnameController),
                reusableTextField("Enrollment No", Icons.badge_outlined, false,
                    EnrollmentIdController),
                reusableTextField("Dept Name", Icons.add_business_outlined, false,
                    DeptController),
                reusableTextField(
                    "Email", Icons.email_outlined, false, EmailController),
                reusableTextField(
                    "Password", Icons.lock_outline, true, PasswordController),
                reusableTextField(
                    "Confirm Password", Icons.lock_outline, true, ConfirmPasswordController),
                SizedBox(height: 20,),

                signInSignUpButton(context, false, () async{
                  var check_email_verify = validateEmail(EmailController.text);
                  var deviceToken = await networkServices.getDeviceToken();
                  print(deviceToken);
                  dbmanager.SignupWithEmailPassword(EmailController.text, PasswordController.text);
                  if(fullnameController.text == "" || EnrollmentIdController.text == "" || DeptController.text == "" || DeptController.text  == "" || EmailController.text == "" || PasswordController.text == ""){
                    showAlertDialog(context,"Error","incomplete info");
                  }
                  else{
                    if(check_email_verify == false){
                      showAlertDialog(context,"Error","Incorrect email");
                    }else if(PasswordController.text.length <= 8) {
                      showAlertDialog(context,"Error","Password should be at least 8 character long");
                    }
                    else{
                      showAlertDialog(context,"Verification","verification email has been sent");
                      setState(() {
                        if (userStatus == false){
                          timer = Timer.periodic(
                            Duration(seconds: 100),
                                (_) async {
                              var isVerified = await dbmanager.checkEmailVerified();
                              if(isVerified! == "f"){
                                print("email not verified");
                                showAlertDialog(context,"Not verified","Email not verified");
                              }else{
                                print("Email verified successfully :::::::::::::::::::::::::::::::::");
                                userStatus = true;
                                dbmanager.userid;
                                dbmanager.createUserData(fullnameController.text, EmailController.text, PasswordController.text, ConfirmPasswordController.text, EnrollmentIdController.text, DeptController.text, deviceToken!);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
                                timer!.cancel();
                              }
                            },
                          );
                        }else{
                          print('suceesfully added darat:::::::::::');
                        }
                      });
                    }
                  }

                }),

                Padding(
                  padding: EdgeInsets.only(bottom: 10,left: 10),
                  child: Row(
                    children: [
                      Text("    have we met before",
                        style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            color: Colors.white54,
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);

                        },
                        child: Text("  SignIn ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                      )
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


//         child: Scaffold(
//        //   backgroundColor: Color(0xFF163ABB),
//           body: ListView(
//             children: [
//               Container(
//                 decoration: BoxDecoration(gradient: LinearGradient(colors: [
//                   hexStringColor("163ABB"),
//                   hexStringColor("061A62")
//             //  hexStringColor("69EFF8")
//
//             ]),),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height / 5,
//                 // child: Image.asset('lib/images/facebook.png'),
//               ),),
//               //Expanded(
//               Container(
// //                    height: 200,
//                 width: double.infinity,
//                 decoration:   BoxDecoration(
//                   gradient: LinearGradient(colors: [
//                     hexStringColor("163ABB"),
//                     hexStringColor("061A62")
//                     //  hexStringColor("69EFF8")
//
//                   ]
//
//
//                   ),
//                   // borderRadius: const BorderRadius.only(
//                   //   topLeft: Radius.circular(30),
//                   //   topRight: Radius.circular(30),
//                   // ),
//
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Text(
//                         //   'Full Name',
//                         //   style: TextStyle(
//                         //     color: Colors.black,
//                         //     fontSize: 20,
//                         //     fontWeight: FontWeight.bold,
//                         //   ),
//                         // ),
//                         const SizedBox(height: 10),
//
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//
//                           child: TextField(
//                             controller: fullnameController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.perm_identity_rounded,
//                                 color: Colors.white,
//                               ),
//
//                               hintText: 'Full Name',
//                               hintStyle: TextStyle(color: Colors.white),
//                               //   validator: (String? value) {
//
//                               // }
//                             ),
//                           ),
//                         ),
//
//                         //<----------------------->//
//                         // SizedBox(height: 15),
//                         // const Text(
//                         //   'Password',
//                         //   style: TextStyle(
//                         //     color: Colors.black,
//                         //     fontSize: 20,
//                         //     fontWeight: FontWeight.bold,
//                         //
//                         //   ),
//                         // ),
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: EnrollmentIdController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.badge_outlined,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Enrollment Id',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         //<--------------------->//
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: EmailController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.email_outlined,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Email',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: PasswordController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.lock,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Password',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: ConfirmPasswordController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.lock_clock,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Confirm Password',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//               ),
//            //   const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(gradient: LinearGradient(colors: [
//                   hexStringColor("163ABB"),
//                   hexStringColor("061A62")
//                   //  hexStringColor("69EFF8")
//
//                 ]),),
//               child: GestureDetector(
//
//
//                 onTap: () {
//                   // String email = emailController.text;
//                   // String pass = passwordController.text;
//                   Navigator.push(context,
//                       MaterialPageRoute(
//
//                           builder: (context) => const MyHomePage(title: '',)));
//                 },
//                 child: Container(
//
//                   margin: const EdgeInsets.only(left: 10, top: 30, right: 10, bottom: 5),
//
//                   decoration: BoxDecoration(
//
//
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.black,
//                   ),
//                   child: const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: Text(
//                         ' Sign Up',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//
//                     ),
//                   ),
//                 ),
//               ),),
//            Container(
//            decoration: BoxDecoration(gradient: LinearGradient(colors: [
//     hexStringColor("163ABB"),
//     hexStringColor("061A62")
//     //  hexStringColor("69EFF8")
//
//     ]),),
//                child: const SizedBox(
//
//                  height:200),
//
//            ),
//             ],
//           )
//     ));
//   }
// //
//

// Container(
// width: 150,
// height: 45,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(30.0),
// color: Colors.white70.withOpacity(0.3),
// ),
// child: Center(
// child: ListTile(
// title:  Text('Student',
// style: TextStyle(color: Colors.white,
// fontSize: 15,
// fontWeight: FontWeight.normal
// ),
//
//
// ),
// leading: Radio<userselect>(
// fillColor: MaterialStateColor.resolveWith((states) => Colors.white70),
// value: userselect.Student,
// groupValue: user,
// onChanged: (userselect? value) {
// setState(() {
// user = value;
// print(value);
// });
// },
// ),
// ),
// )
// ),
// SizedBox(
// width: 5,
// ),
// Container(
// width: 150,
// height: 45,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(30.0),
// color: Colors.white70.withOpacity(0.3),
// ),
// child: ListTile(
// title: const Text('Organiser',
// style: TextStyle(color: Colors.white,
// fontSize: 16,
// ),
// ),
// leading: Radio<userselect>(
// fillColor: MaterialStateColor.resolveWith((states) => Colors.white70),
// value: userselect.Organiser,
// groupValue: user,
// onChanged: (userselect? value) {
// setState(() {
// user = value;
// print(value);
// });
// },
// ),
// )
// ),