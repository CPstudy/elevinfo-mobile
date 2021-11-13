import 'package:elevinfo/essential.dart';

class SearchProvider with ChangeNotifier {
  String _address1 = '';

  String _address2 = '';

  String get address1 => _address1;
  set address1(String s) {
    _address1 = s;
    notifyListeners();
  }

  String get address2 => _address2;
  set address2(String s) {
    _address2 = s;
    notifyListeners();
  }
}