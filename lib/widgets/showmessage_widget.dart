import 'package:flutter/material.dart';

showMessage(context, title, message, {Function? callBack}) {
  var alertDialog = AlertDialog(
      title: Text(title),
      content: Container(child: Text(message)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (callBack != null) callBack!();
          },
          child: const Text(
            "Okay",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ]);

  showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      });
}
