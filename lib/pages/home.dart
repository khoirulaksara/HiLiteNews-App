import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../fragments/stories/search.dart';
import '../fragments/stories/stories.dart';
import '../models/colors.dart';
import '../models/database.dart';
import '../models/section.dart';
import '../models/tag.dart';
import '../fragments/stories/categories-list.dart';

class HomeView extends StatefulWidget {

  @override
  HomeViewState createState() => new HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin {

  List<Widget> children = [
    new Stories(null, null, null),
    new Stories('topstory-2', null, null)
  ];

  List<Tab> tabs = [
    Tab(text: 'All',),
    Tab(text: 'Top Story',),
  ];

  TabController controller;
  
  bool areSectionsFinished = false;
  bool areTagsFinished = false;

  @override
  void initState() {
    controller = new TabController(
      length: tabs.length,
      vsync: this,
    );
    fillSections().whenComplete(() {
      areSectionsFinished = true;
      controller = new TabController(
        length: tabs.length,
        vsync: this,
      );
    });
    fillTags().whenComplete(() {
      areTagsFinished = true;
      controller = new TabController(
        length: tabs.length,
        vsync: this
      );
    }); 
    super.initState();
  }

  Future<void> fillSections() async {
    List<SectionModel> sections = await DBHelper().getSections();
    for (int i = 0; i < sections.length; i++) {
      tabs.add(new Tab(text: sections[i].titleEachWordCapped()));
      children.add(new Stories(sections[i].slug, null, null));
    }
    this.setState(() {
      tabs = tabs;
      children = children;
    });
  }

  Future<void> fillTags() async {
    List<TagModel> tags = await DBHelper().getTags();
    for (int i = 0; i < tags.length; i++) {
      children.add(new Stories(null, tags[i].slug, null));
      tabs.add(new Tab(text: tags[i].title));
    }
    this.setState(() {
      tabs = tabs;
      children = children;
    });
  }

  void launchCategories() async {
    final index = await Navigator.push(context, new MaterialPageRoute(builder: (context) => new CategoriesList(tabs)));
    print(index);
    if (index != null) {
      controller.animateTo(int.parse(index.toString()));
    }
  }

  void launchSearch() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new Search()));
  }

  @override
  Widget build(BuildContext context) {
    return !areSectionsFinished || !areTagsFinished ? 
      new Center(
        child: new CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColors.yellow())),
      ) :
      new Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.blue(),
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.list),
              onPressed: launchCategories,
            ),
            new IconButton(
              icon: Icon(Icons.search),
              onPressed: launchSearch,
            )
          ],
          bottom: new TabBar(
            controller: controller,
            indicatorColor: MyColors.yellow(),
            tabs: tabs, 
            isScrollable: true,
          ),
          title: Text('HiLite Newspaper', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),),
        ),
        body: TabBarView(
          controller: controller,
          children: children
        ),
      );
  }
}