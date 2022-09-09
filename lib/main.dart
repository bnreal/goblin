import 'package:flutter/material.dart';

import 'exports.dart';
import 'handler/handler.dart';

import 'list_header.dart';
import 'list_body.dart';
import 'bar_bottom.dart';
import 'button_float.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Goblin Network Collector",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _tasks = <Task>[];
  String dirPath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.green,
          elevation: 0,
          title: GoblinTextField(
              hintText: "请输入url...", onSubmitted: _onUrlSumbitted)),
      body: Column(
        children: [
          const ListHeaderActionBar(),
          Expanded(
            child: TaskList(
              tasks: _tasks,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedFloatActionButton(
          onClicked: () => eventBus.fire(StartAllEvent())),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.blueGrey,
          child: IconTheme(
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: GoblinBottomBar(onClearAll: _onClearAll))),
    );
  }

  ///顶部文本框输完按下回车时,如果是视频地址直接加入下方列表
  ///如果是列表，连接读取列表信息，弹出对话框供用户选择要下载的视频数量,读取列表中的对应
  ///资源加入下方列表
  void _onUrlSumbitted(String url) async {
    if (url.isListUrl()) {
      showLoadingDialog(context);
      Handler handler = Handler(url);

      await handler.createPage().then((page) async {
        Navigator.of(context).pop();
        await addTasksWithUserChoice(page);
      });
    } else {
      var task = Task(url, title: url);
      task.audioOnly = url.isYoutubeUrl() ? Global.audioOnly : url.isAudio();
      _tasks.add(task);
    }
    setState(() {
      eventBus.fire(TaskListChangeEvent(_tasks.length));
    });
  }

  //读取list url后弹窗选择集数统一代码
  Future<void> addTasksWithUserChoice(WebPage page) async {
    if (page.fileLinks.isEmpty) return;
    await showRangeValuesDialog(context, "选择下载数量",
            "${page.title} 共${page.fileLinks.length}集", page.fileLinks.length)
        .then((rangeValues) async {
      if (rangeValues == null) return; //如果未选择做取消下载处理
      int start = rangeValues.start.toInt() - 1;
      int end = rangeValues.end.toInt();
      for (final Link link in page.fileLinks.getRange(start, end)) {
        _tasks.add(Task(link.url,
            title: link.title,
            fileType: link.fileType,
            audioOnly: link.isAudio));
      }
    });
  }

  ///当[清空列表]按钮按下时
  void _onClearAll() {
    setState(() {
      _tasks.clear();
      eventBus.fire(TaskListChangeEvent(_tasks.length));
    });
  }
}
