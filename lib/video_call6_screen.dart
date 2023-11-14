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
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF6FF),
        elevation: 10,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_outlined),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_document),
            onPressed: _showModalBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => webViewController?.reload(),
          ),
          const SizedBox(width: 10),
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
                      ios: IOSInAppWebViewOptions(
                        disallowOverScroll: true,
                      ),
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
                    onLoadStart: (controller, url) {
                      if (url != null &&
                          url.toString().contains('https://soowgood.com/')) {
                        Navigator.pop(context);
                      }
                    },
                    onLoadError: (controller, request, i, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() => _progress = progress / 100);
                    },
                  ),
                  // progress indicatior
                  _progress < 1.0
                      ? LinearProgressIndicator(value: _progress)
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: DraggableScrollableSheet(
            initialChildSize: .5,
            minChildSize: .5,
            maxChildSize: 1,
            builder: (_, controller) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      // titlte
                      Center(
                        child: Text(
                          "Prescription",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TextField(),
                      const SizedBox(height: 20),

                      ...List.generate(
                        15,
                        (index) => Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: ListTile(
                            leading: Text('${index + 1}.'),
                            title: const Text(
                                'Hili - Bili, Hope yaa\' doing well!'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    webViewController!.clearCache();
    super.dispose();
  }
}
