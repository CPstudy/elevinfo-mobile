import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:elevinfo/essential.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;

class ThemeProvider with ChangeNotifier {

  late ThemeData _themeData;

  ThemeProvider() {
    startUp();
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.purple,
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark(
      useMaterial3: true,
    );
  }

  void startUp() async {
    Config().getTheme();
    setTheme(Config().type);
  }

  ThemeData getTheme() {
    return _themeData;
  }

  setTheme(String? type) {
    if(type == LIGHT_MODE) {
      _themeData = getLightTheme();
    } else if (type == DARK_MODE) {
      _themeData = getDarkTheme();
    } else {
      _themeData = getLightTheme();
    }

    Config().setTheme(type ?? LIGHT_MODE).then((value){
      notifyListeners();
    });
  }
}

class ElevatorProvider with ChangeNotifier {
  /// 승강기 검사 이력 불러오는 부분

  final int pageOfNum = 50;
  bool hasNextPage = true;
  int inspectPage = 0;
  List<InspectData> inspects = [];

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
        var response = await http.get(Uri.parse(url));

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