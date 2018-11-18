import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../fragments/categories/sections.dart';
import '../fragments/categories/tags.dart';
import '../models/colors.dart';

class CategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: MyColors.blue(),
          bottom: TabBar(
            indicatorColor: MyColors.yellow(),
            tabs: [
              Tab(text: "Sections"),
              Tab(text: "Tags"),
            ],
          ),
          title: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),),
        ),
        body: TabBarView(
          children: [
            new Sections(),
            new Tags(),
          ],
        ),
      ),
    );
  }
}