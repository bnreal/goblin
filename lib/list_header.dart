import 'package:flutter/material.dart';
import 'global.dart';
import 'events.dart';
import 'widgets/dropdown.dart';
import 'widgets/checkboxes.dart';

class ListHeaderActionBar extends StatefulWidget {
  const ListHeaderActionBar({Key? key}) : super(key: key);

  @override
  State<ListHeaderActionBar> createState() => _ListHeaderActionBarState();
}

class _ListHeaderActionBarState extends State<ListHeaderActionBar> {
  final dropDownItemTexts = <String>["1", "3", "5", "8", "10"];
  final initIndex = 2; //dropDown初始值在列表中的位置
  int taskCount = 0;
  @override
  void initState() {
    super.initState();
    //初始化一下Global里的值，使其与dropDown里面的保持一致
    Global.maxDownloadingCount = int.parse(dropDownItemTexts[initIndex]);

    eventBus.on<TaskListChangeEvent>().listen((event) {
      setState(() {
        taskCount = event.taskCount;
      });
    });

    eventBus.on<ListDownloadingEvent>().listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      verticalDirection: VerticalDirection.up, //设定下面两个参数，使得子组件垂直方向底线对齐。
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GoblinCheckbox(
          label: "单音频",
          onChanged: (value) {
            Global.audioOnly = value;
            eventBus.fire(GlobalAudioOnlyEvent(value));
          },
        ),
        const Padding(padding: EdgeInsets.all(20)),
        GoblinDropDown(
          dropDownItemTexts: dropDownItemTexts,
          initIndex: initIndex,
          onChanged: ((String value) {
            Global.maxDownloadingCount = int.parse(value);
          }),
        ),
        const Padding(padding: EdgeInsets.all(20)),
        Text("总任务数: $taskCount"),
      ],
    );
  }
}
