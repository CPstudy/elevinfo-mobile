import 'dart:async';
import 'dart:io';

import 'package:elevinfo/essential.dart';
import 'package:elevinfo/managers/data.dart';
import 'package:elevinfo/managers/databasehelper.dart';
import 'package:elevinfo/providers/elevprovider.dart';
import 'package:elevinfo/screens/history_page.dart';
import 'package:elevinfo/screens/result.dart';
import 'package:elevinfo/screens/search.dart';
import 'package:elevinfo/screens/setting.dart';
import 'package:elevinfo/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> offsetAnimation;
  List<String> numbers = List();
  String number = '승강기 번호';
  bool _visible = false;
  Timer timer;
  bool pressed = false;

  @override
  void initState() {
    super.initState();
    final double offsetX = 5.0;

    animationController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    offsetAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: offsetX), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: offsetX, end: 0.0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: -offsetX), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: -offsetX, end: 0.0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: offsetX), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: offsetX, end: 0.0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: -offsetX), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: -offsetX, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: animationController, curve: Curves.linear))
    ..addListener(() {
      setState(() {

      });
    })
    ..addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        animationController.reset();
      }
    });

    getInitNumber();
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future getInitNumber() async {
    setState(() {
      Config().getTheme();
      numbers = Config().getElevatorNo();
      if(numbers != null) {
        number = makeNumber();
      }
    });
  }

  void showMessage() {
    setState(() {
      _visible = true;
    });

    Future.delayed(Duration(seconds: 3), (){
      setState(() {
        _visible = false;
      });
    });
  }

  String makeNumber() {
    if(numbers.length == 0) {
      return '승강기 번호';
    }

    StringBuffer sb = StringBuffer();

    for(int i = 0; i < numbers.length; i++) {
      if(i < 4) {
        sb.write(numbers[i]);
      } else if(i == 4) {
        sb.write('-');
        sb.write(numbers[i]);
      } else {
        sb.write(numbers[i]);
      }
    }

    return sb.toString();
  }

  List<String> makeList(String s) {
    if(s.length != 7) return null;

    List<String> list = List();

    for(int i = 0; i < s.length; i++) {
      list.add(s.substring(i, i + 1));
    }

    return list;

  }

  void _startCamera() async {
    const String _channel = 'CameraActivity';
    const platform = const MethodChannel(_channel);

    try {

      String st = await platform.invokeMethod('startCameraActivity', {'token' : 'my token'});

      if(st.contains('m.elevator.go.kr')) {
        String s = st.substring(st.length - 7, st.length);

        setState(() {
          numbers = makeList(s);
          number = makeNumber();
        });

        searchElevator(qr: true);

      } else {
        showMessage();
      }

    } on PlatformException catch (e) {
      print('FAIL');
      print(e.message);
    }
  }

  Future searchElevator({bool qr = false}) async {
    ProgressDialog pd = ProgressDialog(context);
    pd.style(
      message: '불러오는 중...',
      borderRadius: 10.0,
      backgroundColor: Theme.of(context).canvasColor,
      progressWidget:Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator()
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
        fontSize: 14.0, fontFamily: 'NanumSquare')
    );
    await pd.show();
    await DataManager().getElevatorInfo(number.replaceAll('-', '')).then((value) async {
      await pd.hide();
      if(value == null || value.no == null) {
        showMessage();
        animationController.forward();
        if(Platform.isIOS) {
          HapticFeedback.heavyImpact();
        }
      } else {
        Config().setElevatorNo(number.replaceAll('-', '')).then((v) async {
          if(qr) {
            await DatabaseHelper().addHistoryQR(number);
          } else {
            await DatabaseHelper().addHistoryNumber(number);
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(value)));
        });
      }

    });
  }

  Widget gridButton(String s) {

    return Expanded(
      child: CustomButton(
        onTapUp: (_){
          if(Platform.isIOS) {
            HapticFeedback.lightImpact();
          }

          if(numbers.length == 7) {
            animationController.forward();
            if(Platform.isIOS) {
              HapticFeedback.heavyImpact();
            }
          }

          if(s == '<') {
            if(numbers.length > 0) {
              numbers.removeLast();
            }
          } else {
            if(numbers.length < 7) {
              numbers.add(s);
            }
          }

          setState(() {
            number = makeNumber();
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            s,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'NanumSquare',
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalDivider() {
    return Container(
      width: 1 / MediaQuery.of(context).devicePixelRatio,
      color: Theme.of(context).dividerColor,
    );
  }

  Widget horizontalDivider() {
    return Container(
      height: 1 / MediaQuery.of(context).devicePixelRatio,
      color: Theme.of(context).dividerColor,
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ThemeProvider>(context);
    provider.getTheme();

    return TitleScaffold(
      backSwipe: false,
      backButton: false,
      title: '엘베인포',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleLeftChild: TitleButton(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
        },
        padding: EdgeInsets.all(8),
        width: Dimens.titleBarHeight - 16,
        height: Dimens.titleBarHeight - 16,
        child: Icon(
          Icons.history_sharp,
          size: 24,
          color: Colors.white,
        ),
      ),
      titleRightChild: TitleButton(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
        },
        padding: EdgeInsets.all(8),
        width: Dimens.titleBarHeight - 16,
        height: Dimens.titleBarHeight - 16,
        child: Icon(
          Icons.settings,
          size: 24,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 45,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(Dimens.marginDefault),
                  child: AnimatedBuilder(
                    animation: offsetAnimation,
                    builder: (context, child) {
                      return Container(
                        transform: Matrix4.translationValues(offsetAnimation.value, 0, 0),
                        child: Text(
                          number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: numbers.length == 0 ? 40 : 54,
                            fontFamily: 'NanumSquare',
                            fontWeight: FontWeight.w100,
                            color: numbers.length == 0 ? Colors.white.withOpacity(0.5) : Colors.white,
                          ),
                        ),
                      );
                    }
                  ),
                ),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  curve: (_visible) ? Curves.decelerate : Curves.easeIn,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: Dimens.marginSmall,
                      left: Dimens.marginDefault,
                      right: Dimens.marginDefault
                    ),
                    padding: EdgeInsets.all(Dimens.marginDefault),
                    decoration: BoxDecoration(
                      color: SColors.red,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      '승강기 정보를 찾을 수 없습니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquare',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 330,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: CupertinoButton(
                            borderRadius: BorderRadius.circular(10),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: Dimens.marginSmall,
                                ),
                                Text(
                                  '주소 검색',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: FONT_FAMILY
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: Platform.isIOS,
                          child: Expanded(
                            child: CupertinoButton(
                              onPressed: () {
                                _startCamera();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.qr_code_sharp,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: Dimens.marginSmall,
                                  ),
                                  Text(
                                    'QR코드',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: FONT_FAMILY
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 245,
                    constraints: BoxConstraints(
                      maxWidth: 330,
                    ),
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              gridButton('1'),
                              gridButton('2'),
                              gridButton('3')
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              gridButton('4'),
                              gridButton('5'),
                              gridButton('6')
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              gridButton('7'),
                              gridButton('8'),
                              gridButton('9')
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: CupertinoButton(
                                      onPressed: (){
                                        if(numbers.length == 0) return;

                                        if(Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }

                                        if(numbers.length > 0) {
                                          numbers.clear();
                                        }

                                        setState(() {
                                          number = makeNumber();
                                        });
                                      },
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 250),
                                        opacity: numbers.length == 0 ? 0.0 : 1.0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.clear_rounded,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              gridButton('0'),
                              Expanded(
                                child: CustomButton(
                                  onTap: () {

                                    if(pressed) {
                                      pressed = false;
                                      return;
                                    }

                                    if(numbers.length == 0) return;

                                    if(Platform.isIOS) {
                                      HapticFeedback.lightImpact();
                                    }

                                    if(numbers.length > 0) {
                                      numbers.removeLast();
                                    }

                                    setState(() {
                                      number = makeNumber();
                                    });
                                  },
                                  onTapDown: (_){
                                    if(numbers.length > 0) {
                                      timer = Timer.periodic(Duration(milliseconds: 75), (timer) {
                                        pressed = true;
                                        if(Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }

                                        if(numbers.length > 0) {
                                          numbers.removeLast();
                                        } else {
                                          timer.cancel();
                                        }

                                        setState(() {
                                          number = makeNumber();
                                        });
                                      });
                                    }
                                  },
                                  onTapUp: (_) {
                                    timer.cancel();
                                  },
                                  onTapCancel: () {
                                    timer.cancel();
                                  },
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 250),
                                    opacity: numbers.length == 0 ? 0.0 : 1.0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.backspace_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimens.marginDefault,
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: numbers.length == 7 ? 1.0 : 0.4,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(Dimens.marginDefault),
                      child: CupertinoButton(
                        minSize: 50,
                        color: Theme.of(context).colorScheme.primary,
                        disabledColor: Theme.of(context).colorScheme.primary,
                        onPressed: numbers.length == 7 ? () => searchElevator() : null,
                        child: Text(
                          '검색',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 16,
                            fontFamily: FONT_FAMILY
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
