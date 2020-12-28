import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatelessWidget {
  final onClick, icon, title, datetime;

  const NotificationItem(
      {Key key, this.onClick, this.icon, this.title, this.datetime})
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
        width: screenWidth(context),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Directionality(
          textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
          child: Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                  color: const Color(0xfff9bf2d),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: screenWidth(context) - 90,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '$title',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        )),
                    Container(
                      child: Text(
                        '$datetime',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          color: const Color(0xffcecece),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
