import 'dart:io';

import 'package:elevinfo/essential.dart';
import 'package:elevinfo/managers/data.dart';
import 'package:elevinfo/managers/databasehelper.dart';
import 'package:elevinfo/providers/elevprovider.dart';
import 'package:elevinfo/screens/list.dart';
import 'package:elevinfo/screens/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  Future searchElevator(String number) async {
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
        Fluttertoast.showToast(msg: '정보를 불러오는데 실패했습니다.', backgroundColor: Colors.red);
        if(Platform.isIOS) {
          HapticFeedback.heavyImpact();
        }
      } else {
        Config().setElevatorNo(number.replaceAll('-', '')).then((v) async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(value)));
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    final ThemeProvider provider = Provider.of<ThemeProvider>(context);

    return TitleScaffold(
      title: '히스토리',
      titleRightChild: IconButton(
        onPressed: () {
          if(Platform.isIOS) {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => Theme(
                data: MediaQuery.of(context).platformBrightness == Brightness.light ? ThemeData.light() : ThemeData.dark(),
                child: CupertinoActionSheet(
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '취소',
                    ),
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '히스토리 모두 삭제'
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  '히스토리 삭제',
                ),
                content: Text(
                  '히스토리를 모두 지우겠습니까?'
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '지우기',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        icon: Icon(Icons.delete_sharp, color: Colors.white,),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().historyAllList(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Container();
          } else {
            List<Map<String, dynamic>> histories = snapshot.data;

            return ListView.separated(
              padding: EdgeInsets.only(
                top: Dimens.marginDefault,
                left: Dimens.marginDefault,
                right: Dimens.marginDefault,
                bottom: Dimens.marginDefault + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: histories.length + 1,
              itemBuilder: (context, index) {
                if(index == 0) return SizedBox.shrink();

                Map<String, dynamic> history = histories[index - 1];
                int id = history['id'];
                String no = history['no'];
                String address1 = history['address1'];
                String address2 = history['address2'];
                String searchDate = history['search_date'];
                int searchType = history['search_type'];

                DateTime date = DateTime.parse(searchDate);
                int year = date.year;
                int month = date.month;
                int day = date.day;
                int hour = date.hour;
                int minute = date.minute;

                String header;
                switch(searchType) {
                  case 0:
                    header = '번호 검색';
                    break;

                  case 1:
                    header = '주소 검색';
                    break;

                  case 2:
                    header = 'QR 검색';
                    break;

                  case 3:
                    header = '주소로 번호 검색';
                    break;

                  default:
                    header = '알 수 없음';
                }

                return InkWell(
                  onTap: () {
                    switch(searchType) {
                      case 0:
                      case 2:
                      case 3:
                        searchElevator(no);
                        break;

                      case 1:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListScreen(address1, address2)));
                    }
                  },
                  child: Container(
                    height: 88,
                    padding: EdgeInsets.all(Dimens.marginSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: Dimens.marginSmall,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(2.5),
                                    ),
                                    child: Text(
                                      header,
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.headline4.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      sprintf('%02d:%02d', [hour, minute]),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        height: 1,
                                        color: Theme.of(context).textTheme.caption.color,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: searchType != 1,
                                child: SizedBox(
                                  height: 4,
                                ),
                              ),
                              Visibility(
                                visible: searchType != 1,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '번호',
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Container(
                                      width: Dimens.marginSmall
                                    ),
                                    Text(
                                      no ?? '',
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: searchType == 1 || searchType == 3,
                                child: SizedBox(
                                  height: 4,
                                ),
                              ),
                              Visibility(
                                visible: searchType == 1 || searchType == 3,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '주소',
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Container(
                                      width: Dimens.marginSmall
                                    ),
                                    Text(
                                      address1 ?? '',
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: searchType == 1 || searchType == 3,
                                child: SizedBox(
                                  height: 4,
                                ),
                              ),
                              Visibility(
                                visible: searchType == 1 || searchType == 3,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '건물명',
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Container(
                                      width: Dimens.marginSmall
                                    ),
                                    Text(
                                      address2 ?? '',
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 50,
                          height: double.infinity,
                          child: CupertinoButton(
                            onPressed: () async {
                              await DatabaseHelper().deleteHistory(id);
                              setState(() {

                              });
                            },
                            child: Icon(
                              CupertinoIcons.minus_circle_fill,
                              color: CupertinoColors.systemRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                List<String> week = ['', '월', '화', '수', '목', '금', '토', '일'];

                if(index > 0) {
                  Map<String, dynamic> today = histories[index];
                  Map<String, dynamic> yesterday = histories[index - 1];
                  DateTime tDate = DateTime.parse(today['search_date']);
                  DateTime yDate = DateTime.parse(yesterday['search_date']);

                  String tText = sprintf('%04d년 %d월 %d일 %s요일', [tDate.year, tDate.month, tDate.day, week[tDate.weekday]]);
                  String yText = sprintf('%04d년 %d월 %d일 %s요일', [yDate.year, yDate.month, yDate.day, week[yDate.weekday]]);

                  if(tText != yText) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: 24,
                        bottom: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimens.marginSmall,
                            ),
                            child: Text(
                              tText.toString(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else if(index == 0) {
                  Map<String, dynamic> today = histories[index];
                  DateTime tDate = DateTime.parse(today['search_date']);

                  String tText = sprintf('%04d년 %d월 %d일 %s요일', [tDate.year, tDate.month, tDate.day, week[tDate.weekday]]);

                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.marginSmall,
                          ),
                          child: Text(
                            tText.toString(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox(
                  height: Dimens.marginSmall,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ItemNo extends StatelessWidget {

  ItemNo({
    @required this.no,
    @required this.searchDate,
  }) : assert(no != null),
       assert(searchDate != null);

  final String no;

  final String searchDate;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
