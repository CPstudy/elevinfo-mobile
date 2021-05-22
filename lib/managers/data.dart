import 'package:elevinfo/essential.dart';
import 'package:http/http.dart' as http;

class DataManager {

  int pageNum = 1;
  int totalCount = 0;
  int totalPage = 0;
  int beforeCount = -1;

  Future<Elevator> getElevatorInfo(String no) async {
    final String URL_CONNECT = '$URL_VIEW$KEY$NUMBER$no';

    print(URL_CONNECT);

    try {
      var response = await http.get(URL_CONNECT);

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      var result = body['response']['body'];

      if(result == null || result == '') {
        return null;
      } else {
        Map<String, dynamic> map = result['item'];
        Elevator elevator = Elevator.fromJSON(map);

        return elevator;
      }
    } catch(e) {
      return null;
    }
  }

  Future<List<Elevator>> getElevatorList(String address1, String address2, int page) async {

    final String URL_CONNECT = '$URL_LIST$KEY&_type=json&sido=$address1&buld_nm=$address2&numOfRows=100&pageNo=$page';
    List<Elevator> elevators = [];

    print(URL_CONNECT);

    var response = await http.get(URL_CONNECT);

    Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    var result = body['response']['body'];

    totalCount = result['totalCount'];

    totalPage = totalCount ~/ 100;
    if(totalCount % 100 > 0) {
      totalPage++;
    }


    if(result['items'] != '') {
      try {
        var item = result['items']['item'] as List;
        elevators = item.map<Elevator>((json) => Elevator.fromJSON(json)).toList();

      } catch (e) {
        var item = result['items']['item'];
        Elevator elevator = Elevator.fromJSON(item);
        elevators.add(elevator);
        print(e);
      }

      return elevators;
    } else {
      return elevators;
    }
  }
}