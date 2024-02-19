import 'package:elevinfo/essential.dart';
import 'package:elevinfo/managers/databasehelper.dart';
import 'package:elevinfo/providers/search_provider.dart';
import 'package:elevinfo/screens/list.dart';
import 'package:elevinfo/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final addressController1 = TextEditingController();
  final addressController2 = TextEditingController();

  Widget textInput(TextEditingController controller, String hint) {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: 60,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Text(
            hint,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
                fontFamily: FONT_FAMILY
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: Dimens.marginDefault),
            color: Colors.black26,
            child: TextField(
              controller: controller,
              keyboardAppearance: Config().type == LIGHT_MODE ? Brightness.light : Brightness.dark,
              style: TextStyle(
                fontFamily: FONT_FAMILY
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            if(controller == addressController1) {
              addressController1.text = '';
            } else {
              addressController2.text = '';
            }
          },
          child: Container(
            alignment: Alignment.center,
            width: 42,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              color: Colors.black26,
            ),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.clear,
                size: 10,
                color: Colors.white30,
              ),
            ),
          ),
        )
      ],
    );
  }

  List<String> addFirstToList(List<String> list, String text) {
    list.insert(0, '선택 안 함');
    return list;
  }

  @override
  Widget build(BuildContext context) {

    final sido = '시/도';
    final sigungu = '시/군/구';

    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          return TitleScaffold(
            title: '주소로 검색',
            backSwipe: true,
            body: SafeArea(
              top: false,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(Dimens.marginDefault),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                                child: CustomButton(
                                  onTap: () async {
                                    final address = await showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.black.withOpacity(0.01),
                                      builder: (context) => SelectListPanel(
                                        list: addFirstToList(addresses.entries.map((e) => e.key).toList(), sido),
                                      ),
                                    );

                                    if (address == null) {
                                      return;
                                    }

                                    if (provider.address1 != address) {
                                      provider.address2 = '';
                                    }

                                    if (address == '선택 안 함') {
                                      provider.address1 = '';
                                    } else {
                                      provider.address1 = address;
                                    }
                                  },
                                  child: Text(
                                    provider.address1 == '' ? sido : provider.address1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FONT_FAMILY,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: CustomButton(
                                  onTap: () async {
                                    final address = await showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.black.withOpacity(0.01),
                                      builder: (context) => SelectListPanel(
                                        list: addFirstToList(addresses[provider.address1]?.toList(growable: true) ?? [], sigungu),
                                      ),
                                    );

                                    if (address == null) {
                                      return;
                                    }

                                    if (address == '선택 안 함') {
                                      provider.address2 = '';
                                    } else {
                                      provider.address2 = address;
                                    }
                                  },
                                  child: Text(
                                    provider.address2 == '' ? sigungu : provider.address2,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FONT_FAMILY,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.marginSmall,
                        ),
                        textInput(addressController2, '건물명'),
                        SizedBox(
                          height: Dimens.marginSmall,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(Dimens.marginDefault),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(Dimens.borderRadius),
                        minSize: Dimens.buttonHeight,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ListScreen(
                              provider.address1,
                              provider.address2,
                              addressController2.text
                          )));
                        },
                        child: Text(
                          '검색',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: FONT_FAMILY
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SelectListPanel extends StatelessWidget {
  const SelectListPanel({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: EdgeInsets.symmetric(
        horizontal: Dimens.marginSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.borderRadius),
          topRight: Radius.circular(Dimens.borderRadius),
        )
      ),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.marginLarge,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return CustomButton(
            onTap: () {
              Navigator.pop(context, list[index]);
            },
            child: Text(
              list[index],
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontFamily: FONT_FAMILY,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
          height: Dimens.marginDefault,
        ),
      ),
    );
  }
}
