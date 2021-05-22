import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:elevinfo/essential.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;

class ThemeProvider with ChangeNotifier {


  ThemeData _themeData;

  ThemeProvider() {
    startUp();
  }

  ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
        },
      ),
      primaryColor: SColors.blueGreen,
      accentColor: SColors.colorPrimary,
      scaffoldBackgroundColor: SColors.blueGreen,
      canvasColor: SColors.gridBackgroundLight,
      cardColor: SColors.listBackgroundLight,
      textTheme: ThemeData.light().textTheme.copyWith(
        headline5: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontFamily: 'NanumSquare',
          fontWeight: FontWeight.bold,
          fontSize: 12
        ),
        headline4: TextStyle(
          color: SColors.blueGreen,
          fontFamily: 'NanumSquare',
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
        headline3: TextStyle(
          color: SColors.red,
          fontFamily: 'NanumSquare',
          fontWeight: FontWeight.bold,
          fontSize: 12
        ),
      ),
      dividerColor: SColors.dividerLight,
      colorScheme: ColorScheme.light().copyWith(
        primary: Colors.white.withOpacity(0.8),
        error: SColors.errorLight
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
        },
      ),
      primaryColor: SColors.colorDarkPrimary,
      accentColor: Colors.white,
      scaffoldBackgroundColor: Color(0xff19191e),
      canvasColor: SColors.gridBackgroundDark,
      cardColor: SColors.listBackgroundDark,
      textTheme: ThemeData.dark().textTheme.copyWith(
        headline5: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontFamily: 'NanumSquare',
          fontWeight: FontWeight.bold,
          fontSize: 12
        ),
        headline4: TextStyle(
          fontFamily: 'NanumSquare',
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
        headline3: TextStyle(
          color: SColors.red,
          fontFamily: 'NanumSquare',
          fontWeight: FontWeight.bold,
          fontSize: 12
        ),
      ),
      dividerColor: SColors.dividerDark,
      colorScheme: ColorScheme.light().copyWith(
        primary: SColors.colorPrimary,
        error: SColors.errorDark
      ),
    );
  }

  void startUp() async {
    Config().getTheme();
    setTheme(Config().type);
  }

  ThemeData getTheme() {
    return _themeData ?? getLightTheme();
  }

  setTheme(String type) {
    if(type == LIGHT_MODE) {
      _themeData = getLightTheme();
    } else if (type == DARK_MODE) {
      _themeData = getDarkTheme();
    } else {
      _themeData = getLightTheme();
    }

    Config().setTheme(type).then((value){
      notifyListeners();
    });
  }
}

class ElevatorProvider with ChangeNotifier {
  /// 승강기 검사 이력 불러오는 부분

  final int pageOfNum = 50;
  bool hasNextPage = true;
  int inspectPage = 0;
  List<InspectData> inspects = List();

  Future<List<InspectData>> getInspect(String elevatorNo) async {
    if(!hasNextPage) {
      print('has no page');
      return inspects;
    } else {
      int beforeCount = inspects.length;
      inspectPage++;
      final String url = URL_INSPECT + '&_type=json&elevator_no=' + elevatorNo + '&numOfRows=' + pageOfNum.toString() + '&pageNo=' + inspectPage.toString();
      print('url = $url');

      try {
        var response = await http.get(url);

        Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        var result = body['response']['body'];


        if(result['items'] != '') {
          List<dynamic> items = result['items']['item'] as List;
          inspects.addAll(items.map<InspectData>((json) => InspectData.fromJSON(json)).toList());
        }

      } catch(e) {
        print(e);
      }

      if(beforeCount <= inspects.length) {
        hasNextPage = false;
        inspectPage--;
      }

      return inspects;
    }
  }
}