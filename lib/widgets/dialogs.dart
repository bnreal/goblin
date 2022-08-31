import 'package:flutter/material.dart';

//显示指定信息提示对话框
Future<bool?> showConfirmDialog(
  context,
  tipText,
) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(tipText),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("继续"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      });
}

//显示带输入框的对话框
Future<String?> showInputDialog(
    BuildContext context,
    String tipText,
    String hintText,
    void Function(String inputValue) onConfirmClicked,
    void Function()? onCancelClicked) {
  var textFiledController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(tipText),
        content: TextField(
          controller: textFiledController,
          decoration: InputDecoration(hintText: hintText),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: onCancelClicked,
              child: const Text(
                "取消",
                style: TextStyle(color: Colors.grey),
              )),
          TextButton(
              onPressed: () => onConfirmClicked(textFiledController.text),
              child: const Text(
                "确认",
                style: TextStyle(color: Colors.green),
              ))
        ],
      );
    },
  );
}

//显示带滑块选择器的对话框，下面用到了Builder来获取context,标记element为dirty实现ui更新
Future<RangeValues?> showRangeValuesDialog(
    BuildContext context, String title, String bodyTitle, int max) {
  RangeValues currentValues = RangeValues(1, max.toDouble());
  String textStart = currentValues.start.round().toString();
  String textEnd = currentValues.end.round().toString();
  int totalSelected = 0;
  return showDialog<RangeValues>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Builder(builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bodyTitle,
                  style: const TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                const Text("拖动滑块以选择数值范围:"),
                Row(
                  children: [
                    const Text("0"),
                    RangeSlider(
                      values: currentValues,
                      min: 1.0,
                      max: max.toDouble(),
                      divisions: max,
                      labels: RangeLabels(textStart, textEnd),
                      onChanged: (values) {
                        (context as Element).markNeedsBuild();
                        currentValues = values;
                        textStart = currentValues.start.toInt().toString();
                        textEnd = currentValues.end.toInt().toString();
                        totalSelected =
                            (currentValues.end - currentValues.start + 1)
                                .toInt();
                      },
                    ),
                    Text(max.toString())
                  ],
                ),
                Text("当前选择:$textStart -- $textEnd 共$totalSelected个")
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("取消")),
            TextButton(
                onPressed: () => Navigator.of(context).pop(currentValues),
                child: const Text("确认"))
          ],
        );
      });
}

//显示加载动画对话框
showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 26.0),
                child: Text("从网络读取列表，请稍候..."),
              )
            ],
          ),
        );
      });
}
