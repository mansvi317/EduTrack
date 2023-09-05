import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:Remind/widgets/Palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student.dart';
import 'Stu_side_menu.dart';

class StudentLoginScreen extends StatefulWidget {
  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  final countryController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final customOptionController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final phonenoController = TextEditingController();

  bool isRememberMe = false;
  bool isSignupScreen = true;
  bool hasSignedUp = false;

  static late String name = "";
  static late String phone = "";
  static late String email = "";
  static late String password = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    countryController.text = "+91";
    checkIfUserLoggedIn();
    super.initState();
  }

  @override
  void dispose() {
    customOptionController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    emailController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<bool> checkIfUserLoggedIn() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userType = sharedPreferences.getString('userType');

    return userType != null;
  }



  void signUserIn() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Stu_side_menu()),
      );
    }catch (e) {
      print("Sign-in error: $e");
    }
  }

  void loginUser() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Stu_side_menu()),
      );
    } catch (e) {
      print("Login error: $e");
    }
  }

  void storeData() async {
    await firestoreDB.collection("Users").add({
      "Name": name,
      "Phone": phone,
      "Email": email,
      "Password": password,
    });
  }


  Future<bool> checkIfPhoneNumberIsRegistered(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      // If the phone number exists in the system, the verification process will start
      // If the phone number does not exist, the verificationFailed callback will be triggered

      // Return true if verification process started, indicating the phone number is registered
      return true;
    } catch (e) {
      // Handle any errors that occur during the verification process
      print('Error verifying phone number: $e');
      return false;
    }
  }



  void showPhonePopup() async {
    TextEditingController otpController = TextEditingController();
    bool showOTPField = false;
    String verificationId = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 10),
                  Text('Verification'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                onChanged: (value) {
                                  setState(() {
                                    phone = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (showOTPField)
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter OTP',
                      ),
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    String phoneNumber = '${countryController.text}${phoneController.text}';

                    if (showOTPField) {
                      // Get the entered OTP
                      String enteredOTP = otpController.text;

                      // Create a PhoneAuthCredential using the verification ID and entered OTP
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: enteredOTP,
                      );

                      try {
                        // Disable reCAPTCHA verification
                        await Firebase.initializeApp(
                          name: 'no-recaptcha',
                          options: FirebaseOptions(
                            appId: 'com.example.brainbites', // Replace with your app package name
                            apiKey:  'AIzaSyCUw4bnF5gi-RAZ0FirLC4FSvD4Flzyte4',
                            projectId: 'brainbites-bfd47',
                            messagingSenderId: '930014640356',
                          ),
                        );
                        // Sign in with the phone auth credential
                        await FirebaseAuth.instance.signInWithCredential(credential);
                        // Navigate to the home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Stu_side_menu()),
                        );
                      } catch (e) {
                        // Show an error message if the verification fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid OTP. Please try again.'),
                          ),
                        );
                      }
                    } else {
                      // Check if the phone number is signed up
                      try {
                        bool isPhoneNumberRegistered = await checkIfPhoneNumberIsRegistered(phoneNumber);

                        if (isPhoneNumberRegistered) {
                          // Phone number is signed up, proceed with verification
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNumber,
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String _verificationId, int? resendToken) {
                              verificationId = _verificationId;
                              setState(() {
                                showOTPField = true;
                              });
                            },
                            codeAutoRetrievalTimeout: (String _verificationId) {},
                          );
                        } else {
                          // Phone number is not signed up, show a snackbar to inform the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please sign up with this phone number.'),
                            ),
                          );
                        }
                      } catch (e) {
                        // Error occurred while checking sign-in methods
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred. Please try again later.'),
                          ),
                        );
                      }
                    }
                  },

                  child: Text(showOTPField ? 'Submit' : 'Verify'),
                ),
              ],
            );
          },
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bgColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 900,
              decoration: BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage("assets/images/bg5.jpg"),
                  fit: BoxFit.fill,
                  opacity: 0.5,
                ),*/
              ),
              child: Container(
                padding: EdgeInsets.only(top: 45, left: 20),
                //color: Color(0xFF3b5999).withOpacity(.67),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Welcome ",
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 2,
                            color: Colors.deepPurple,
                            //color: Color(0xFF191970),
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? " Hi there!," : " Back,",
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                                color: Palette.facebookColor,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Signin to Continue",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          //buildBottomHalfContainer(true),

          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
            top: isSignupScreen ? 165 : 220,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
              height: isSignupScreen ? 450 : 300,
              padding: EdgeInsets.all(15),
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 5
                    ),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 2),
                                  height: 3,
                                  width: 70,
                                  color: Palette.googleColor,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  height: 3,
                                  width: 70,
                                  color: Palette.googleColor,
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection(),
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the submit button
          // buildBottomHalfContainer(false),
          // Bottom buttons
          Positioned(
            top: MediaQuery
                .of(context)
                .size
                .height - 125,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Palette.facebookColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Palette.facebookColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Palette.facebookColor,
                      ),
                    ),
                  ],
                ),


                //Text(isSignupScreen ? "Or Signup with" : "Or Signin with"),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /*InkWell(
                            onTap: () {
                              // Handle Google image button press
                            },
                            child: Image.asset('assets/images/google4.png', height: 52),
                          ),*/
                          //const SizedBox(width: 2),
                          InkWell(
                            onTap: showPhonePopup, // Show phone number pop-up
                            child: Image.asset('assets/images/phone.png',
                                height: 52),
                          ),
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }




  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating, // Set behavior to floating
      margin: EdgeInsets.all(25),
    ));
  }


  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String enteredEmail = emailController.text;
      bool hasSignedUp = await checkIfEmailIsSignedUp(enteredEmail);

      if (hasSignedUp) {
        final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        sharedPreferences.setString('userType', 'student'); // Set user type as 'student'

        Navigator.pushReplacementNamed(context, '/studentHome');
      } else {
        showSnackbar("Email not found. Please sign up.");
      }
    } else {
      showSnackbar("Please fill in all the fields.");
    }
  }


  @override
  Widget buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                labelText: "Email",
                labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                hintStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined, color: Colors.white),
                labelText: "Password",
                labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                hintStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isRememberMe,
                      activeColor: Palette.textColor2,
                      onChanged: (value) {
                        setState(() {
                          isRememberMe = !isRememberMe;
                        });
                      },
                    ),
                    Text("Remember me",
                        style: TextStyle(fontSize: 12, color: Palette.textColor1)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Handle Forgot Password here
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 12, color: Palette.textColor1),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 200,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Palette.facebookColor,
                      Palette.bgColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    String enteredEmail = emailController.text;
                    bool hasSignedUp = await checkIfEmailIsSignedUp(enteredEmail);

                    if (hasSignedUp) {
                      final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                      sharedPreferences.setString('userType', 'student'); // Set user type as 'student'

                      Navigator.pushReplacementNamed(context, '/studentHome');
                    } else {
                      showSnackbar("Please sign up first");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    primary: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),



              ),
            ),

          ],
        ),
      ),
    );
  }



  Future<bool> checkIfEmailIsSignedUp(String email) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.isNotEmpty;
  }



  Container buildSignupSection() {
    void showSnackBar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // Set behavior to floating
          margin: EdgeInsets.all(25), // Adjust margin to desired value
        ),
      );
  }

    void SisubmitForm() async {
      String username = usernameController.text.trim();
      String phone = phonenoController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (username.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
        showSnackBar(context, "Please fill in all fields");
        return;
      }

      try {
        // Create the user using email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the user ID
        String userId = userCredential.user!.uid;

        // Add to Student.dart table
        Student student = Student(
          id: userId,
          name: username,
          phone: phone,
          email: email,
          password: password,
        );
        student.save();

        // Add to Firebase database collection "Users"
        firestoreDB.collection("Users").doc(userId).set({
          "name": username,
          "phone": phone,
          "email": email,
          "password": password,
        });

        Navigator.pushReplacementNamed(context, '/studentHome');
      } catch (e) {
        showSnackBar(context, "Error: ${e.toString()}");
      }
    }



    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: usernameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.perm_identity, color: Colors.white),
              labelText: "Name",
              labelStyle: TextStyle(fontSize: 16, color: Colors.white),
              // Set label text color to white
              hintStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    color: Colors.white), // Set border color to white
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: phonenoController,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              phone = value;
            },
            style: TextStyle(color: Colors.white),
            // Set input text color to white
            decoration: InputDecoration(
              prefixText: "+91 ",
              prefixStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              prefixIcon: Icon(Icons.phone, color: Colors.white),
              labelText: "Phone Number",
              labelStyle: TextStyle(fontSize: 16, color: Colors.white),
              // Set label text color to white
              hintStyle: TextStyle(fontSize: 14, color: Colors.white),
              // Set hint text color to white
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Colors.white), // Set border color to white
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
            ),
          ),

          SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
              labelText: "Email",
              labelStyle: TextStyle(fontSize: 16, color: Colors.white),
              // Set label text color to white
              hintStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Colors.white), // Set border color to white
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outlined, color: Colors.white),
              labelText: "Password",
              labelStyle: TextStyle(fontSize: 16, color: Colors.white),
              // Set label text color to white
              hintStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Colors.white), // Set border color to white
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
            ),
          ),

          Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 200,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Palette.facebookColor,
                        Palette.bgColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: SisubmitForm, // Call the submitForm function
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      primary: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By pressing 'Submit' you agree to our ",
                    style: TextStyle(color: Palette.textColor2),
                    children: [
                      TextSpan(
                        text: "terms & conditions",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  TextButton buildTextButton(IconData icon, String title,
      Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }


  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }


}













/*SizedBox(height: 10),

    DropdownButtonFormField(
    decoration: InputDecoration(
    prefixIcon: Icon(Icons.library_books),
    labelText: "Education Qualification",
    labelStyle: TextStyle(fontSize: 16),
    hintStyle: TextStyle(fontSize: 14),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    ),
      value: selectedOption,
      items: [
        DropdownMenuItem(
          child: Text("10 pass"),
          value: "A",
        ),
        DropdownMenuItem(
          child: Text("12 pass"),
          value: "B",
        ),
        DropdownMenuItem(
          child: Text("Undergraduate"),
          value: "C",
        ),
        DropdownMenuItem(
          child: Text("Post Graduate"),
          value: "D",
        ),
        DropdownMenuItem(
          child: Text("PHD"),
          value: "E",
        ),
        DropdownMenuItem(
          child: Text("Other"),
          value: "Other",
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedOption = value as String;
          showCustomOption = selectedOption == "Other";
          if (!showCustomOption) {
            customOptionController.text = '';
          }
        });
      },
    ),
          if (showCustomOption)
            TextField(
              controller: customOptionController,
              decoration: InputDecoration(labelText: "Enter your qualification"),
              onSubmitted: (value) {
                setState(() {
                  selectedOption = value;
                  showCustomOption = false;
                  customOptionController.text = '';
                });
              },
            ),

*/






/*
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Palette.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Colors.transparent
                                    : Palette.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child:
                          Icon(Icons.person,
                          color: isMale ? Colors.white : Palette.iconColor,
                        ),
                      ),

                      Text(
                        "Male",
                        style: TextStyle(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Colors.transparent
                                : Palette.textColor2,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Palette.textColor1
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child:
                        Icon(Icons.person,
                          color: isMale ? Palette.iconColor : Colors.white,
                        ),
                      ),
                      Text(
                        "Female",
                        style: TextStyle(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

 */
