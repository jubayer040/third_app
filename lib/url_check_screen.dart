import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlCheckScreen extends StatelessWidget {
  const UrlCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //const Expanded(child: WidgetBindingsObserverSample()),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(_url);
              if (await canLaunchUrl(url)) {
                try {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error: $e");
                }
              } else {
                Fluttertoast.showToast(msg: 'Can\'t lauch URL, Sorry!');
              }
            },
            child: const Text('Demo 4'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

const _url = //'https://pub.dev/';
    "https://agora-video-call-eight.vercel.app/?username=Muntasir&aptCode=SG-D-1-SG-P-33-2";

class WidgetBindingsObserverSample extends StatefulWidget {
  const WidgetBindingsObserverSample({super.key});
  @override
  State<WidgetBindingsObserverSample> createState() =>
      _WidgetBindingsObserverSampleState();
}

class _WidgetBindingsObserverSampleState
    extends State<WidgetBindingsObserverSample> with WidgetsBindingObserver {
  final List<AppLifecycleState> _stateHistoryList = <AppLifecycleState>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      _stateHistoryList.add(WidgetsBinding.instance.lifecycleState!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _stateHistoryList.add(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_stateHistoryList.isNotEmpty) {
      return ListView.builder(
        key: const ValueKey<String>('stateHistoryList'),
        itemCount: _stateHistoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(child: Text('state is: ${_stateHistoryList[index]}'));
        },
      );
    }

    return const Center(
        child: Text('There are no AppLifecycleStates to show.'));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
