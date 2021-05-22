import 'package:elevinfo/essential.dart';
import 'package:elevinfo/managers/data.dart';
import 'package:elevinfo/managers/databasehelper.dart';
import 'package:elevinfo/screens/result.dart';

class ListScreen extends StatefulWidget {

  final String address1;
  final String address2;

  ListScreen(this.address1, this.address2);

  @override
  _ListScreenState createState() => _ListScreenState(this.address1, this.address2);
}

class _ListScreenState extends State<ListScreen> {

  final _scrollController = ScrollController();
  final double textSize = 16;
  final double subTextSize = 12;

  String address1;
  String address2;
  int page = 1;
  int beforeCount = -1;
  bool hasNextPage = true;
  bool loading = false;
  bool hasElevators = true;
  String textTitle;

  List<Elevator> elevators = List();
  DataManager dataManager;

  _ListScreenState(this.address1, this.address2);

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
      List<Elevator> list = await dataManager.getElevatorList(widget.address1, widget.address2, page);

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
    return GestureDetector(
        onTap: () async {
          await DatabaseHelper().addHistoryAddressToNo(elevators[index].no, address1, address2);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(elevators[index])));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: (elevators[index].no == '번호 없음') ? Theme.of(context).colorScheme.error : Theme.of(context).cardColor,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                margin: EdgeInsets.all(Dimens.marginDefault),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Image.asset(
                        elevators[index].image,
                        color: (elevators[index].no == '번호 없음') ? SColors.red : Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(top: Dimens.marginSmall, bottom: Dimens.marginSmall, right: Dimens.marginSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        elevators[index].no,
                        style: (elevators[index].no == '번호 없음') ? Theme.of(context).textTheme.headline5 : Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        elevators[index].company,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Container(
                        height: Dimens.marginSmall,
                      ),
                      Text(
                        '${elevators[index].depart} ${elevators[index].type}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: Dimens.marginTiny,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '위치',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Container(
                              width: Dimens.marginSmall
                          ),
                          Expanded(
                            child: Text(
                              '${elevators[index].building} ${elevators[index].installed}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '구간',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Container(
                            width: Dimens.marginSmall
                          ),
                          Text(
                            elevators[index].serviceFloor,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '속력',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Container(
                              width: Dimens.marginSmall
                          ),
                          Text(
                            (elevators[index].speedMin == null) ? '' : '${elevators[index].speedMin}m/min',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '모델',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Container(
                              width: Dimens.marginSmall
                          ),

                          Text(
                            elevators[index].model,
                            style: Theme.of(context).textTheme.headline5,
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
      title: textTitle,
      scrollController: _scrollController,
      body: Stack(
        children: <Widget>[
          ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(Dimens.marginSmall),
            scrollDirection: Axis.vertical,
            itemCount: elevators.length + 1,
            separatorBuilder: (BuildContext context, int index) => Container(
              height: Dimens.marginSmall,
            ),
            itemBuilder: (BuildContext context, int index){
              if(index != elevators.length) {
                return listItem(index);
              } else {
                return SafeArea(
                  top: false,
                  child: Container(),
                );
              }
            }
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
