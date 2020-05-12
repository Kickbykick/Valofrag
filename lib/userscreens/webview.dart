import 'package:flutter/material.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebviewPage extends StatefulWidget {
  final String webViewName;
  final String websiteLink;

  WebviewPage({this.webViewName, this.websiteLink});

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        //backgroundColor: Colors.black,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Constants.WineColor),
            onPressed: () => Navigator.of(context).pop(),
          ), 
          backgroundColor: Colors.black,
          title: Text(widget.webViewName, style: TextStyle(color: Constants.WineColor),),
 
        ),
        body: WebView(
          initialUrl:  widget.websiteLink,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
       // floatingActionButton: _bookmarkButton(),
      ),
    );
  }
}


class WebViewTabView extends StatefulWidget {
  final String websiteLink;

  WebViewTabView({ this.websiteLink});

  @override
  _WebViewTabViewState createState() => _WebViewTabViewState();
}

class _WebViewTabViewState extends State<WebViewTabView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WebView(
          initialUrl: widget.websiteLink,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        );
  }
} 