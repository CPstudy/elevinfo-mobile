import 'package:elevinfo/essential.dart';
import 'package:elevinfo/screens/inspect_page.dart';
import 'package:flutter/services.dart';

class ResultScreen extends StatefulWidget {

  final Elevator elevator;

  ResultScreen(this.elevator);
  @override
  _ResultScreenState createState() => _ResultScreenState(elevator);
}

class _ResultScreenState extends State<ResultScreen> {

  Elevator elevator;
  List<String> titles = List();
  List<String> params = List();


  _ResultScreenState(this.elevator) {
    titles = TITLES;
    params = PARAMS;
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width - (Dimens.marginDefault * 2) - 100;

    return TitleScaffold(
      title: elevator.no,
      titleRightChild: IconButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InspectPage(elevator: widget.elevator)));
        },
        icon: Icon(
          Icons.assignment_sharp,
          color: Colors.white,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(Dimens.marginSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    elevator.company,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: FONT_FAMILY,
                    ),
                  ),
                  Container(
                    height: Dimens.marginSmall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        '${elevator.speedMin}',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 32,
                          fontFamily: FONT_FAMILY,
                        ),
                      ),
                      Text(
                        'm/min',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: FONT_FAMILY,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: Dimens.marginDefault,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 100,
                                padding: EdgeInsets.all(Dimens.marginDefault),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  elevator.image,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: Dimens.marginSmall,
                              ),
                              LimitedBox(
                                maxWidth: 100,
                                child: Text(
                                  '${elevator.model}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FONT_FAMILY
                                  ),
                                ),
                              ),
                              LimitedBox(
                                maxWidth: 100,
                                child: Text(
                                  '${elevator.serviceFloor}',
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 16,
                                    fontFamily: FONT_FAMILY
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: Dimens.marginDefault,
                        ),
                        LimitedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LimitedBox(
                                maxWidth: maxWidth,
                                child: Text(
                                  '${elevator.depart} ${elevator.type}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 16,
                                    fontFamily: FONT_FAMILY,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (elevator.weightAndPerson != ''),
                                child: Container(
                                  height: 4,
                                ),
                              ),
                              Visibility(
                                visible: (elevator.weightAndPerson != ''),
                                child: LimitedBox(
                                  maxWidth: maxWidth,
                                  child: Text(
                                    elevator.weightAndPerson,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 16,
                                        fontFamily: FONT_FAMILY
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 4,
                              ),
                              LimitedBox(
                                maxWidth: maxWidth,
                                child: Text(
                                  '${elevator.building}',
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 16,
                                    fontFamily: FONT_FAMILY
                                  ),
                                ),
                              ),
                              Container(
                                height: 4,
                              ),
                              LimitedBox(
                                maxWidth: maxWidth,
                                child: Text(
                                  '${elevator.installed} ${elevator.installedNo}호기',
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 16,
                                      fontFamily: FONT_FAMILY
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: Dimens.marginSmall,
                      right: Dimens.marginSmall,
                      top: 268,
                      bottom: Dimens.marginSmall,
                    ),
                    padding: EdgeInsets.all(Dimens.marginSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(0, 0),
                            blurRadius: 3,
                            spreadRadius: 1.0
                        )
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      itemCount: titles.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onLongPress: (){
                          Clipboard.setData(new ClipboardData(text: '${elevator.map[params[index]]}'));
                          Fluttertoast.showToast(
                              msg: '\'${elevator.map[params[index]]}\' 복사',
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIos: 2,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 16.0,
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 45,
                          margin: EdgeInsets.symmetric(horizontal: Dimens.marginSmall),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  titles[index],
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FONT_FAMILY
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  (){
                                    if(index == 0) {
                                      return elevator.no;
                                    } else {
                                      return '${elevator.map[params[index]]}';
                                    }
                                  }(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FONT_FAMILY
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
