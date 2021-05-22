
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'managers/config.dart';
import 'providers/elevprovider.dart';
import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Config().init(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        print(snapshot.hasData);
        if(!snapshot.hasData) {
          return Container(
            constraints: BoxConstraints.expand(),
            color: Colors.white,
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: MyAppWithTheme(),
          );
        }
      },
    );
  }
}

class MyAppWithTheme extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ThemeProvider>(context);

    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1),
      child: MaterialApp(
        title: '엘베인포',
        debugShowCheckedModeBanner: false,
        theme: provider.getTheme(),
        darkTheme: Config().type == SYSTEM_MODE ? provider.getDarkTheme() : null,
        home: HomeScreen(),
      ),
    );
  }
}
