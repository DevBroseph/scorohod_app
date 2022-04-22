import 'package:flutter/material.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:webviewx/webviewx.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key, required this.title, required this.url})
      : super(key: key);

  final String title;
  final String url;

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        foregroundColor: red,
        // expandedHeight: 210,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: red,
          ),
        ),
      ),
      body: WebViewX(
        initialContent: widget.url,
        initialSourceType: SourceType.url,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
