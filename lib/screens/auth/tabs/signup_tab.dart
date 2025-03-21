import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../custom_ui/dialogs.dart';
import '../../../main.dart';
import '../login_screen.dart';
import '../otp_screen.dart';

class SignUpTab extends StatefulWidget {
  final VoidCallback updateIndex;

  const SignUpTab({Key? key, required this.updateIndex}) : super(key: key);

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final _formKey = GlobalKey<FormState>();
  //to store mobile number entered by user
  String? _mobileNumber;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //welcome to app label
      const Text('Welcome to App',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 24)),

      //enter number label
      Padding(
          padding: EdgeInsets.only(left: 2, top: mq.height * .05),
          child: const Text(
              'Please signup with your phone number to get registered',
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w500))),

      //adding some space
      SizedBox(height: mq.height * .015),

      //mobile number input field
      Form(
        key: _formKey,
        child: TextFormField(
          onSaved: (number) => _mobileNumber = number,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(letterSpacing: 3, fontSize: 18, height: 1.5),
          validator: (val) => validateMobileNo(val.toString()),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              //prefix of text field with flag and country code
              prefixIcon: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    Image.asset('assets/images/india.png',
                        width: mq.width * .08),
                    const Text("  +91 | ",
                        style: TextStyle(fontSize: 18, color: Colors.black54)),
                  ]),
              hintStyle:
                  const TextStyle(fontSize: 18, letterSpacing: 1, height: 1.5),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              hintText: 'Phone Number'),
        ),
      ),

      //continue button for moving to otp screen
      Container(
          width: mq.width,
          padding:
              EdgeInsets.only(top: mq.height * .04, bottom: mq.height * .03),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () => _handleSignUp(),
            style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: Colors.lightGreenAccent,
                onPrimary: Colors.black,
                elevation: 1,
                minimumSize: Size(mq.width * .9, mq.height * .06)),
            child: const Text('Continue',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2)),
          )),

      //or divider
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //horizontal line separator
        SizedBox(
          width: mq.width * .42,
          child: Divider(
              indent: mq.width * .04,
              endIndent: mq.width * .02,
              color: Colors.black),
        ),

        //OR label
        const Text('OR',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),

        //horizontal line separator
        SizedBox(
            width: mq.width * .42,
            child: Divider(
                indent: mq.width * .02,
                endIndent: mq.width * .04,
                color: Colors.black))
      ]),

      //metamask button
      Container(
          width: mq.width,
          padding: EdgeInsets.only(top: mq.height * .03),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: const Color.fromARGB(255, 240, 255, 222),
                  elevation: 1,
                  minimumSize: Size(mq.width * .9, mq.height * .06)),
              icon: Image.asset('assets/images/metamask.png',
                  height: mq.height * .03),
              label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                    TextSpan(text: 'Connect to '),
                    TextSpan(
                        text: 'Metamask',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ])))),

      //google button
      Container(
          width: mq.width,
          padding: EdgeInsets.symmetric(vertical: mq.height * .01),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: const Color.fromARGB(255, 240, 255, 222),
                  elevation: 1,
                  minimumSize: Size(mq.width * .9, mq.height * .06)),
              icon: Image.asset('assets/images/google.png',
                  height: mq.height * .03),
              label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                    TextSpan(text: 'Connect to '),
                    TextSpan(
                        text: 'Google',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ])))),

      //apple button
      Container(
          width: mq.width,
          padding: EdgeInsets.only(bottom: mq.height * .01),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
              onPressed: () => _handleSignUp(),
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: Colors.black,
                  elevation: 1,
                  minimumSize: Size(mq.width * .9, mq.height * .06)),
              icon: Image.asset('assets/images/apple.png',
                  color: Colors.white, height: mq.height * .03),
              label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      children: [
                    TextSpan(text: 'Connect to '),
                    TextSpan(
                        text: 'Apple',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ])))),

      //don't have account label
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Have an account? ",
            style: TextStyle(fontWeight: FontWeight.bold)),
        InkWell(
          onTap: () => widget.updateIndex(),
          child: Text('Signin',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreenAccent.shade700)),
        )
      ])
    ]);
  }

  //handle sign up procedure
  _handleSignUp() async {
    //specific signup codes can be done inside this fun
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).requestFocus(FocusNode());
      progressDialog(context, 'Please Wait...');

      await auth.verifyPhoneNumber(
        phoneNumber: '+91 $_mobileNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          log('Verification Failed: $e');
          Navigator.pop(context);
          showSnackbar(context, 'Something Went Wrong (Check Internet!)');
        },
        codeSent: (String verificationId, int? resendToken) {
          //hide progress dialog
          Navigator.pop(context);
          //on codes sent then navigate to otp screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OTPScreen(
                        verificationId: verificationId,
                        mobileNo: _mobileNumber!,
                      )));
          log('VerificationId: $verificationId -- resendToken: $resendToken');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log('VerificationId: $verificationId');
        },
      );
    }
  }
}
