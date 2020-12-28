import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionPage extends StatefulWidget {
  @override
  _TermsAndConditionPageState createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  bool loading = true;
  var _htmlData = """
<h1>Header 1</h1>
<h2>Header 2</h2>
<h3>Header 3</h3>
<h4>Header 4</h4>
<h5>Header 5</h5>
<h6>Header 6</h6>
<h3>Ruby Support:</h3>

""";
  @override
  void initState() {
    getTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];

    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: CheckInternetWidget(
        Container(
          width: screenWidth(context),
          height: screenHeight(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                          _data["Terms"],
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
                  margin:
                      EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
                  child: loading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  backgroundColor: const Color(0xfff2f3f6),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                ),
                              ),
                            )
                          ],
                        )
                      : SingleChildScrollView(
                          child: Html(
                            data: _htmlData,
                            //Optional parameters:
                            customRender: {
                              "flutter": (RenderContext context, Widget child,
                                  attributes, _) {
                                return FlutterLogo(
                                  style: (attributes['horizontal'] != null)
                                      ? FlutterLogoStyle.horizontal
                                      : FlutterLogoStyle.markOnly,
                                  textColor: context.style.color,
                                  size: context.style.fontSize.size * 5,
                                );
                              },
                            },
                            onLinkTap: (url) async {
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            onImageTap: (src) {
                              // print(src);
                            },
                            onImageError: (exception, stackTrace) {
                              // print(exception);
                            },
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

  getTerms() async {
    String url = RouteApi().routeGet(name: "terms");
    String lang = await RouteApi().getLanguage();
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Response response = await get(
      url,
      headers: headers,
    );
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      if (lang == 'kus') {
        setState(() {
          _htmlData = """${jsonDecode(body['term']['ar_article_ku'])}""";
          loading = false;
        });
      } else if (lang == 'en') {
        setState(() {
          _htmlData = """${jsonDecode(body['term']['ar_article'])}""";
          loading = false;
        });
      } else if (lang == 'kuk') {
        setState(() {
          _htmlData = """${jsonDecode(body['term']['ar_article_kr'])}""";
          loading = false;
        });
      } else if (lang == 'ar') {
        setState(() {
          _htmlData = """${jsonDecode(body['term']['ar_article_ar'])}""";
          loading = false;
        });
      } else if (lang == 'per') {
        setState(() {
          _htmlData = """${jsonDecode(body['term']['ar_article_pr'])}""";
          loading = false;
        });
      }
    }
  }
}
