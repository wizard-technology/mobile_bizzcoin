import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget {
  Cart(
      {this.name,
      this.finalPrice,
      this.id,
      this.bizzPrice,
      this.countItem,
      this.itemPrice,
      this.onMinusPressed,
      this.onPlusPressed,
      this.onXPressed,
      this.image});
  var name;
  var image;
  var id, countItem;
  var finalPrice, itemPrice, bizzPrice;
  var onXPressed, onMinusPressed, onPlusPressed;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    bool _dir = _lang.getLanguage()['dir'];
    return CheckInternetWidget(
      Container(
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    width: screenWidth(context) / 1.2,
                    height: screenHeight(context) / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffcecece),
                      image: DecorationImage(
                          image: widget.image, fit: BoxFit.fill),
                    ),
                    child: Center(
                      child: loading
                          ? Container(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                backgroundColor: const Color(0xffcecece),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Positioned(
                      right: _dir ? 0 : null,
                      left: _dir ? null : 0,
                      top: 0,
                      child: IconButton(
                          icon: Icon(
                            FeatherIcons.x,
                            color: Colors.white,
                          ),
                          onPressed: widget.onXPressed))
                ],
              ),
            ),
            Container(
                width: screenWidth(context) / 1.2,
                margin: EdgeInsets.only(top: 15),
                alignment: _dir ? Alignment.centerLeft : Alignment.centerRight,
                child: !loading
                    ? Text(
                        '${widget.name}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          color: const Color(0xff0c0a0a),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : loadingWidget(context, screenWidth(context) / 2, 13)),
            Container(
              width: screenWidth(context) / 1.2,
              margin: EdgeInsets.only(top: 25),
              child: Directionality(
                textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !loading
                        ? Text(
                            '${widget.itemPrice.toStringAsFixed(2)}\$',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          )
                        : loadingWidget(context, screenWidth(context) / 3, 13),
                    Container(
                      child: Directionality(
                          textDirection:
                              _dir ? TextDirection.ltr : TextDirection.rtl,
                          child: Row(
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: widget.onMinusPressed,
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffcecece),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      FeatherIcons.minus,
                                      size: 17,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              !loading
                                  ? Text(
                                      '${widget.countItem}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  : loadingWidget(context, 20, 13),
                              SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: widget.onPlusPressed,
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffcecece),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      FeatherIcons.plus,
                                      size: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth(context) / 1.2,
              margin: EdgeInsets.only(top: 30),
              child: Directionality(
                textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !loading
                        ? Text(
                            '${widget.finalPrice.toStringAsFixed(2)}\$',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          )
                        : loadingWidget(context, screenWidth(context) / 3, 13),
                    !loading
                        ? Text(
                            '${widget.bizzPrice.toStringAsFixed(2)} Bizz',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          )
                        : loadingWidget(context, screenWidth(context) / 4, 13),
                  ],
                ),
              ),
            ),
            Container(
                width: screenWidth(context) / 1.2,
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Divider(
                  color: Colors.black,
                ))
          ],
        ),
      ),
    );
  }

//-----------------------Widget-------------------------//
  bool loading = false;
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
}
