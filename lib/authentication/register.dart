import 'package:chilled/authentication/backend/authServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chilled/dialog/dialogGood.dart';
import 'package:chilled/dialog/dialogLoadWait.dart';
import 'package:chilled/resources/color.dart';
import 'package:chilled/resources/string.dart';

import 'dart:io' show Platform;


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  int stackIndex = 0;


  String singleValue = "Text alignment right";
  String verticalGroupValue = "Basic User";

  final status = ["Basic User", "Garbage Collector", "Scrap Dealer"];


  bool isLoading = false;
  bool isSearchThere = false;

  String nameFirstUsed = "user";
  String countryGet = "user";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.white,
      body: ListView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10),
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: backButton())),
          SizedBox(
            height: (MediaQuery.of(context).size.height / 4) - 5,
            width: (MediaQuery.of(context).size.width / 4) - 5,
            child: Padding( padding: const EdgeInsets.all(20),child: Hero(tag: "logo", child: Image.asset("images/logo.png", width: 40,))),
          ),
          const SizedBox(height: 40,),
          inputName(),
          inputEmail(),
          inputNumber(),
          inputPassword(),
          buttonNext(),
          loginUser(),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }

  TextEditingController getEmail = TextEditingController();
  TextEditingController getName = TextEditingController();

  TextEditingController getPassword = TextEditingController();
  TextEditingController getPhoneNumber = TextEditingController();

  String get email => getEmail.text.trim();

  String get password => getPassword.text.trim();
  String get name => getName.text.trim();
  String get phone => getPhoneNumber.text.trim();

  bool _obscured = true;
  final textFieldFocusNode = FocusNode();

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      } // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
      false; // Prevents focus if tap on eye
    });
  }

  Widget backButton() {
    return const Icon(
      CupertinoIcons.arrow_left_square_fill,
      size: 34,
      color: ColorList.primary,
    );
  }

  Widget inputEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              cursorColor: ColorList.primary.withOpacity(.5),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  color: ColorList.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getEmail,

              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.primary.withOpacity(.2),
                hintText: 'Email',
                suffixIcon: const Icon(
                  Icons.email_outlined,
                  size: 24,
                  color: ColorList.primary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                ),
                hintStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget inputName() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              cursorColor: ColorList.primary.withOpacity(.5),
              keyboardType: TextInputType.text,
              style: const TextStyle(
                  color: ColorList.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getName,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.primary.withOpacity(.2),
                hintText: 'Full name',
                suffixIcon: const Icon(
                  Icons.account_circle_outlined,
                  size: 24,
                  color: ColorList.primary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                ),
                hintStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget inputNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              cursorColor: ColorList.primary.withOpacity(.5),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: ColorList.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getPhoneNumber,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.primary.withOpacity(.2),
                hintText: 'Phone Number',
                suffixIcon: const Icon(
                  Icons.phone,
                  size: 24,
                  color: ColorList.primary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                ),
                hintStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              obscureText: _obscured,
              focusNode: textFieldFocusNode,
              keyboardType: TextInputType.text,
              cursorColor: ColorList.primary.withOpacity(.5),
              style: const TextStyle(
                  color: ColorList.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getPassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.primary.withOpacity(.2),
                hintText: 'Password',
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: GestureDetector(
                    onTap: _toggleObscured,
                    child: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 24,
                      color: ColorList.primary,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                ),
                hintStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(
                    color: ColorList.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: ColorList.primary.withOpacity(.0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginUser(){
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text(
              Strings.haveAccount,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: ColorList.primary.withOpacity(.5), fontSize: 14),
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Text(
                Strings.loginNow,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: ColorList.secondary, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buttonNext() {
    return InkWell(
      onTap: () {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Holder()));

        if (email.isNotEmpty && name.isNotEmpty && password.isNotEmpty && phone.isNotEmpty) {
          createUser();
        } else {
          Fluttertoast.showToast(
              msg: "please do not leave any blanks",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorList.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: ColorList.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
  Future<void> createUser() async {
    showAlertDialog(context);

    //check if the email exist


    final message = await AuthService().registration(
        email: getEmail.text,
        password: getPassword.text,
        name: getName.text,
      phone: getPhoneNumber.text,
      role : verticalGroupValue,
    );




    Navigator.of(context, rootNavigator: true).pop();
    var messageNext = message;
    if (message!.contains('Success')) {
      //open her the splashscreen
      takeMessage = 'Success!';
      messageNext = "account was set up successfully";
    } else {
      takeMessage = 'Error!';
    }




    showAlertDialogGood(messageNext!,buttonOk(),takeMessage);
    //then load the user to the database
  }



  showAlertDialog(BuildContext contexts) async {
    showDialog(
      context: contexts,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogLoadWait();
      },

    );
  }

  var takeMessage = '';
  Widget buttonOk() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              Navigator.pop(context);

              if (takeMessage == 'Success!') {
                //open her the splashscreen
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: takeMessage == 'Success!' ? ColorList.green : ColorList.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'ok',
                style: TextStyle(
                  color: ColorList.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showAlertDialogGood(String message, Widget buttonOk,String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogGood(message: message, title: title,buttons: buttonOk,);
      },
    );
  }


}
