import 'package:flutter/material.dart';
import 'events.dart';

class AnimatedFloatActionButton extends StatefulWidget {
  const AnimatedFloatActionButton({Key? key, required this.onClicked})
      : super(key: key);
  final VoidCallback? onClicked;

  @override
  State<AnimatedFloatActionButton> createState() =>
      _AnimatedFloatActionButtonState();
}

class _AnimatedFloatActionButtonState extends State<AnimatedFloatActionButton> {
  bool isDownloading = false;
  String statusText = "";
  @override
  void initState() {
    super.initState();
    eventBus.on<ListDownloadingEvent>().listen((event) {
      setState(() {
        isDownloading = event.isDownloading;
        statusText = event.waitingCount.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: isDownloading ? "下载中..." : "下载全部",
      onPressed: isDownloading ? null : widget.onClicked,
      backgroundColor: Colors.blueGrey,
      child: isDownloading
          ? _buildTextProgressIndicator(context)
          : const Icon(Icons.download),
    );
  }

  Widget _buildTextProgressIndicator(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Center(child: CircularProgressIndicator()),
        Center(child: Text(statusText))
      ],
    );
  }
}
