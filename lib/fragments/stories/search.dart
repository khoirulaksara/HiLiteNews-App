import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/story.dart';
import '../../models/colors.dart';
import 'stories.dart';

class Search extends StatelessWidget {

  Stories list;
  
  Search() {
    list = new Stories(null, null, " ");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.offWhite(),
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
                // list.scrollUp();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                fillColor: Colors.white,
                filled: true,
                hintText: "Search",
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