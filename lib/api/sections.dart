import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api.dart';
import '../models/section.dart';

class SectionsAPI extends API {

  // get a list of the sections on the website
  Future<Iterable<SectionModel>> getData() async {
    String url = this.domain + '/?json=get_category_index'; // go to url for getting category list
   
    var response = await http.get( // get json response
      Uri.encodeFull(url),
      headers: {
        "Accept": "application/json"
      }
    );

    List rawStories = json.decode(response.body)['categories']; // turn response into raw json list
    return (rawStories).map((i) => new SectionModel.fromJson(i)); // get iterable of stories based on the raw json list
  }

  // get a featured image for a particular section on the website (featured image of the most recent post in the section)
  Future<String> getImage(SectionModel section) async {
    // get 1 post from the given section and only provide the thumnail
    String url = this.domain + '/?json=get_category_posts&slug=' + section.slug + '&count=1&page=1&include=thumbnail';

    var response = await http.get( // get json response
      Uri.encodeFull(url),
      headers: {
        "Accept": "application/json"
      }
    );

    List rawStories = json.decode(response.body)['posts']; // turn response into raw json list
    if (rawStories.length > 0 && rawStories[0]['thumbnail_images'] != null) { // if there is a featured image to provide ...
      return rawStories[0]['thumbnail_images']['thumbnail']['url']; // ... provide its url
    }
  }
}

