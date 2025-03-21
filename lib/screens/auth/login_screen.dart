import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'tabs/signin_tab.dart';
import 'tabs/signup_tab.dart';

//this is the login screen (with tab selection for sign-in and sign-up)
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        //for hiding keyboard when a tap is detected on screen
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //adding some space
                  SizedBox(height: mq.height * .05),

                  // sliding segments for signin and signup
                  CustomSlidingSegmentedControl<int>(
                      initialValue: _index,
                      children: const {0: Text('Signin'), 1: Text('Signup')},
                      padding: 25,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30)),
                      thumbDecoration: BoxDecoration(
                          color: Colors.lightGreenAccent,
                          borderRadius: BorderRadius.circular(30)),
                      onValueChanged: (i) => setState(() => _index = i)),

                  //adding some space
                  SizedBox(height: mq.height * .08),

                  //for showing screens according to sliding segment (with persistent widgets)
                  IndexedStack(
                    index: _index,
                    children: [
                      SignInTab(updateIndex: () => setState(() => _index = 1)),
                      SignUpTab(updateIndex: () => setState(() => _index = 0))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//function to validate mobile number of user
String? validateMobileNo(String value) {
  if (value.isNotEmpty) {
    if (RegExp(r'^[0-9]*$').hasMatch(value) && value.length == 10) {
      return null;
    } else {
      return 'Invalid Mobile No.';
    }
  } else {
    return 'Mobile No. Required';
  }
}
