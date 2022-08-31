import 'package:event_bus/event_bus.dart';

///使用EventBus基本流程：创建eventBus对象-创建事件class
///在触发事件的Widget上的事件代码里调用eventBus.fire()来分发事件
///在需要接收（监听）事件的widget的initSate里处理事件。
EventBus eventBus = EventBus();

class TaskListChangeEvent {
  final int taskCount;
  TaskListChangeEvent(this.taskCount);
}

class StartAllEvent {
  StartAllEvent();
}

class GlobalAudioOnlyEvent {
  final bool audioOnly;
  GlobalAudioOnlyEvent(this.audioOnly);
}

class ListDownloadingEvent {
  final bool isDownloading; //是否正在进行列表下载
  final int waitingCount; //尚未完成的任务数
  ListDownloadingEvent(this.isDownloading, this.waitingCount);
}
