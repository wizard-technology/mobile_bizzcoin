import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavorateItem extends StatelessWidget {
  FavorateItem({
    @required this.id,
    @required this.onHeartPressed,
    @required this.onItemPressed,
    @required this.name,
    this.image,
  });
  final int id;
  final String name;
  final image;
  final Function onItemPressed, onHeartPressed;
  @override
  Widget build(BuildContext context) {
    return CheckInternetWidget(
      Container(
        margin: EdgeInsets.all(5),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onItemPressed,
          child: Column(
            children: [
              Container(
                width: checkIfIpad(context) == true
                    ? screenWidth(context) / 3.5
                    : screenWidth(context) / 2.2,
                height: checkIfIpad(context) == true ? 120 : 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                    image: DecorationImage(
                        image:
                            image ?? AssetImage("assets/BizzPaymentlogo.png"),
                        fit: BoxFit.fill)),
              ),
              Container(
                width: checkIfIpad(context) == true
                    ? screenWidth(context) / 3.5
                    : screenWidth(context) / 2.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: const Color(0xff0c0a0a),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.black,
                        ),
                        onPressed: onHeartPressed)
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
