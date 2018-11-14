import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../../models/section.dart';
import '../../models/colors.dart';
import '../../api/sections.dart';

import 'section.dart';


class Sections extends StatefulWidget {
  @override
  SectionsState createState() => new SectionsState();
}

class SectionsState extends State<Sections> {
  Iterable<SectionModel> sections;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    Iterable<SectionModel> sections = await new SectionsAPI().getData();
    setState(() {
      this.sections = sections; 
    });
  }

  @override 
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sections == null) {
      return new Container(
        alignment: Alignment.center,
        child: new SizedBox(
          height: 50.0,
          width: 50.0,
          child: new CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColors.yellow())),
        ),
      );
    } else {
      return new GridView.count(
        crossAxisCount: 2,
        children: List.generate(sections.length, (index) {
          return new Section(sections.elementAt(index));
        }),
      );
    }
  }

}