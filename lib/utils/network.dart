import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import "package:html/parser.dart" as html_parser;

import '../models.dart';

//请求一个网址，将返回的Response转成String返回
Future<String> fetchHtmlString(String url) async {
  Dio dio = Dio();
  var response = await dio.get(url).catchError((error) => throw error);
  dio.close();
  return response.data.toString();
}

//解析htmlString获取网页标题
String fetchHtmlTitle(String htmlString) {
  Document document = html_parser.parse(htmlString);
  var elements = document.getElementsByTagName("title");
  if (elements.isEmpty) {
    return "";
  }
  return elements[0].text;
}

//解析htmlString获取在FileTypes内的所有文件类型链接
List<Link> fetchLinks(String htmlString) {
  Document document = html_parser.parse(htmlString);
  var elements = document.getElementsByTagName("a");
  List<Link> links = [];
  for (final element in elements) {
    final href = element.attributes['href'];
    String fileType = href!.split(".").last;
    //这里限定的文件类型需在FileTypes里，如需增加类型，须先在FileTypes类里注册
    if (FileTypes.all.contains(fileType)) {
      links.add(Link(element.text, href, fileType: fileType));
    }
  }
  return links;
}

//连接url,获取标题和链接后返回一个WebPage对象
Future<WebPage> fetchPage(String url) async {
  String htmlString = await fetchHtmlString(url);
  WebPage page = WebPage(url);
  page.title = fetchHtmlTitle(htmlString);
  page.fileLinks = fetchLinks(htmlString);
  return page;
}

//下载文件
Future<void> fetchFile(String url, String savePath) async {
  Dio dio = Dio();
  await dio.download(url, savePath).catchError((error) => throw error);
  dio.close();
}
