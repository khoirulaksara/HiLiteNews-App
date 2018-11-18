import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../../pages/home.dart';
import '../../models/colors.dart';

class CategoriesList extends StatefulWidget {
  List<Tab> tabs;

  CategoriesList(this.tabs);

  @override 
  CategoriesListState createState() => new CategoriesListState(tabs);
}

class CategoriesListState extends State<CategoriesList> {
  List<String> categories = [];
  
  CategoriesListState(List<Tab> tabs) {
    for (Tab tab in tabs) {
      categories.add(tab.text);
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override 
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.blue(),
        title: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),),
      ),
      body: new Container(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              color: Colors.white,
              child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new GestureDetector(
                  onTap: () {
                    Navigator.pop(context, index);
                  },
                  child: new Text(
                    categories.elementAt(index),
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                )
              ),
            );
          }
        )
      )
    );
  }
}