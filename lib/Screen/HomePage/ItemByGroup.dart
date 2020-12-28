import 'dart:convert';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/HomePage/ProductItem.dart';
import 'package:bizzcoin_app/Screen/HomePage/ViewItemPage.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ItemByGrouped extends StatefulWidget {
  final id;
  final name;

  const ItemByGrouped({Key key, this.id, this.name}) : super(key: key);
  @override
  _ItemByGroupedState createState() => _ItemByGroupedState(this.id, this.name);
}

class _ItemByGroupedState extends State<ItemByGrouped> {
  final id;
  final name;
  String nextPage;
  List data = [];
  List<ProductItem> prod = [];
  bool loading = true;
  ScrollController _scrollController = new ScrollController();

  _ItemByGroupedState(this.id, this.name);

  @override
  void initState() {
    nextPage = RouteApi().routeGet(name: "product_grouped") + id.toString();

    nextPage == null ? () {} : _getProduct(nextPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          // ignore: unnecessary_statements
          nextPage == null ? () {} : _getProduct(nextPage);
        });
      }
    });
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
            controller: _scrollController,
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
                          children: [...prod],
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
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
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

  _getProduct(next) async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Response response = await get(next, headers: headers);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    nextPage = body['product']['next_page_url'];
    List product = body['product']['data'];
    String lang = await RouteApi().getLanguage();
    print(product);

    if (statusCode == 200) {
      product.forEach((element) {
        if (lang == 'kus') {
          prod.add(
            ProductItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['p_image']}"),
              price: RouteApi().reciprocal(element['p_price']),
              name: element['p_name_ku'],
              onItemPressed: () => onItemPressed(element['id']),
            ),
          );
        } else if (lang == 'en') {
          prod.add(
            ProductItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['p_image']}"),
              price: RouteApi().reciprocal(element['p_price']),
              name: element['p_name'],
              onItemPressed: () => onItemPressed(element['id']),
            ),
          );
        } else if (lang == 'ar') {
          prod.add(
            ProductItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['p_image']}"),
              price: RouteApi().reciprocal(element['p_price']),
              name: element['p_name_ar'],
              onItemPressed: () => onItemPressed(element['id']),
            ),
          );
        } else if (lang == 'kuk') {
          prod.add(
            ProductItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['p_image']}"),
              price: RouteApi().reciprocal(element['p_price']),
              name: element['p_name_kr'],
              onItemPressed: () => onItemPressed(element['id']),
            ),
          );
        } else if (lang == 'per') {
          prod.add(
            ProductItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['p_image']}"),
              price: RouteApi().reciprocal(element['p_price']),
              name: element['p_name_pr'],
              onItemPressed: () => onItemPressed(element['id']),
            ),
          );
        }
      });
      setState(() {
        // prod.clear();
      });
    }
    setState(() {
      loading = false;
    });
  }

  void onItemPressed(id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewItemPage(id)),
    );
  }
}
