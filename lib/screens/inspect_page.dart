import 'package:elevinfo/essential.dart';
import 'package:elevinfo/providers/elevprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspectPage extends StatefulWidget {

  InspectPage({
    @required this.elevator,
  }) : assert(elevator != null);

  final Elevator elevator;

  @override
  _InspectPageState createState() => _InspectPageState();
}

class _InspectPageState extends State<InspectPage> {

  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener((){
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 10.0; // or something else..
      if (maxScroll - currentScroll <= delta) { // whatever you determine here
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ElevatorProvider(),
      child: Consumer<ElevatorProvider>(
        builder: (context, provider, _) {
          return TitleScaffold(
            title: '검사이력',
            body: FutureBuilder<List<InspectData>>(
              future: provider.getInspect(widget.elevator.no.replaceAll('-', '')),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              height: Dimens.marginDefault,
                            ),
                            Text(
                              '검색 중',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: FONT_FAMILY,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).padding.bottom,
                            ),
                          ],
                        ),
                      );
                    default:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_sharp,
                              size: 42,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: Dimens.marginDefault,
                            ),
                            Text(
                              '검색 결과 없음',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: FONT_FAMILY,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).padding.bottom,
                            ),
                          ],
                        ),
                      );
                  }
                } else {
                  List<InspectData> list = snapshot.data;
                  return ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      top: Dimens.marginSmall,
                      bottom: MediaQuery.of(context).padding.bottom + Dimens.marginSmall,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      InspectData data = list[index];
                      String inspectResult = data.inspectResult;
                      Color color = Theme.of(context).primaryColor;

                      if(inspectResult.contains('조건부합격')) {
                        color = Colors.orange;
                      } else if(inspectResult.contains('불합격')) {
                        color = Colors.red;
                      } else if(inspectResult.contains('합격')) {
                        color = CupertinoColors.systemGreen;
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimens.marginSmall,
                        ),
                        padding: EdgeInsets.only(
                          top: Dimens.marginDefault,
                          left: Dimens.marginSmall,
                          right: Dimens.marginSmall,
                          bottom: Dimens.marginSmall,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  data.inspectResult,
                                  style: TextStyle(
                                    height: 1,
                                    color: color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FONT_FAMILY,
                                  ),
                                ),
                                SizedBox(
                                  width: Dimens.marginSmall,
                                ),
                                Text(
                                  data.inspectDate,
                                  style: TextStyle(
                                    height: 1,
                                    color: Theme.of(context).textTheme.headline5.color.withOpacity(0.4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FONT_FAMILY,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimens.marginSmall + Dimens.marginTiny,
                            ),
                            InspectItemRow(
                              title: '운행유효기간',
                              text: '${data.startDate} ~ ${data.endDate}',
                            ),
                            SizedBox(
                              height: Dimens.marginTiny,
                            ),
                            InspectItemRow(
                              title: '검사기관　　',
                              text: data.inspectOrg,
                            ),
                            SizedBox(
                              height: Dimens.marginTiny,
                            ),
                            InspectItemRow(
                              title: '검사종류　　',
                              text: data.inspectType,
                            ),
                            SizedBox(
                              height: Dimens.marginTiny,
                            ),
                            InspectItemRow(
                              title: '접수번호　　',
                              text: '${data.receiptNo}',
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: Dimens.marginSmall,
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class InspectItemRow extends StatelessWidget {

  InspectItemRow({
    @required this.title,
    @required this.text,
  }) : assert(title != null),
       assert(text != null);

  final String title;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            width: Dimens.marginDefault,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
