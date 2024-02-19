import 'package:elevinfo/essential.dart';
import 'package:elevinfo/managers/data.dart';
import 'package:elevinfo/managers/databasehelper.dart';
import 'package:elevinfo/screens/result.dart';

class ListScreen extends StatefulWidget {

  final String sido;
  final String sigungu;
  final String building;

  ListScreen(this.sido, this.sigungu, this.building);

  @override
  _ListScreenState createState() => _ListScreenState(this.sido, this.sigungu, this.building);
}

class _ListScreenState extends State<ListScreen> {

  final _scrollController = ScrollController();
  final double textSize = 16;
  final double subTextSize = 12;

  String? sido;
  String? sigungu;
  String? building;
  int page = 1;
  int beforeCount = -1;
  bool hasNextPage = true;
  bool loading = false;
  bool hasElevators = true;
  String? textTitle;

  List<Elevator> elevators = [];
  DataManager? dataManager;

  _ListScreenState(this.sido, this.sigungu, this.building);

  @override
  void initState() {
    _scrollController.addListener((){
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 10.0; // or something else..
      if (maxScroll - currentScroll <= delta) { // whatever you determine here
        setState(() {
          getList();
        });
      }
    });
    dataManager = DataManager();
    getList();

    super.initState();
  }

  Future getList() async {

    if(beforeCount == elevators.length) {
      return;
    }

    beforeCount = elevators.length;

    if(hasNextPage && !loading) {
      loading = true;
      setState(() {
        textTitle = '검색 중...';
      });
      List<Elevator> list = await dataManager!.getElevatorList(widget.sido, widget.sigungu, widget.building, page);

      setState(() {
        for (int i = 0; i < list.length; i++) {
          elevators.add(list[i]);
        }
      });

      page++;

      setState(() {
        textTitle = '${elevators.length}개 결과';

        if(elevators.length > 0) {
          hasElevators = true;
        } else {
          hasElevators = false;
        }
      });
      loading = false;
    }
  }

  Widget listItem(int index) {
    final hasNoData = elevators[index].no == '번호 없음';

    return GestureDetector(
        onTap: () async {
          await DatabaseHelper().addHistoryNumber(elevators[index].no!);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(elevators[index])));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: hasNoData ? Theme.of(context).colorScheme.error : Theme.of(context).cardColor,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                margin: EdgeInsets.all(Dimens.marginDefault),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 60,
                      child: Image.asset(
                        elevators[index].image!,
                        color: hasNoData ? SColors.red : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(
                    top: Dimens.marginSmall,
                    bottom: Dimens.marginSmall,
                    right: Dimens.marginSmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${elevators[index].building} ${elevators[index].installed}',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        elevators[index].address!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        height: Dimens.marginSmall,
                      ),
                      Text(
                        elevators[index].no!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        elevators[index].company!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        height: Dimens.marginSmall,
                      ),
                      Text(
                        '${elevators[index].depart} ${elevators[index].type}',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        height: Dimens.marginTiny,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '위치',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Container(
                              width: Dimens.marginSmall
                          ),
                          Expanded(
                            child: Text(
                              '${elevators[index].building} ${elevators[index].installed}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '구간',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Container(
                            width: Dimens.marginSmall
                          ),
                          Text(
                            elevators[index].serviceFloor!,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '속력',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Container(
                              width: Dimens.marginSmall
                          ),
                          Text(
                            (elevators[index].speedMin == null) ? '' : '${elevators[index].speedMin}m/min',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '모델',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Container(
                              width: Dimens.marginSmall
                          ),
                          Text(
                            elevators[index].model!,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return TitleScaffold(
      title: textTitle!,
      scrollController: _scrollController,
      body: Stack(
        children: <Widget>[
          ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(Dimens.marginSmall),
            scrollDirection: Axis.vertical,
            itemCount: elevators.length + 1,
            itemBuilder: (BuildContext context, int index){
              if(index != elevators.length) {
                return listItem(index);
              } else {
                return SafeArea(
                  top: false,
                  child: Container(),
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              height: 1,
            ),
          ),
          AnimatedOpacity(
            opacity: hasElevators ? 0.0 : 1.0,
            duration: Duration(milliseconds: 250),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.warning,
                    color: SColors.white87,
                    size: 32,
                  ),
                  Container(
                    height: Dimens.marginSmall,
                  ),
                  Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(
                      color: SColors.white87,
                      fontSize: 16,
                      fontFamily: 'NanumSquare',
                      fontWeight: FontWeight.bold,
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
