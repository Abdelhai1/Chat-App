import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/views/home.dart';
import 'package:chat_app/views/sing_up.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helper/helper_functions.dart';

class singIn extends StatefulWidget {
  const singIn({super.key});

  @override
  State<singIn> createState() => _singInState();
}

class _singInState extends State<singIn> {
  String email = "";
  String password = "";
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 50,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextField(
                          decoration: textFieldInputDecoration("email"),
                          style: simpletextstyle(),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        TextField(
                          obscureText: true,
                          decoration: textFieldInputDecoration("password"),
                          style: simpletextstyle(),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "forgot password?",
                              style: simpletextstyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            login();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color.fromARGB(255, 218, 57, 247),
                                Color.fromARGB(255, 218, 106, 193)
                              ]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Sign in",
                              style: mediumtextstyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign in with Google",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have account ? ",
                              style: mediumtextstyle(),
                            ),
                            Text.rich(
                              TextSpan(
                                  text: "Register now",
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      fontSize: 20),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const signUp());
                                    }),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 250,
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          //saving the value to our shared perferences
          await HelperFunctions.saveUserLoggedinStatus(true);
          await HelperFunctions.saveUserEmailsf(email);
          await HelperFunctions.saveUserNamesf(snapshot.docs[0]['fullname']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
