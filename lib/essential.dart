import 'package:flutter/material.dart';
export 'package:flutter/material.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:outline_material_icons/outline_material_icons.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:progress_dialog/progress_dialog.dart';
export 'dart:convert';
export 'constants.dart';
export 'dto/elevator.dart';
export 'managers/config.dart';
export 'values/colors.dart';
export 'values/dimens.dart';
export 'widgets/corewidget.dart';

class NeuNavigator {
  static push(BuildContext context, Widget pushPage) {
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 650),
      pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) {
        return pushPage;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
        return FadeTransition(
          opacity: Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child, // child is the value returned by pageBuilder
        );
      },
    ));
  }

  static pushReplacement(BuildContext context, Widget pushPage) {
    Navigator.pushReplacement(context, PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 650),
      pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) {
        return pushPage;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
        return FadeTransition(
          opacity: Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child, // child is the value returned by pageBuilder
        );
      },
    ));
  }
}