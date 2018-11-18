import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/story.dart';
import '../../models/colors.dart';
import 'stories.dart';

class Search extends StatelessWidget {
  final ScrollController controller = new ScrollController();

  Stories list;
  
  Search() {
    list = new Stories(null, null, " ");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.blue(),
        title: Text('Search', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (String query) {
                list.updateQuery(query);
                list.scrollUp();
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: MyColors.blue(),
                filled: true,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          new Expanded (
            child: list,
          )
        ],
      )
    );
  }
}