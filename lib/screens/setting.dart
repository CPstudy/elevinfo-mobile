import 'package:elevinfo/essential.dart';
import 'package:elevinfo/providers/elevprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  Widget radioButtonNone() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Theme.of(context).accentColor),
      ),
    );
  }

  Widget radioButtonSelected() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Theme.of(context).accentColor),
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).accentColor
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final ThemeProvider provider = Provider.of<ThemeProvider>(context);

    return TitleScaffold(
      title: '설정',
      body: Padding(
        padding: EdgeInsets.all(Dimens.marginDefault),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(Dimens.marginDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                new BoxShadow(
                    color: Colors.black12,
                    offset: new Offset(0, 0),
                    blurRadius: 3,
                    spreadRadius: 1.0
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          provider.setTheme(LIGHT_MODE);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                child: Container(
                                  height: 100,
                                  child: Image.asset('images/theme_light.png'),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              Container(
                                height: Dimens.marginSmall,
                              ),
                              Text(
                                '라이트',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FONT_FAMILY,
                                ),
                              ),
                              Container(
                                height: Dimens.marginSmall,
                              ),
                              (){
                                if(Config().type == LIGHT_MODE) {
                                  return radioButtonSelected();
                                } else {
                                  return radioButtonNone();
                                }
                              }()
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: Dimens.marginLarge,
                      ),
                      GestureDetector(
                        onTap: (){
                          provider.setTheme(DARK_MODE);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                child: Container(
                                  height: 100,
                                  child: Image.asset('images/theme_dark.png'),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              Container(
                                height: Dimens.marginSmall,
                              ),
                              Text(
                                '다크',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FONT_FAMILY,
                                ),
                              ),
                              Container(
                                height: Dimens.marginSmall,
                              ),
                              (){
                                if(Config().type == DARK_MODE) {
                                  return radioButtonSelected();
                                } else {
                                  return radioButtonNone();
                                }
                              }()
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: Dimens.marginLarge,
                      ),
                      GestureDetector(
                        onTap: (){
                          provider.setTheme(SYSTEM_MODE);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                child: Container(
                                  height: 100,
                                  child: Image.asset('images/theme_auto.png'),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              Container(
                                height: Dimens.marginSmall,
                              ),
                              Text(
                                '시스템',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FONT_FAMILY,
                                ),
                              ),
                              Container(
                                height: Dimens.marginSmall,
                              ),
                                (){
                                if(Config().type == SYSTEM_MODE) {
                                  return radioButtonSelected();
                                } else {
                                  return radioButtonNone();
                                }
                              }()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: Dimens.marginDefault),
                  color: Theme.of(context).dividerColor,
                ),
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '버전',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: FONT_FAMILY
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '2.3.0',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: FONT_FAMILY
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: Dimens.marginDefault),
                  color: Theme.of(context).dividerColor,
                ),
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '정보 제공',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: FONT_FAMILY
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '공공데이터포털 / 한국승강기안전공단',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: FONT_FAMILY
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: Dimens.marginDefault),
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    onPressed: () async {
                      const url = 'http://pf.kakao.com/_HbNJK/chat';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    color: Color(0xffffdf2c),
                    child: Text(
                      '엘베인포 카카오톡',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: FONT_FAMILY
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
