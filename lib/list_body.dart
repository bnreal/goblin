import 'package:flutter/material.dart';

import 'handler/handler.dart';
import 'exports.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key, required this.tasks}) : super(key: key);

  final List<Task> tasks;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          Task task = widget.tasks[index];
          return ListTile(
              key: Key(index.toString()),
              //标识视频或音频文件
              leading: Icon(
                task.audioOnly
                    ? Icons.audio_file_rounded
                    : Icons.movie_creation_outlined,
                color: Colors.blueGrey,
              ),
              //标题--url对应的文件title
              title: Text(
                "${index + 1} - ${task.title}",
                style: const TextStyle(color: Colors.blue),
              ),
              //副标题 -- url
              subtitle: Text(task.url),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  //标识是否单音频
                  IconButton(
                      tooltip: task.audioOnly ? "只下载音频" : "下载音视频",
                      onPressed: () {
                        if (task.status == Status.waiting) {
                          task.audioOnly = !task.audioOnly;
                          updateListTileUI(index, task);
                        }
                      },
                      icon: Icon(
                        Icons.audio_file,
                        color: task.audioOnly ? Colors.pink[300] : Colors.grey,
                      )),
                  const Padding(padding: EdgeInsets.all(40)),
                  //动作按钮,点击下载
                  OutlinedButton.icon(
                      icon: Icon(
                        Status.statusIcons[task.status],
                        color: Status.statusColors[task.status],
                      ),
                      label: Text(
                        task.status,
                        style:
                            TextStyle(color: Status.statusColors[task.status]),
                      ),
                      onPressed: () {
                        _onActionButtonClicked(index, task);
                      }),
                  //删除本条目
                  IconButton(
                      tooltip: "删除本条目",
                      onPressed: () {
                        setState(() {
                          widget.tasks.removeAt(index);
                          eventBus
                              .fire(TaskListChangeEvent(widget.tasks.length));
                        });
                      },
                      icon: (const Icon(Icons.delete)))
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
            thickness: 0.2,
            indent: 12.0,
            endIndent: 12.0,
          );
        },
        itemCount: widget.tasks.length);
  }

  @override
  void initState() {
    super.initState();
    //监听由FloatActionButton触发的下载全部事件，先检查文件夹设定
    //开始下载后，先检查每条的状态，如果不在waiting,则不做响应
    eventBus.on<StartAllEvent>().listen((event) async {
      bool goAhead = await checkDirPath();
      if (!goAhead) return;
      int lastStartIndex = 0; //相当于游标，标示列表执行进度
      int finishedCount = 0; //已完成总数
      //count--同时运行的任务数
      int taskCount = widget.tasks.length < Global.maxDownloadingCount
          ? widget.tasks.length
          : Global.maxDownloadingCount;

      //初始启动n个异步下载任务，每一个任务完成时将总list中的index加1，然后开始下载,该
      //下载完成后再次调用onFinished,重复上面的操作(递归)，从而实现自动下载完整个列表，
      //并能限定同时下载的数量
      void onFinished() {
        finishedCount++;

        //完成总数=列表总数时，说明已全部下载完成，反之：正在下载
        eventBus.fire(ListDownloadingEvent(finishedCount != widget.tasks.length,
            widget.tasks.length - finishedCount));
        lastStartIndex++;
        if (lastStartIndex < widget.tasks.length) {
          startDownload(lastStartIndex, widget.tasks[lastStartIndex],
              onFinished: onFinished);
        }
      }

      //lastStartIndex负责跟踪列表已开启任务的位置
      lastStartIndex = taskCount - 1;

      eventBus.fire(ListDownloadingEvent(true, widget.tasks.length));
      //点击下载全部后，根据列表长度和最大同时下载数量设定来开启异步任务
      for (int i = 0; i < taskCount; i++) {
        startDownload(i, widget.tasks[i], onFinished: onFinished);
      }
    });

    // 监听顶部[单音频]复选框选择事件
    eventBus.on<GlobalAudioOnlyEvent>().listen((event) {
      Global.audioOnly = event.audioOnly;
      debugPrint(event.audioOnly.toString());
      for (var task in widget.tasks) {
        task.audioOnly = event.audioOnly;
      }
      setState(() {});
    });
  }

  //更新单个list item 界面
  void updateListTileUI(int index, Task task) {
    setState(() {
      widget.tasks[index] = task;
    });
  }

  ///当ListTile的Trailing button按下时
  void _onActionButtonClicked(int index, Task task) async {
    //如果是[完成/出错/正在连接/正在下载] 状态，不做响应。
    if (task.status != Status.waiting) return;

    //检查文件夹路径是否为空,弹框提示，根据用户选择进行下一步
    bool goAhead = await checkDirPath();
    if (!goAhead) return;

    //开始下载
    await startDownload(index, task);
  }

  ///检查文件夹路径是否为空，如果为空则弹框提示
  Future<bool> checkDirPath() async {
    if (Global.dirPath == "") {
      bool? userChoice = await showConfirmDialog(context, "目录未设定,继续？");
      userChoice ??= false;
      return userChoice;
    }
    return true;
  }

  ///开始下载流程
  Future<void> startDownload(int index, Task task,
      {VoidCallback? onFinished}) async {
    if (task.status == Status.waiting) {
      //开始连接
      try {
        Handler handler = Handler(task.url);
        task.notifyStatusChange = (status) {
          setState(() {
            task.status = status;
            widget.tasks[index] = task;
          });
        };
        await handler.download(task);
      } catch (e) {
        task.status = Status.error;
        updateListTileUI(index, task);
      }
    }
    //下载完的回调
    if (onFinished != null) onFinished();
  }
}
