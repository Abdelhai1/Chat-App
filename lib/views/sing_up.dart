import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/home.dart';
import 'package:chat_app/views/sing_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  TextEditingController userNameTextEdittingController =
      new TextEditingController();
  TextEditingController emailTextEdittingController =
      new TextEditingController();
  TextEditingController passwordTextEdittingController =
      new TextEditingController();
  bool _isLoading = false;
  AuthService authService = AuthService();
  final formkey = GlobalKey<FormState>();
  String email = "";
  String passwoed = "";
  String fullname = "";
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
                          controller: userNameTextEdittingController,
                          decoration: textFieldInputDecoration("user name"),
                          style: simpletextstyle(),
                          onChanged: (value) {
                            setState(() {
                              fullname = value;
                            });
                          },
                        ),
                        TextField(
                          controller: emailTextEdittingController,
                          decoration: textFieldInputDecoration("email"),
                          style: simpletextstyle(),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        TextField(
                          controller: passwordTextEdittingController,
                          decoration: textFieldInputDecoration("password"),
                          style: simpletextstyle(),
                          onChanged: (value) {
                            setState(() {
                              passwoed = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            register();
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
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Sign up",
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
                              "Already have an account ? ",
                              style: mediumtextstyle(),
                            ),
                            Text.rich(
                              TextSpan(
                                  text: "Login now",
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      fontSize: 20),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const singIn());
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
    ;
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullname, email, passwoed)
          .then((value) async {
        if (value == true) {
          //saving the shared refrences state
          await HelperFunctions.saveUserLoggedinStatus(true);
          await HelperFunctions.saveUserEmailsf(email);
          await HelperFunctions.saveUserNamesf(fullname);
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
