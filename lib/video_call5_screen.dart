import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class VideoCall5Screen extends StatefulWidget {
  const VideoCall5Screen({super.key});
  @override
  State<VideoCall5Screen> createState() => _VideoCall5ScreenState();
}

class _VideoCall5ScreenState extends State<VideoCall5Screen> {
  late WebViewController _webController;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{
          PlaybackMediaTypes.audio,
          PlaybackMediaTypes.video
        },
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller = WebViewController(
      onPermissionRequest: (request) => request.grant(),
    );
    controller
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          if (url.contains('https://soowgood.com/')) {
            Navigator.pop(context);
          }
          setState(() => loadingPercentage = 0);
        },
        onProgress: (progress) => setState(() => loadingPercentage = progress),
        onPageFinished: (url) => setState(() => loadingPercentage = 100),
      ))
      ..loadRequest(Uri.parse(
          'https://agora-video-call-eight.vercel.app/?username=Muntasir&aptCode=SG-D-1-SG-P-33-2'));

    _webController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_outlined, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webController),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
