import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ViewItemBuyPgae extends StatefulWidget {
  final name, price, bizz, date, info, image;

  const ViewItemBuyPgae(
      {Key key,
      this.name,
      this.price,
      this.bizz,
      this.date,
      this.info,
      this.image})
      : super(key: key);
  @override
  _ViewItemBuyPgaeState createState() => _ViewItemBuyPgaeState(
      this.name, this.price, this.bizz, this.date, this.info, this.image);
}

class _ViewItemBuyPgaeState extends State<ViewItemBuyPgae> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final name, price, bizz, date, info, image;

  _ViewItemBuyPgaeState(
      this.name, this.price, this.bizz, this.date, this.info, this.image);

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
        backgroundColor: const Color(0xfff2f3f6),
        key: _scaffoldkey,
        body: loading == false
            ? Container(
                width: screenWidth(context),
                height: screenHeight(context),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: screenHeight(context) / 20),
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
                            width: _dir ? 5 : 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth(context) / 1.2,
                    height: screenHeight(context) / 5,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffcecece),
                      image: DecorationImage(
                          image: NetworkImage(image) ??
                              AssetImage("assets/BizzPaymentlogo.png"),
                          fit: BoxFit.fill),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SelectableText(
                          //   "Coming Soon ..",
                          //   style: TextStyle(
                          //     fontFamily: 'Roboto',
                          //     fontSize: 20,
                          //     color: const Color(0xff0c0a0a),
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // SelectableText(
                          //   "Coming Soon ..",
                          //   style: TextStyle(
                          //     fontFamily: 'Roboto',
                          //     fontSize: 14,
                          //     color: const Color(0xff0c0a0a),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: screenWidth(context) / 1.2,
                      margin: EdgeInsets.only(top: 10),
                      child: Directionality(
                          textDirection:
                              _dir ? TextDirection.ltr : TextDirection.rtl,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    '$name',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 22,
                                      color: const Color(0xff0c0a0a),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text(
                                  "$date",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: const Color(0xff0c0a0a),
                                  ),
                                )
                              ]))),
                  Container(
                    width: screenWidth(context) / 1.2,
                    margin: EdgeInsets.only(top: 40),
                    child: Directionality(
                      textDirection:
                          _dir ? TextDirection.ltr : TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xffcecece),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '1',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  color: const Color(0xff0c0a0a),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                color: const Color(0xffcecece),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '$price\$',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  color: const Color(0xff0c0a0a),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                color: const Color(0xffcecece),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '${(price / bizz).toStringAsFixed(2)} Bizz',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  color: const Color(0xff0c0a0a),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth(context) / 1.2,
                    margin: EdgeInsets.only(top: 40),
                    alignment:
                        _dir ? Alignment.centerLeft : Alignment.centerRight,
                    child: Text(
                      _data["RedeemCode"],
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        color: const Color(0xff0c0a0a),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: screenWidth(context) / 1.2,
                    height: screenHeight(context) / 5,
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(
                              "$info",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                color: const Color(0xff0c0a0a),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ])))
            : Container(
                width: screenWidth(context),
                height: screenHeight(context),
                color: Colors.white,
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/progress.gif"))),
                  ),
                ),
              ));
  }

  //---------------------Methods---------------------//
  bool loading = false;
  void onCopyPressed(BuildContext context, _data) {
    Clipboard.setData(new ClipboardData(text: '1353df234dfs34')).then((value) {
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(_data['CopiedToClipboard']),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      ));
    });
  }
}
