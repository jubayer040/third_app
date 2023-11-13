import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const agoraUrl =
    'https://agora-video-call-eight.vercel.app/?username=Muntasir&aptCode=SG-D-1-SG-P-33-2&c=doctor ';

class VideoCall6Screen extends StatefulWidget {
  const VideoCall6Screen({super.key});
  @override
  State<VideoCall6Screen> createState() => _VideoCall6ScreenState();
}

class _VideoCall6ScreenState extends State<VideoCall6Screen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("InAppWebView"),
        actions: [
          ElevatedButton(
            child: const Icon(Icons.refresh),
            onPressed: () => webViewController?.reload(),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: Uri.parse(agoraUrl)),
                    initialOptions: InAppWebViewGroupOptions(
                      android: AndroidInAppWebViewOptions(
                        allowFileAccess: true,
                        allowContentAccess: true,
                        databaseEnabled: true,
                        domStorageEnabled: true,
                      ),
                      ios: IOSInAppWebViewOptions(),
                    ),
                    onWebViewCreated: (controller) async {
                      webViewController = controller;
                    },
                    androidOnPermissionRequest: (controller, request, s) async {
                      return PermissionRequestResponse(
                        resources: s,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                    iosOnNavigationResponse:
                        (controller, navigationResponse) async {
                      final uri = navigationResponse.response!.url;
                      if (uri != null &&
                          uri.toString().contains('https://soowgood.com/')) {
                        Navigator.pop(context);
                        return IOSNavigationResponseAction.CANCEL;
                      } else {
                        return IOSNavigationResponseAction.ALLOW;
                      }
                    },
                    onLoadResource: (controller, resource) {},
                    onLoadStart: (controller, url) {
                      if (url != null &&
                          url.toString().contains('https://soowgood.com/')) {
                        Navigator.pop(context);
                      }
                    },
                    onLoadStop: (controller, url) {
                      // Page loading finished
                      // Add click event listener to a specific element with ID "myButton"
                      // controller.evaluateJavascript(source: '''
                      //     document.getElementById("myButton").addEventListener("click", function() {
                      //       window.flutter_inappwebview.callHandler('onButtonClick', 'Button Clicked!');
                      //     });
                      // ''');
                    },
                    onLoadError: (controller, request, i, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
