import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewPayment extends StatefulWidget {
  final url;

  const WebviewPayment({Key key, this.url}) : super(key: key);
  @override
  _WebviewPaymentState createState() => _WebviewPaymentState();
}

class _WebviewPaymentState extends State<WebviewPayment> {
  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return WebviewScaffold(
      url: "${widget.url}",
    );
  }
}
