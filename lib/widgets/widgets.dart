import 'package:chat_app/views/search_screen.dart';
import 'package:flutter/material.dart';

AppBar appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      'assets/images/preview.png',
      height: 50,
    ),
    backgroundColor: Color.fromARGB(255, 168, 5, 200),
  );
}

AppBar appBarHome(BuildContext context) {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    title: const Text(
      "Groups",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26),
    ),
    actions: <Widget>[
      IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          nextScreen(context, searchScreen());
        },
      )
    ],
    backgroundColor: Color.fromARGB(255, 168, 5, 200),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpletextstyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

TextStyle mediumtextstyle() {
  return TextStyle(color: Colors.white, fontSize: 20);
}

void nextScreen(context, Page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Page));
}

void nextScreenReplace(context, Page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}
