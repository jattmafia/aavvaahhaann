import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends HookWidget {
  const WebPage({super.key, required this.entry});

  final MapEntry entry;

  static const route = '/web';
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);

    final controller = useRef(WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              loading.value = false;
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(entry.value)));

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: WebViewWidget(controller: controller.value),
          ),
          if (loading.value)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text(entry.key),
            ),
          ),
        ],
      ),
    );
  }
}
