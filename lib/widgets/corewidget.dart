import 'dart:io';

import 'package:elevinfo/essential.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter/services.dart';

class CoreButton extends StatelessWidget {

  CoreButton({
    this.child,
    this.width: Dimens.titleBarHeight,
    this.height: Dimens.titleBarHeight,
    this.padding,
    this.color,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;

  final double width;

  final double height;

  final EdgeInsets padding;

  final Color color;

  final GestureTapCallback onTap;

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (color == null) ? Theme.of(context).primaryColor : color,
        borderRadius: (borderRadius == null) ? BorderRadius.circular(4) : borderRadius,
      ),
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.black12,
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  }
}

class TitleButton extends StatefulWidget {

  Widget child;
  double width;
  double height;
  EdgeInsets padding;
  GestureTapCallback onTap;

  TitleButton({
    this.child,
    this.width: Dimens.titleBarHeight,
    this.height: Dimens.titleBarHeight,
    this.padding,
    this.onTap,
  });

  @override
  _TitleButtonState createState() => _TitleButtonState();
}

class _TitleButtonState extends State<TitleButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.black12,
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(4),
          onTap: (widget.onTap != null) ? widget.onTap : (){
            Navigator.pop(context);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class TitleScaffold extends StatefulWidget {

  Widget body;
  Widget titleLeftChild;
  Widget titleRightChild;
  String title;
  bool backButton;
  bool visibilityTitle = true;
  bool titleBar;
  bool backSwipe;
  Color backgroundColor;
  ScrollController scrollController;

  TitleScaffold({
    this.body,
    this.title: '',
    this.backButton: true,
    this.titleLeftChild,
    this.titleRightChild,
    this.titleBar: true,
    this.backSwipe: true,
    this.backgroundColor,
    this.scrollController,
  }) {
    if(title == null || title == '') {
      visibilityTitle = false;
    }
  }

  @override
  _TitleScaffoldState createState() => _TitleScaffoldState();
}

class _TitleScaffoldState extends State<TitleScaffold> {

  Widget titleBar() {

    List<Widget> leftWidgets = List();
    List<Widget> rightWidgets = List();

    leftWidgets.add(
        Visibility(
          visible: widget.backButton,
          child: TitleButton(
            padding: EdgeInsets.only(left: 8, right: 2, top: 8, bottom: 8),
            width: Dimens.titleBarHeight - 16,
            height: Dimens.titleBarHeight - 16,
            child: Icon(
              (Platform.isIOS) ? Icons.arrow_back_ios : Icons.arrow_back,
              size: 24,
              color: Colors.white,
            ),
          ),
        )
    );

    if(widget.titleLeftChild != null) {
      leftWidgets.add(widget.titleLeftChild);
    }

    if(widget.titleRightChild != null) {
      rightWidgets.add(widget.titleRightChild);
    }

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            print('pressed');
            if(widget.scrollController != null) {
              widget.scrollController.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).padding.top,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: Dimens.titleBarHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: leftWidgets,
            ),
            Visibility(
              visible: widget.visibilityTitle,
              child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: FONT_FAMILY,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.black38,
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: FONT_FAMILY,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: rightWidgets,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SwipeDetector(
          onSwipeRight: (){
            if(widget.backSwipe) {
              Navigator.pop(context);
            }
          },
          swipeConfiguration: SwipeConfiguration(
            horizontalSwipeMaxHeightThreshold: 50.0,
            horizontalSwipeMinDisplacement:20.0,
          ),
          child: Container(
            height: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Visibility(
                      visible: widget.titleBar,
                      child: titleBar(),
                    ),
                    Expanded(
                      child: Container(
                        child: widget.body,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}