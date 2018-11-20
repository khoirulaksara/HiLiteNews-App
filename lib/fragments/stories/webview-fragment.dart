import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MyWebviewScaffold extends StatefulWidget {
  PreferredSizeWidget appBar;
  String url;
  bool withJavascript;
  bool clearCache;
  bool clearCookies;
  bool enableAppScheme;
  String userAgent;
  bool primary;
  List<Widget> persistentFooterButtons;
  Widget bottomNavigationBar;
  bool withZoom;
  bool withLocalStorage;
  _MyWebviewScaffoldState state;

  MyWebviewScaffold(
      {Key key,
      this.appBar,
      @required this.url,
      this.withJavascript,
      this.clearCache,
      this.clearCookies,
      this.enableAppScheme,
      this.userAgent,
      this.primary: true,
      this.persistentFooterButtons,
      this.bottomNavigationBar,
      this.withZoom,
      this.withLocalStorage})
      : super(key: key);


  void changeUrl(String url) {
    state.changeUrl(url);
  }

  @override
  _MyWebviewScaffoldState createState() => new _MyWebviewScaffoldState(this.appBar, this.url, this.withJavascript, this.clearCache, this.clearCookies,
                          this.enableAppScheme, this.userAgent, this.primary, this.persistentFooterButtons, 
                          this.bottomNavigationBar, this.withZoom, this.withLocalStorage, this);
}

class _MyWebviewScaffoldState extends State<MyWebviewScaffold> {
  final webviewReference = new FlutterWebviewPlugin();
  Rect _rect;
  Timer _resizeTimer;

  PreferredSizeWidget appBar;
  String url;
  bool withJavascript;
  bool clearCache;
  bool clearCookies;
  bool enableAppScheme;
  String userAgent;
  bool primary;
  List<Widget> persistentFooterButtons;
  Widget bottomNavigationBar;
  bool withZoom;
  bool withLocalStorage;

  _MyWebviewScaffoldState(PreferredSizeWidget appBar, String url, bool withJavascript, bool clearCache, bool clearCookies,
                          bool enableAppScheme, String userAgent, bool primary, List<Widget> persistentFooterButtons, 
                          Widget bottomNavigationBar, bool withZoom, bool withLocalStorage, MyWebviewScaffold parent) {
    this.appBar = appBar;
    this.url = url;
    this.withJavascript = withJavascript;
    this.clearCache = clearCache;
    this.clearCookies = clearCookies;
    this.enableAppScheme = enableAppScheme;
    this.userAgent = userAgent;
    this.primary = primary;
    this.persistentFooterButtons = persistentFooterButtons;
    this.bottomNavigationBar = bottomNavigationBar;
    this.withZoom = withZoom;
    this.withLocalStorage = withLocalStorage;
    parent.state = this;
  }

  void changeUrl(String url) {
    this.setState(() {
      this.url = url;
    });
  }

  void initState() {
    super.initState();
    webviewReference.close();
  }

  void dispose() {
    super.dispose();
    webviewReference.close();
    webviewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_rect == null) {
      _rect = _buildRect(context);
      webviewReference.launch(widget.url,
          withJavascript: widget.withJavascript,
          clearCache: widget.clearCache,
          clearCookies: widget.clearCookies,
          enableAppScheme: widget.enableAppScheme,
          userAgent: widget.userAgent,
          rect: _rect,
          withZoom: widget.withZoom,
          withLocalStorage: widget.withLocalStorage);
    } else {
      Rect rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = new Timer(new Duration(milliseconds: 300), () {
          // avoid resizing to fast when build is called multiple time
          webviewReference.resize(_rect);
        });
      }
    }
    return new Scaffold(
        appBar: widget.appBar,
        persistentFooterButtons: widget.persistentFooterButtons,
        bottomNavigationBar: widget.bottomNavigationBar,
        body: new Center(child: new CircularProgressIndicator()));
  }

  Rect _buildRect(BuildContext context) {
    bool fullscreen = widget.appBar == null;

    final mediaQuery = MediaQuery.of(context);
    final topPadding = widget.primary ? mediaQuery.padding.top : 0.0;
    num top =
        fullscreen ? 0.0 : widget.appBar.preferredSize.height + topPadding;

    num height = mediaQuery.size.height - top;

    if (widget.bottomNavigationBar != null) {
      height -=
          56.0; // todo(lejard_h) find a way to determine bottomNavigationBar programmatically
    }

    if (widget.persistentFooterButtons != null) {
      height -=
          53.0; // todo(lejard_h) find a way to determine persistentFooterButtons programmatically
    }

    return new Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }
}