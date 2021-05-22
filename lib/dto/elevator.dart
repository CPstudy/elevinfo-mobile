import 'package:elevinfo/constants.dart';

class Elevator {

  final String NONE = '정보 없음';

  Map<String, dynamic> map = Map();

  String image;
  String no;
  String speedAll;
  String speedMin;
  String speedHour;
  String company;
  String address;
  String building;
  String installed;
  String installedNo;
  String weight;
  String person;
  String weightAndPerson;
  String upperFloor;
  String lowerFloor;
  String serviceFloor;
  String model;
  String depart;
  String type;

  Elevator.fromJSON(Map<String, dynamic> json) {
    map = json;

    print('${map['elevatorNo']} :: ${map['divGroundFloorCnt']}');

    company = (map['manufacturerName'] != null) ? map['manufacturerName'].toString() : '정보 없음';
    address = (map['address1'] != null) ? map['address1'].toString() : '';
    building = (map['buldNm'] != null) ? map['buldNm'].toString() : '';
    installed = (map['installationPlace'] != null) ? map['installationPlace'].toString() : '';
    installedNo = (map['elvtrAsignNo'] != null) ? map['elvtrAsignNo'].toString() : '';
    weight = (map['liveLoad'] != null) ? map['liveLoad'].toString() : '';
    person = (map['ratedCap'] != null) ? map['ratedCap'].toString() : '';
    upperFloor = (map['divGroundFloorCnt'] != null) ? map['divGroundFloorCnt'].toString() : '정보 없음';
    lowerFloor = (map['divUndgrndFloorCnt'] != null) ? map['divUndgrndFloorCnt'].toString() : '정보 없음';
    serviceFloor = (map['shuttleSection'] != null) ? map['shuttleSection'].toString() : '';
    model = (map['elvtrModel'] != null) ? map['elvtrModel'].toString() : '';
    depart = (map['elvtrDivNm'] != null) ? map['elvtrDivNm'].toString() : '';
    type = (map['elvtrKindNm'] != null) ? map['elvtrKindNm'].toString() : '';
    image = getImage(depart, type);

    if(depart == type) {
      type = '';
    }

    if(weight == '' && person != '') {
      weightAndPerson = person;
    } else if(weight != '' && person == '') {
      weightAndPerson = weight;
    } else if(weight != '' && person != '') {
      weightAndPerson = '$weight / $person';
    } else {
      weightAndPerson = '';
    }

    if(map['elevatorNo'] != null) {
      String n = '${map['elevatorNo']}';
      no = '${n.substring(0, 4)}-${n.substring(4, 7)}';
    } else {
      map['elevatorNo'] = '번호 없음';
      no = '번호 없음';
    }

    if(map['ratedSpeed'] != null) {
      String s = '${map['ratedSpeed']}'.toLowerCase().replaceAll('m/min', '').trim();

      if (s.substring(0, 1) == '.') {
        s = '0$s';
      }

      s = '${(double.parse(s) * 60).toStringAsFixed(1)}';

      String m = '${(double.parse(s) % 1)}';

      if (m == '0.0') {
        s = '${double.parse(s).toInt()}';
      }

      String sh = (double.parse(s) / 1000 * 60).toStringAsFixed(1);

      speedAll = '${s}m/min (${sh}km/h)';
      speedMin = s;
      speedHour = sh;
      map['ratedSpeed'] = speedAll;

    } else {
      map['ratedSpeed'] = '정보 없음';
    }
  }

  String getImage(String depart, String type) {

    if(depart == '엘리베이터') {
      if(type.contains('자동차')) {
        if(type.contains('전망')) {
          return 'images/icon_car_glass.png';
        } else {
          return 'images/icon_car.png';
        }
      } else if(type.contains('장애')) {
        if(type.contains('전망')) {
          return 'images/icon_elevator_disabled_glass.png';
        } else {
          return 'images/icon_elevator_disabled.png';
        }
      } else if(type.contains('소방')) {
        if(type.contains('전망')) {
          return 'images/icon_elevator_fire_glass.png';
        } else {
          return 'images/icon_elevator_fire.png';
        }
      } else if(type.contains('승객화물')) {
        if(type.contains('전망')) {
          return 'images/icon_elevator_person_freight_glass.png';
        } else {
          return 'images/icon_elevator_person_freight.png';
        }
      } else if(type.contains('화물')) {
        if(type.contains('전망')) {
          return 'images/icon_elevator_freight_glass.png';
        } else {
          return 'images/icon_elevator_freight.png';
        }
      } else {
        if(type.contains('전망')) {
          return 'images/icon_elevator_glass.png';
        } else {
          return 'images/icon_elevator.png';
        }
      }
    } else if(depart == '에스컬레이터') {
      return 'images/icon_escalator.png';
    } else if(depart == '무빙워크') {
      return 'images/icon_movingwalk.png';
    } else if(depart == '휠체어리프트') {
      return 'images/icon_lift.png';
    } else if(depart == '소형화물용엘리베이터') {
      if(type.contains('덤웨이터')) {
        if(type.contains('전망')) {
          return 'images/icon_dumbwaiter_glass.png';
        } else {
          return 'images/icon_dumbwaiter.png';
        }
      } else {
        return 'images/icon_questionmark.png';
      }
    } else {
      return 'images/icon_questionmark.png';
    }
  }
}

class InspectData {
  String startDate;       // 운행시작일
  String endDate;         // 운행종료일
  String inspectDate;     // 검사일자
  String inspectOrg;      // 검사기관
  String inspectType;     // 검사종류
  String inspectResult;   // 합격유무
  int receiptNo;          // 접수번호

  final String noData = '정보 없음';

  InspectData.fromJSON(Map<String, dynamic> json) {
    startDate = json['applcBeDt'] ?? noData;
    endDate = json['applcEnDt'] ?? noData;
    inspectDate = json['inspctDt'] ?? noData;
    inspectOrg = json['inspctInsttNm'] ?? noData;
    inspectType = json['inspctKind'] ?? noData;
    inspectResult = json['psexamYn'] ?? noData;
    receiptNo = json['recptnNo'] ?? noData;
  }

}