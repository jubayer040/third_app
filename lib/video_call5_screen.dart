import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class VideoCall5Screen extends StatefulWidget {
  const VideoCall5Screen({super.key});
  @override
  State<VideoCall5Screen> createState() => _VideoCall5ScreenState();
}

class _VideoCall5ScreenState extends State<VideoCall5Screen> {
  late WebViewController _controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => setState(() {
          loadingPercentage = 0;
        }),
        onProgress: (progress) => setState(() => loadingPercentage = progress),
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(Uri.parse(
          'https://agora-video-call-eight.vercel.app/?username=Muntasir&aptCode=SG-D-1-SG-P-33-2'));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(true);
    }
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: () async {
            if (await _controller.canGoBack()) {
              await _controller.goBack();
            } else {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.close_outlined, color: Colors.white),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/soowgood_logo.png',
          width: size.width * .4,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (await _controller.canGoForward()) {
                await _controller.goForward();
              }
            },
            icon: const Icon(Icons.forward, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
