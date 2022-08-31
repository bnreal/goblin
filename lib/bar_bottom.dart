import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import 'global.dart';
import 'widgets/dialogs.dart';

class GoblinBottomBar extends StatefulWidget {
  const GoblinBottomBar({Key? key, required, required this.onClearAll})
      : super(key: key);

  final VoidCallback onClearAll;
  @override
  State<GoblinBottomBar> createState() => _GoblinBottomBarState();
}

class _GoblinBottomBarState extends State<GoblinBottomBar> {
  String dirPath = "";
  String toolTipTitle = "过滤文件名中的特殊符号:";

  @override
  void initState() {
    super.initState();
  }

  //设定文件夹按钮按下时的回调
  void _onFolderSettingClicked() async {
    final path = await getDirectoryPath();
    if (path != null) {
      setState(() {
        dirPath = path;
        Global.dirPath = path;
      });
    }
  }

  //添加特殊符号按钮按下时 -- 弹出输入特殊符号对话框
  void _onSpecialSymbolClicked() async {
    debugPrint(context.toString());
    await showInputDialog(context, "新增特殊符号", "请输入需要过滤的特殊符号",
        _onDialogConfirmClicked, _onDialogCancelClicked);
  }

  //添加特殊符号对话框中的确认按下时的回调
  void _onDialogConfirmClicked(inputValue) {
    if (inputValue != null) {
      Global.charsForReplace.add(inputValue);
    }
    setState(() {
      Navigator.pop(context);
    });
  }

  //添加特殊符号对话框取消按钮按下时的回调
  void _onDialogCancelClicked() {
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            tooltip: '文件夹设定',
            icon: const Icon(Icons.folder),
            onPressed: _onFolderSettingClicked),
        Text(
          dirPath,
          style: const TextStyle(color: Colors.white),
        ),
        const Spacer(),
        IconButton(
            tooltip: toolTipTitle + Global.charsForReplace.toString(),
            onPressed: _onSpecialSymbolClicked,
            icon: const Icon(Icons.emoji_emotions)),
        const Padding(padding: EdgeInsets.all(20)),
        IconButton(
          tooltip: '全部清除',
          icon: const Icon(Icons.cleaning_services),
          onPressed: widget.onClearAll,
        ),
        const Padding(padding: EdgeInsets.all(10)),
      ],
    );
  }
}
