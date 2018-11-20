import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../models/story.dart';
import '../stories/stories.dart';
import './webview-fragment.dart';
import '../../models/colors.dart';

class Webview extends StatefulWidget { 
  final StoryModel story;
  final int index;

  static void setStories(StoriesState stories) {
    WebviewState.stories = stories;
  }

  Webview(this.story, this.index);

  @override
  WebviewState createState() => new WebviewState(story, index);
  
}

class WebviewState extends State<Webview> {
  FlutterWebviewPlugin plugin = FlutterWebviewPlugin();
  static StoriesState stories;
  StoryModel story;
  int index;

  WebviewState(StoryModel story, int index) {
    this.story = story;
    this.index = index;
    
  }

  bool noPrev = false; 
  bool noNext = false;

  @override 
  void initState() {
    updatePrevNext();
    super.initState();
  }

  void updatePrevNext() {
    this.setState(() {
      noPrev = index <= 0;
      noNext = index >= stories.stories.length - 1 && !stories.moreStories;
    });
  }  

  void prev() {
    this.setState(() {
      index = noPrev ? 0 : index - 1;
      updatePrevNext();
      story = stories.stories.elementAt(index);
      plugin.reloadUrl(stories.stories.elementAt(index).url);
    });
  }

  void next() async {
    if (!noNext) {
      if (index >= stories.stories.length - 1) {
        stories.page++;
        await stories.getData();
      } 

      this.setState(() {
        index++;
        updatePrevNext();
        story = stories.stories.elementAt(index);
        plugin.reloadUrl(stories.stories.elementAt(index).url);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: story.url,
      appBar: AppBar(
        title: Text(story.title),
        backgroundColor: MyColors.blue(),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              Share.share(story.url); // pull up sharing menu for native os
            },
          ),
        ]
      ),
      withJavascript: true,
      withLocalStorage: true,
      withZoom: true,
      bottomNavigationBar: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: noPrev ? Colors.black : Colors.white,
              ),
              onPressed: prev,
            ), 
          ), 
          new Expanded(
            child: new IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: noNext ? Colors.black : Colors.white,
              ),
              onPressed: next,
            ),
          )
        ],
      ),
    );
  }
}

