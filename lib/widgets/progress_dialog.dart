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
    dialog = Dialog(
      child: Container(
        width: 200,
        height: 200,
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'aaa',
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: _context,
      builder: (_context) => dialog,
    ).then((value) => this.isShowing = true);
  }
}