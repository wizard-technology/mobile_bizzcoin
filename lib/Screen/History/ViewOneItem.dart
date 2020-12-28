import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneItemView extends StatelessWidget {
  final onClick, image, name, price, date;

  const OneItemView(
      {Key key, this.onClick, this.image, this.name, this.price, this.date})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    bool _dir = _lang.getLanguage()['dir'];
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onClick,
      child: Container(
          margin: EdgeInsets.only(left: 12, right: 12, bottom: 20),
          child: Directionality(
            textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth(context) / 2.7,
                        height: screenHeight(context) / 6.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xffcecece),
                            image: DecorationImage(
                                image: NetworkImage(image), fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: screenHeight(context) / 6.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth(context) / 2.9,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                text: TextSpan(
                                  text: '$name',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    color: const Color(0xff0c0a0a),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth(context) / 2.9,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                text: TextSpan(
                                  text: '$price \$',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Container(
                //   height: screenHeight(context) / 6.5,
                //   alignment:
                //       _dir ? Alignment.bottomRight : Alignment.bottomLeft,
                //   child: Text(
                //     '$date',
                //     style: TextStyle(
                //       fontFamily: 'Roboto',
                //       fontSize: 12,
                //       color: const Color(0xffcecece),
                //       fontWeight: FontWeight.w500,
                //     ),
                //     textAlign: _dir ? TextAlign.left : TextAlign.right,
                //   ),
                // )
              ],
            ),
          )),
    );
  }
}
