import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastState {
  error,
  warning,
  success;

  Color toColour() {
    switch (this) {
      case ToastState.error:
        return Colors.red;
      case ToastState.warning:
        return Colors.yellow;
      case ToastState.success:
        return Colors.green;
    }
  }
}

class ToastService {
  static void showToast(String message, ToastState state) async {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: state.toColour(),
        textColor: state == ToastState.warning ? Colors.black : Colors.white,
        fontSize: 16.0);
  }
}
