import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../custom_ui/dialogs.dart';
import '../../main.dart';

//this is the otp screen where user can validate otp
class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String mobileNo;

  const OTPScreen(
      {Key? key, required this.verificationId, required this.mobileNo})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _resendOtp = false, _showDoneBtn = false;
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //for hiding keyboard when a tap is detected on screen
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          //back leading button in app bar
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black)),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //adding some space
              SizedBox(height: mq.height * .03),

              //enter otp label
              const Text('Enter OTP',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 24)),

              //otp instruction label
              Padding(
                  padding: EdgeInsets.only(left: 2, top: mq.height * .02),
                  child: Text(
                      'An six digit code has been sent to +91 ${widget.mobileNo}',
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500))),

              //adding some space
              SizedBox(height: mq.height * .015),

              //change number option

              Padding(
                  padding: EdgeInsets.only(
                      left: 2, top: mq.height * .01, bottom: mq.height * .1),
                  child: Row(
                    children: [
                      //incorrect number label
                      Text(_showDoneBtn ? '' : 'Incorrect Number?',
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),
                      if (!_showDoneBtn)
                        InkWell(
                            onTap: () {
                              //move back to login screen
                              Navigator.pop(context);
                            },
                            child: Text(' Change ',
                                style: TextStyle(
                                    color: Colors.lightGreenAccent.shade700,
                                    fontWeight: FontWeight.w500))),
                    ],
                  )),

              //otp input field
              SizedBox(
                width: mq.width * .9,
                child: PinFieldAutoFill(
                  autoFocus: true,
                  decoration: const UnderlineDecoration(
                      colorBuilder: FixedColorBuilder(Colors.black54)),
                  currentCode: _otp,
                  onCodeSubmitted: (pin) {
                    log(pin);
                  },
                  onCodeChanged: (pin) {
                    if (pin != null) {
                      _otp = pin;
                      if (_otp.length == 6) {
                        setState(() => _showDoneBtn = true);
                        log('done button: $_showDoneBtn');
                      }
                    }
                    log('Pin Changed: $_otp');
                  },
                ),
              ),

              //resend otp button
              Container(
                  width: mq.width,
                  padding: EdgeInsets.only(
                      top: mq.height * .04, bottom: mq.height * .03),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _showDoneBtn
                        ? () {
                            //submit otp codes
                            _signingWithOTP(
                                context, _otp, widget.verificationId);
                          }
                        : _resendOtp
                            ? () {
                                //resend otp code
                                _resendOTP();
                              }
                            : null,
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: Colors.lightGreenAccent,
                        onPrimary: Colors.black,
                        elevation: 1,
                        minimumSize: Size(mq.width * .9, mq.height * .06)),
                    child: Text(_showDoneBtn ? 'Done' : 'Resend OTP',
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2)),
                  )),

              //show resend otp counter
              if (!_resendOtp && !_showDoneBtn)
                Container(
                  padding: EdgeInsets.symmetric(vertical: mq.height * .02),
                  width: mq.width * .85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //resend otp label
                      const Text('Resend OTP in ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87)),

                      //counter
                      SlideCountdown(
                          padding: EdgeInsets.zero,
                          decoration: const BoxDecoration(),
                          textStyle: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                          onDone: () {
                            setState(() => _resendOtp = true);
                          },
                          duration: const Duration(seconds: 30)),

                      //seconds label
                      const Text('s',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87)),
                    ],
                  ),
                ),

              //resend code label (when done button is shown)
              if (_showDoneBtn)
                SizedBox(
                  width: mq.width,
                  child: Column(
                    children: [
                      //don't receive code label
                      const Text("Don't you receive any code?",
                          style: TextStyle(color: Colors.black87)),
                      const SizedBox(height: 8),

                      //resend code label
                      InkWell(
                        onTap: () {
                          _resendOTP();
                        },
                        child: Text('Re-send Code',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.lightGreenAccent.shade700)),
                      )
                    ],
                  ),
                ),
            ]),
          )),
    );
  }

  //resend otp request to firebase
  _resendOTP() async {
    setState(() => _otp = '');
    progressDialog(context, 'Resending OTP...');

    await auth.verifyPhoneNumber(
      phoneNumber: '+91 ${widget.mobileNo}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        log('Verification Failed: $e');
        Navigator.pop(context);
        showSnackbar(context, 'Something Went Wrong (Check Internet!)');
      },
      codeSent: (String verificationId, int? resendToken) {
        //hide progress dialog
        Navigator.pop(context);
        log('VerificationId: $verificationId -- resendToken: $resendToken');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('VerificationId: $verificationId');
      },
    );
  }

  //login or sign in with otp entered by user
  //(if it's valid then navigate accordingly)
  _signingWithOTP(
      BuildContext context, String otp, String verificationId) async {
    try {
      progressDialog(context, 'Verifying...');
      var credentials = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credentials).then((value) {
        log('Credentials: $credentials');
        log('Credentials Token: ${credentials.token}');
        Navigator.pop(context);

        //user successfully registered
        showSnackbar(context,
            'Successfully Logged In!!\nNew User: ${value.additionalUserInfo!.isNewUser}');
      });
    } catch (e) {
      Navigator.pop(context);
      showSnackbar(context, 'Invalid OTP!');
    }
  }
}
