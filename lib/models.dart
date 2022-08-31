import 'package:flutter/material.dart';

class Status {
  static const waiting = "下载";
  static const connecting = "正在连接...";
  static const downloading = "下载中...";
  static const finished = "已完成";
  static const error = "出错了";
  static const statusColors = {
    waiting: Colors.blueGrey,
    connecting: Colors.blue,
    downloading: Colors.blue,
    error: Colors.red,
    finished: Colors.green,
  };
  static const statusIcons = {
    waiting: Icons.schedule,
    connecting: Icons.cloud_download_sharp,
    downloading: Icons.downloading_sharp,
    error: Icons.error_rounded,
    finished: Icons.download_done_rounded
  };
}

class Task {
  String url, title, status, fileType;
  bool audioOnly;
  int number;
  ValueChanged? notifyStatusChange;
  Task(this.url,
      {this.title = "",
      this.status = Status.waiting,
      this.fileType = "",
      this.audioOnly = false,
      this.number = -1});
}

class WebPage {
  String url, title;
  late List<Link> fileLinks;
  WebPage(this.url, {this.title = ""});

  int get fileCount {
    return fileLinks.length;
  }
}

///一个网页或文件链接
///isAudio 并不能完全反映一个链接的文件类型，主要用于task的audioOnly
class Link {
  String title, url, fileType;
  bool isAudio;
  Link(this.title, this.url, {this.fileType = "", this.isAudio = false});
}

class FileTypes {
  static const mp4 = "mp4";
  static const mp3 = "mp3";
  static const m4a = "m4a";
  static const torrent = 'torrent';
  static const flv = 'flv';
  static const List<String> all = [
    "mp4",
    "mp3",
    "m4a",
    'torrent',
    'flv',
    'unknown'
  ];
}
