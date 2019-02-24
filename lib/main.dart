import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RssListPage(),
    );
  }
}

class RssListPage extends StatefulWidget {
  @override
  _RssListPageState createState() => _RssListPageState();
}

class _RssListPageState extends State<RssListPage> {

  List<RssItem> _items = List();

  final xmlUrl = "https://news.yahoo.co.jp/pickup/rss.xml";

  _RssListPageState() {
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RSS feed reader"),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (BuildContext context, int index) {
            return _buildRow(index, context);
          },
          itemCount: _items.length,
        ),
      ),
    );
  }

  Widget _buildRow(int index, BuildContext context) {
    return Card(
        child: ListTile(
          title: Text(_items[index].title),
          subtitle: Text(_items[index].pubDate.toString()),
          onTap: () {
            launchURL(_items[index].link);
          },
        )
    );
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getItems() async {

    Response response = await get(xmlUrl);
    RssFeed rssFeed = RssFeed.parse(response.body);
    setState(() {
      _items = rssFeed.items.map((item) => item).toList();
    });
  }
}

