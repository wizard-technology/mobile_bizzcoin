import 'dart:convert';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/HomePage/Grouped.dart';
import 'package:bizzcoin_app/Screen/HomePage/GroupedItem.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Subcategories extends StatefulWidget {
  final id;
  final name;

  const Subcategories({Key key, this.id, this.name}) : super(key: key);
  @override
  _SubcategoriesState createState() => _SubcategoriesState(this.id, this.name);
}

class _SubcategoriesState extends State<Subcategories> {
  final id;
  final name;
  List<GroupedItem> grouped = [];
  bool loading = true;

  _SubcategoriesState(this.id, this.name);

  @override
  void initState() {
    onGroupedPress();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageService>(context);
    // Map _data = _language.getLanguage()['data'];
    bool _dir = _language.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: SafeArea(
        child: Container(
            width: screenWidth(context),
            height: screenHeight(context),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  width: screenWidth(context),
                  margin: EdgeInsets.only(top: screenHeight(context) / 40),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: _dir
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        _dir ? Icon(CupertinoIcons.back) : Container(),
                        SizedBox(
                          width: _dir ? 5 : 0,
                        ),
                        Text(
                          "$name",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
                          textAlign: TextAlign.center,
                        ),
                        !_dir
                            ? Icon(
                                CupertinoIcons.back,
                                textDirection: TextDirection.rtl,
                              )
                            : Container(),
                        SizedBox(
                          width: !_dir ? 5 : 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: screenWidth(context),
                  margin: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: _dir ? 6 : 0,
                    right: _dir ? 0 : 6,
                  ),
                  child: !loading
                      ? Wrap(
                          alignment: WrapAlignment.start,
                          textDirection:
                              _dir ? TextDirection.ltr : TextDirection.rtl,
                          children: [...grouped],
                        )
                      : Container(
                          width: screenWidth(context),
                          height: screenHeight(context) / 1.6,
                          child: Center(
                              child: Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: const Color(0xfff2f3f6),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          )),
                        ),
                )
              ],
            ))),
      ),
    );
  }

  Widget noResultFound(BuildContext context, _dir, _data) {
    return Container(
        height: screenHeight(context) / 1.4,
        color: const Color(0xfff2f3f6),
        child: Column(
          children: [
            Container(
              width: screenWidth(context) / 2.6,
              height: screenHeight(context) / 2.6,
              margin: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                  color: const Color(0xfff9bf2d), shape: BoxShape.circle),
              child: Center(
                  child: Icon(
                FeatherIcons.search,
                color: Colors.white,
                size: 60,
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                _data["NoResultFound"],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: screenHeight(context) / 25,
                  color: const Color(0xff0c0a0a),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }

  void onGroupedPress() async {
    setState(() {
      loading = true;
      grouped.clear();
    });
    String url = RouteApi().routeGet(name: "subcategory") + id.toString();
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    List category = body['subcategory'];
    String lang = await RouteApi().getLanguage();
    if (statusCode == 200) {
      category.forEach((element) {
        if (lang == 'kus') {
          grouped.add(
            GroupedItem(
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['st_image']}"),
              name: element['st_name_ku'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['st_name_ku']),
            ),
          );
        } else if (lang == 'en') {
          grouped.add(
            GroupedItem(
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['st_image']}"),
              name: element['st_name'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['st_name']),
            ),
          );
        } else if (lang == 'ar') {
          grouped.add(
            GroupedItem(
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['st_image']}"),
              name: element['st_name_ar'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['st_name_ar']),
            ),
          );
        } else if (lang == 'kuk') {
          grouped.add(
            GroupedItem(
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['st_image']}"),
              name: element['st_name_kr'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['st_name_kr']),
            ),
          );
        } else if (lang == 'per') {
          grouped.add(
            GroupedItem(
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['st_image']}"),
              name: element['st_name_pr'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['st_name_pr']),
            ),
          );
        }
      });
    }

    setState(() {
      loading = false;
    });
  }

  void onItemGroup(id, name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Grouped(
          id: id,
          name: name,
        ),
      ),
    );
  }
}
