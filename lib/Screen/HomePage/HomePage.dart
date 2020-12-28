import 'dart:convert';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/AgentProfile/AgentProfilePage.dart';
import 'package:bizzcoin_app/Screen/HomePage/CompanyItem.dart';
import 'package:bizzcoin_app/Screen/HomePage/GroupedItem.dart';
import 'package:bizzcoin_app/Screen/HomePage/Subcategories.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';

import 'ProductItem.dart';
import 'ViewItemPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nextPage = RouteApi().routeGet(name: "home");
  List data = [];
  List<ProductItem> prod = [];
  List<GroupedItem> grouped = [];
  List<CompanyItem> comp = [];
  List searchs = [];

//----------------------------translator-------------------------------//

//----------------------------overrides-------------------------------//
  @override
  void initState() {
    super.initState();

    // _searchController.addListener(() {
    //   if (_searchController.text.isEmpty) {
    //     setState(() {
    //       prod.clear();
    //       nextPage = RouteApi().routeGet(name: "home");
    //       // ignore: unnecessary_statements
    //       nextPage == null ? () {} : _getProduct(nextPage);
    //       _checkNoResultFound = false;
    //     });
    //   }
    // });

    // ignore: unnecessary_statements
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
    PushNotificationService(context: context).initialise();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageService>(context);
    Map _data = _language.getLanguage()['data'];
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
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 15, bottom: 15),
                      child: Directionality(
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        child: Container(
                          width: screenWidth(context),
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xffcecece),
                          ),
                          child: TextField(
                            textAlign: _dir ? TextAlign.left : TextAlign.right,
                            controller: _searchController,
                            onChanged: (value) {
                              this.onSearchChanged(context, value);
                            },
                            onSubmitted: (value) =>
                                this.onSearchChanged(context, value),
                            onTap: () => this.onTapTextFiled(context),
                            autocorrect: false,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 8, right: 8, top: _dir ? 13 : 8),
                              hintText: _data["Search"],
                              hintStyle: GoogleFonts.roboto(fontSize: 15),
                              suffixIcon: _dir
                                  ? GestureDetector(
                                      child: Icon(
                                        FeatherIcons.search,
                                        color: Colors.black,
                                      ),
                                    )
                                  : null,
                              prefixIcon: !_dir
                                  ? GestureDetector(
                                      child: Icon(
                                        FeatherIcons.search,
                                        color: Colors.black,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: screenWidth(context),
                        child: Directionality(
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Directionality(
                                textDirection: _dir
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                child: !loading
                                    ? Row(
                                        children: [
                                          Container(
                                            height: 30.0,
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            margin: EdgeInsets.only(
                                              left: _dir
                                                  ? (checkIfIpad(context) ==
                                                          true
                                                      ? screenWidth(context) /
                                                          16
                                                      : 10)
                                                  : 0,
                                              right: _dir
                                                  ? 0
                                                  : (checkIfIpad(context) ==
                                                          true
                                                      ? screenWidth(context) /
                                                          16
                                                      : 10),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                              color: _onTrendingTap == true
                                                  ? const Color(0xff0c0a0a)
                                                  : const Color(0xfff2f3f6),
                                            ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () => this
                                                  .onTrendingPressed(context),
                                              child: Center(
                                                child: Text(
                                                  _data["Trending"],
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    color:
                                                        _onTrendingTap == true
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            margin: EdgeInsets.only(
                                                left: 0, right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                              color: _onGroupedTap == true
                                                  ? const Color(0xff0c0a0a)
                                                  : const Color(0xfff2f3f6),
                                            ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: onGroupedPress,
                                              child: Center(
                                                child: Text(
                                                  _data["Grouped"],
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    color: _onGroupedTap == true
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            margin: EdgeInsets.only(
                                                left: 0, right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                              color: _onAgentsTap == true
                                                  ? const Color(0xff0c0a0a)
                                                  : const Color(0xfff2f3f6),
                                            ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () =>
                                                  this.onAgentsPressed(context),
                                              child: Center(
                                                child: Text(
                                                  _data["Agents"],
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    color: _onAgentsTap == true
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        width: screenWidth(context),
                                        margin: EdgeInsets.only(
                                            left: _dir ? 10 : 0,
                                            right: !_dir ? 10 : 0),
                                        child: Directionality(
                                            textDirection: _dir
                                                ? TextDirection.ltr
                                                : TextDirection.rtl,
                                            child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Directionality(
                                                    textDirection: _dir
                                                        ? TextDirection.ltr
                                                        : TextDirection.rtl,
                                                    child: Row(
                                                      children: [
                                                        for (var i = 0;
                                                            i < 3;
                                                            i++)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: loadingWidget(
                                                                context,
                                                                screenWidth(
                                                                        context) /
                                                                    6,
                                                                13),
                                                          )
                                                      ],
                                                    ))))),
                              ),
                            ))),
                    _onAgentsTap == false && _checkNoResultFound == false
                        ? Container(
                            width: screenWidth(context),
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              left: _dir ? 6 : 0,
                              right: _dir ? 0 : 6,
                            ),
                            child: !loading
                                ? !isTrendingOrGroupedEmpty
                                    ? Wrap(
                                        alignment: WrapAlignment.start,
                                        textDirection: _dir
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        children: [...prod, ...grouped],
                                      )
                                    : Container(
                                        height: screenHeight(context) - 270,
                                        child: Center(
                                          child: Text(
                                            _data["Empty"],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      )
                                : Container(
                                    width: screenWidth(context),
                                    height: screenHeight(context) / 1.6,
                                    child: Center(
                                        child: Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            const Color(0xfff2f3f6),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.grey),
                                      ),
                                    )),
                                  ),
                          )
                        : _checkNoResultFound == false
                            ? !loading
                                ? !isAgentEmpty
                                    ? buildAgents(context, _data, _dir)
                                    : Container(
                                        height: screenHeight(context) - 270,
                                        child: Center(
                                          child: Text(
                                            _data["Empty"],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      )
                                : Container(
                                    width: screenWidth(context),
                                    height: screenHeight(context) / 1.6,
                                    child: Center(
                                        child: Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            const Color(0xfff2f3f6),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.grey),
                                      ),
                                    )),
                                  )
                            : noResultFound(context, _dir, _data)
                  ],
                ))),
      ),
    );
  }

  //---------------------Widgets---------------------//

  Widget buildAgents(BuildContext context, _data, _dir) {
    return Container(
      width: screenWidth(context),
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [...comp],
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

  bool loading = true;
  Widget loadingWidget(BuildContext context, width, height) {
    return SkeletonAnimation(
      child: Container(
        width: double.parse(width.toString()),
        height: double.parse(height.toString()),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey[300]),
      ),
    );
  }

  //---------------------Methods---------------------//
  TextEditingController _searchController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _checkNoResultFound = false;
  bool _onTrendingTap = true;
  bool _onAgentsTap = false;
  bool _onGroupedTap = false;

  bool isTrendingOrGroupedEmpty = false;
  bool isAgentEmpty = false;

  void onTrendingPressed(BuildContext context) {
    prod.clear();
    _getProduct(RouteApi().routeGet(name: "home"));
    setState(() {
      _onTrendingTap = true;
      _onAgentsTap = false;
      _onGroupedTap = false;
    });
  }

  void onAgentsPressed(BuildContext context) {
    comp.clear();
    getCompany();
    setState(() {
      _onTrendingTap = false;
      _onAgentsTap = true;
      _onGroupedTap = false;
    });
  }

  void onItemPressed(id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewItemPage(id)),
    );
  }

  void onApplyFilterPressed(BuildContext context) {}

  void onTapTextFiled(BuildContext context) {
    setState(() {
      _onTrendingTap = true;
      _onAgentsTap = false;
      _onGroupedTap = false;
      comp.clear();
      grouped.clear();
    });
  }

  void onSearchChanged(BuildContext context, String value) async {
    setState(() {
      grouped.clear();

      prod.clear();
      loading = true;
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Response response = await get(
        RouteApi().routeGet(name: "onSearch") + value.toString(),
        headers: headers);
    String lang = await RouteApi().getLanguage();
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    if (statusCode == 200 && loading) {
      List product = body['product']['data'];
      nextPage = body['product']['next_page_url'];
      if (product.isEmpty) {
        _checkNoResultFound = true;
      } else {
        _checkNoResultFound = false;
      }
      product.forEach((element) {
        if (lang == 'en') {
          prod.add(
            ProductItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['p_image']}"),
              price: RouteApi().reciprocal(element['p_price']),
              name: element['p_name'],
              onItemPressed: () => onItemPressed(element['id']),
            ),
          );
        } else if (lang == 'kur') {
          prod.add(
            ProductItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['p_image']}"),
              price: RouteApi().reciprocal(element['p_price']),
              name: element['p_name_ku'],
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
        }
      });
      setState(() {
        loading = false;
      });
    }
  }

  void onGroupedPress() async {
    setState(() {
      loading = true;
      grouped.clear();
      prod.clear();
      comp.clear();
      _onTrendingTap = false;
      _onAgentsTap = false;
      _onGroupedTap = true;
    });
    String url = RouteApi().routeGet(name: "types");
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    List category = body['type'];
    String lang = await RouteApi().getLanguage();
    if (statusCode == 200) {
      category.forEach((element) {
        if (lang == 'kus') {
          grouped.add(
            GroupedItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['t_image']}"),
              name: element['t_name_ku'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['t_name_ku']),
            ),
          );
        } else if (lang == 'en') {
          grouped.add(
            GroupedItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['t_image']}"),
              name: element['t_name'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['t_name']),
            ),
          );
        } else if (lang == 'ar') {
          grouped.add(
            GroupedItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['t_image']}"),
              name: element['t_name_ar'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['t_name_ar']),
            ),
          );
        } else if (lang == 'kuk') {
          grouped.add(
            GroupedItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['t_image']}"),
              name: element['t_name_kr'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['t_name_kr']),
            ),
          );
        } else if (lang == 'per') {
          grouped.add(
            GroupedItem(
              image:
                  NetworkImage("${RouteApi().storageUrl}${element['t_image']}"),
              name: element['t_name_pr'],
              onItemPressed: () =>
                  onItemGroup(element['id'], element['t_name_pr']),
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
        builder: (context) => Subcategories(id: id, name: name),
      ),
    );
  }

  void onAgentPressed(index, elm, city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgentProfilePage(
          address: city + ', ' + elm['co_address'],
          id: elm['id'],
          com: elm['co_user'],
          image: elm['co_image'] == null
              ? null
              : "${RouteApi().storageUrl}${elm['co_image']}",
          information: elm['co_info'],
          name: elm['co_name'],
          phone: elm['co_phone'],
        ),
      ),
    );
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
        grouped.clear();
      });
    }
    setState(() {
      if (prod.length <= 0) {
        isTrendingOrGroupedEmpty = true;
      }
      loading = false;
    });
  }

  void getCompany() async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    String lang = await RouteApi().getLanguage();

    Response response =
        await get(RouteApi().routeGet(name: "company"), headers: headers);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    List company = body['company'];
    if (statusCode == 200) {
      String city = '';

      int i = 1;
      company.forEach((element) {
        if (lang == 'kus') {
          city = element['city']['ct_name_ku'];
        } else if (lang == 'en') {
          city = element['city']['ct_name'];
        } else if (lang == 'ar') {
          city = element['city']['ct_name_ar'];
        } else if (lang == 'kuk') {
          city = element['city']['ct_name_kr'];
        } else if (lang == 'per') {
          city = element['city']['ct_name_pr'];
        }
        comp.add(
          CompanyItem(
            index: i,
            name: element['company']['co_name'],
            onClick: () => onAgentPressed(i, element['company'], city),
            image: element['company']['co_image'] == null
                ? null
                : "${RouteApi().storageUrl}${element['company']['co_image']}",
          ),
        );
        i++;
      });
      setState(() {
        if (comp.length <= 0) {
          isAgentEmpty = true;
        }
        loading = false;
      });
    }
  }
}
