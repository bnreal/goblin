import '../exports.dart';
import 'handler.dart';

///处理不在预设范围内的一般url的Handler
class CommonHandler with Downloader implements Handler {
  @override
  String url = "";

  @override
  Future<WebPage> createPage() async {
    return fetchPage(url);
  }

  //构造函数
  CommonHandler(this.url);
}
