import 'package:flutter/material.dart';
import 'package:valorant_helper/shared/utility_icons_icons.dart';
import 'package:valorant_helper/userscreens/webview.dart';

class MediaPage extends StatelessWidget {
  final ValueChanged<String> onPush;
  MediaPage({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "News", icon: Icon(Icons.new_releases)),
              Tab(text: "Streams", icon: Icon(UtilityIcons.twitchlogo)),
              // Tab(text: "Videos", icon: Icon(Icons.video_library)),
            ],
          ),
          title: Text('Media'),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            WebViewTabView(websiteLink: "https://beta.playvalorant.com/en-us/news/",),
            WebViewTabView(websiteLink: "https://www.twitch.tv/directory/game/VALORANT",),
            // WebViewTabView(websiteLink: "https://www.youtube.com/channel/UC8CX0LD98EDXl4UYX1MDCXg",),
          ],
        ),
      ),
    );
  }
}