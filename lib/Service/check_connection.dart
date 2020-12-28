import 'package:bizzcoin_app/Enum/connectivty_status.dart';
import 'package:bizzcoin_app/Service/NoInternetPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckInternetWidget extends StatefulWidget {
  final widget;
  CheckInternetWidget(this.widget);

  @override
  _CheckInternetWidgetState createState() => _CheckInternetWidgetState();
}

class _CheckInternetWidgetState extends State<CheckInternetWidget> {
  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == null) {
      connectionStatus = ConnectivityStatus.WiFi;
    }
    if (connectionStatus == ConnectivityStatus.WiFi) {
      return widget.widget;
    }
    if (connectionStatus == ConnectivityStatus.Cellular) {
      return widget.widget;
    }
    if (connectionStatus == ConnectivityStatus.Offline) {
      return NoInternetPage();
    }
    return NoInternetPage();
  }
}
