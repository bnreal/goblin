# goblin

Flutter 第一个练手项目 -- 网络文件批量下载器
可用于批量下载Youtube视频，Foyin.tv音频（包括播放页面和下载页面）及其他含有清晰文件链接的页面中的所有文件。

## 整体架构
1. 界面： 主体框架 - scaffold
scaffold - title: 输入框，用于接收url
scaffold - body: listView, 用于列出下载任务
scaffold - bottom: 功能按钮组及文本

2. 功能：
2.1 接收一个Youtube url进行下载,单视频地址或list均可。list可选择下载范围。可选择只下载音频。
2.2 接收一个foyin.tv url 进行下载，包括播放页面和下载页面.
2.3 其他包括多个文件下载链接的url.
2.4 可下载到指定文件夹

3. 后台逻辑：
3.1 主要元素：Task 和 Handler：
一个task记录了一个下载任务的url,文件类型,status等信息，并与界面widget关联.Handler负责网络请求，页面解析，下载等。
预定义网站有对应的Handler子类，由Handler的工厂方法创建实例。这样可以大大减少重复代码。

