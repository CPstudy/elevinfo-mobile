import 'dart:io';
import 'dart:ui';

import 'package:elevinfo/essential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog {
  ProgressDialog(
    this._context
  );

  final BuildContext _context;

  late Dialog dialog;

  bool isShowing = false;

  void show() {

    bool light = true;

    switch(Config().type) {
      case SYSTEM_MODE:
        light = MediaQuery.of(_context).platformBrightness == Brightness.light;
        break;

      case LIGHT_MODE:
        light = true;
        break;

      case DARK_MODE:
        light = false;
        break;
    }

    dialog = Dialog(
      elevation: 0.0,
      backgroundColor: Colors.black.withOpacity(0.01),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Container(
            width: 350,
            height: 70,
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.marginDefault,
            ),
            color: light ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.7),
            child: Row(
              children: [
                CircularProgressIndicator(
                  color: SColors.colorPrimary,
                ),
                SizedBox(
                  width: Dimens.marginDefault,
                ),
                Text(
                  '불러오는 중...',
                  style: TextStyle(
                    color: light ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    showDialog(
      context: _context,
      builder: (_context) => dialog,
      barrierColor: Colors.black.withOpacity(0.01),
      barrierDismissible: false,
    ).then((value) => this.isShowing = true);
  }

  void hide() {
    this.isShowing = false;
    Navigator.pop(_context);
  }
}