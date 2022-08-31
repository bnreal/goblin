import 'handler.dart';
import '../models.dart';
import '../utils/utils.dart' as utils;
import '../utils/network.dart' as network;

class FoyinHandler with Downloader implements Handler {
  FoyinHandler(this.url);

  @override
  String url = "";

  @override
  Future<WebPage> createPage() {
    if (url.isFyWatchUrl()) {
      return getFromWatchPage(url);
    } else {
      return getFromDownPage(url);
    }
  }
}

//从foyin.tv/watch页面获取文件链接，暂时只处理m4a类型的文件
Future<WebPage> getFromWatchPage(String url) async {
  WebPage page = WebPage(url);
  String htmlString = await network.fetchHtmlString(url);
  //获取页面标题
  page.title = network.fetchHtmlTitle(htmlString);
  // 获取音频地址列表
  final regExp = RegExp(r'{m4a:.*?\}');
  Iterable<Match> matches = regExp.allMatches(htmlString);
  List<Link> list = <Link>[];
  for (final Match m in matches) {
    String match = m[0]!.replaceAll('"', "").trim();
    var rawTexts = match.split(",");
    String url = rawTexts[0].replaceAll("{m4a:", "");
    String title = rawTexts[1].replaceAll("title:", "");
    //这里指定是m4a类型的文件，所以isAudio是true
    list.add(Link(title, url, fileType: FileTypes.m4a, isAudio: true));
  }
  page.fileLinks = list;
  return page;
}

//从foyin.tv/down页面获取文件链接,原页面link里没有文件名，这里做一些处理
Future<WebPage> getFromDownPage(String url) async {
  WebPage page = await network.fetchPage(url);
  for (final link in page.fileLinks) {
    String title1 =
        page.title.replaceAll("下載", "").replaceAll("佛音TV網", "").trim();
    String title2 = link.title.replaceAll("下載", "").trim();
    link.title = title1 + title2;
    link.isAudio = link.url.isAudio();
  }
  return page;
}
