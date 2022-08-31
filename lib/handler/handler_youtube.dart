import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../utils/utils.dart';
import '../global.dart';
import '../models.dart';
import 'handler.dart';

///Youtube视音频的下载处理器
///重写了Downloader的download方法

class YoutubeHandler with Downloader implements Handler {
  @override
  String url = "";

  YoutubeHandler(this.url);

  @override
  Future<WebPage> createPage() async {
    var yt = YoutubeExplode();
    var playlist = await yt.playlists.get(url).catchError((error) {
      throw error;
    });
    var playlistVideos =
        await yt.playlists.getVideos(playlist.id).toList().catchError((error) {
      throw error;
    });
    List<Link> fileLinks = [];
    WebPage page = WebPage(url, title: playlist.title);
    for (var video in playlistVideos) {
      fileLinks.add(Link(video.title, video.url, isAudio: Global.audioOnly));
    }
    page.fileLinks = fileLinks;
    return page;
  }

  ///专用于下载Youtube资源的download方法
  @override
  Future<void> download(Task task) async {
    //对回调函数空值的处理，防止抛异常
    task.notifyStatusChange ??= (status) => task.status = status;
    var yt = YoutubeExplode();
    task.notifyStatusChange!(Status.connecting);
    var video = await yt.videos.get(url).catchError((error, stackTrace) {
      task.notifyStatusChange!(Status.error);
      throw error;
    });

    task.title = video.title;
    task.notifyStatusChange!(Status.downloading);
    task.fileType = task.audioOnly ? FileTypes.mp3 : FileTypes.mp4;
    String savePath = buildFilePath(Global.dirPath, task.title, task.fileType,
        textsForReplace: Global.charsForReplace, number: task.number);
    StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(video.id);
    var streamType = task.audioOnly ? manifest.audioOnly : manifest.muxed;
    // debugPrint(streamType.sortByBitrate().toString());//列出所有支持的码率
    var streamInfo = streamType.withHighestBitrate();
    var stream = yt.videos.streamsClient.get(streamInfo);
    var file = File(savePath);
    var fileStream = file.openWrite();
    await stream.pipe(fileStream).catchError((error) {
      task.notifyStatusChange!(Status.error);
      throw error;
    });
    await fileStream.flush();
    await fileStream.close();
    yt.close();
    task.notifyStatusChange!(Status.finished);
  }
}
