import '/exports.dart';
import 'handler_common.dart';
import 'handler_foyin.dart';
import 'handler_youtube.dart';

abstract class Handler with Downloader {
  String url = "";
  Future<WebPage> createPage() async => WebPage(url);

  factory Handler(String url) {
    if (url.isYoutubeUrl()) {
      return YoutubeHandler(url);
    } else if (url.isFoyinUrl()) {
      return FoyinHandler(url);
    } else {
      return CommonHandler(url);
    }
  }
}

///通用下载器
///根据task的url和其他属性值构造filepath
///对于单链接下载（fileType为""）, 截取url最后一个/的部分String作为文件名,filtype不变
class Downloader {
  Future<void> download(Task task) async {
    task.notifyStatusChange ??= (status) => task.status = status;
    String rawFileName =
        task.fileType.isEmpty ? task.url.split("/").last : task.title;
    String savePath = buildFilePath(Global.dirPath, rawFileName, task.fileType,
        textsForReplace: Global.charsForReplace, number: task.number);
    task.notifyStatusChange!(Status.downloading);
    await fetchFile(task.url, savePath)
        .then((value) => task.notifyStatusChange!(Status.finished))
        .onError((error, stackTrace) => task.notifyStatusChange!(Status.error));
  }
}
