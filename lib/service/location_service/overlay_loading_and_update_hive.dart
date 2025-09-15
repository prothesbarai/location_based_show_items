import 'package:flutter/material.dart';

class OverlayLoadingAndUpdateHive {
  static bool _isShowing = false;

  static void show(BuildContext context, String text , Color bgColor, Color progressColor, Color textColor) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10),),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: progressColor,),
                    const SizedBox(height: 15),
                    Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: textColor,),),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Hide the overlay
  static void hide(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

}