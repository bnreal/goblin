import "package:path/path.dart" as path;

const flagYoutube = "youtube";
const flagFoyin = "foyin.tv";
const flagFyWatch = "foyin.tv/watch";
const flagFyDown = "foyin.tv/down";
const flagPlaylist = "playlist";

extension StringExtension on String {
  ///简单判断是否是一个url是否列表页面，如一个youtube的playlist页面或佛弟子网站含多个视频地址
  ///的播放页面。本函数不做是否url判断。
  ///Youtube--同时包含youtube和playlist即为true
  ///佛弟子--所有含佛弟子域名的都为true
  bool isListUrl() =>
      (contains(flagYoutube) && contains(flagPlaylist)) ||
      endsWith(".htm") ||
      endsWith(".html") ||
      contains(flagFyWatch);

  ///判断一个url是否属于某一网站
  bool isYoutubeUrl() => (contains(flagYoutube));
  bool isFoyinUrl() => (contains(flagFoyin));
  bool isFyWatchUrl() => (contains(flagFyWatch));
  bool isFyDownUrl() => (contains(flagFyDown));

  bool isAudio() => (endsWith(".mp3") ||
      endsWith(".m4a") ||
      endsWith(".MP3") ||
      endsWith(".M4a"));
  bool isVideo() => (endsWith(".mp4") || endsWith(".MP4") || endsWith(".flv"));
}

//根据指定参数构造完整文件路径，extension-扩展名（不用需要包含 . ）
String buildFilePath(String dirPath, String rawFileName, String extension,
    {Set<String>? textsForReplace, int number = -1}) {
  String fileName = extension.isEmpty ? rawFileName : "$rawFileName.$extension";
  textsForReplace ??= {};
  for (var text in textsForReplace) {
    fileName = fileName.replaceAll(text, "");
  }
  //如果文件名为空串，并且未指定序号，以时间戳代替
  if (rawFileName == "" && number == -1) {
    fileName = DateTime.now().millisecondsSinceEpoch.toString();
  }
  if (number > -1) {
    fileName = "$number-$fileName";
  }
  return path.join(dirPath, fileName.trim());
}
