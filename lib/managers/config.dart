import 'package:elevinfo/essential.dart';

class Config {

  static Config _manager = Config._internal();

  static Config get manager => _manager;

  factory Config() {
    return _manager;
  }

  Config._internal();

  SharedPreferences _prefs;
  String type = SYSTEM_MODE;

  Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  void getTheme() {
    type = _prefs.getString('theme');
    if(type == null) type = SYSTEM_MODE;
  }

  Future setTheme(String theme) async {
    await _prefs.setString('theme', theme);
    type = theme;
  }

  Future setElevatorNo(String no) async {
    await _prefs.setString('elevatorNo', no);
  }

  List<String> getElevatorNo() {
    String no;

    if(_prefs.containsKey('elevatorNo')) {
      no = _prefs.getString('elevatorNo');
    } else {
      return [];
    }

    List<String> list = List();

    if(no == null || no.length != 7) {
      return null;
    }

    for(int i = 0; i < no.length; i++) {
      list.add(no.substring(i, i + 1));
    }

    if(list.length != 7) {
      list.clear();
    }

    return list;
  }
}