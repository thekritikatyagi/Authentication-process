//for showing alert dialog for various errors or progress
import 'package:flutter/material.dart';

import '../main.dart';

//for showing snackbar message
showSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blue.withOpacity(.8),
      behavior: SnackBarBehavior.floating));
}

//loading or progress dialog
progressDialog(BuildContext context, String msg) {
  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(.8),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          title: Row(
            children: [
              SizedBox(
                  height: mq.height * .05,
                  child: Image.asset('assets/images/progress.gif')),
              Text('     $msg',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18))
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
        );
      });
}
