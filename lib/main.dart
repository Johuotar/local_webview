import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

InAppLocalhostServer localhostServer = new InAppLocalhostServer();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localhostServer.start();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Title, it works',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController
      webView; //late keyword which will tell Dart that you are going to initialize the variable at some other point before using it.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await webView.canGoBack()) {
          webView.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse("http://localhost:8080/assets/index.html")),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
              ),
            ),
          )
        ])),
      ),
    );
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }
}
