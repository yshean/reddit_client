import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'image_content.dart';

class GfycatVideoContent extends StatefulWidget {
  final Uri url;

  const GfycatVideoContent({Key key, this.url}) : super(key: key);

  @override
  _GfycatVideoContentState createState() => _GfycatVideoContentState();
}

class _GfycatVideoContentState extends State<GfycatVideoContent> {
  Future<String> _retrieveLink() async {
    String videoName = widget.url.path.substring(1);

    Response response =
        await Dio().get('https://api.gfycat.com/v1/gfycats/$videoName');

    Map<String, dynamic> json = jsonDecode(response.toString());

    return json["gfyItem"]["gifUrl"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _retrieveLink(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ImageContent(
            url: snapshot.data,
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              // color: darkGreyColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(children: <Widget>[
              Icon(
                Icons.error,
                // color: redditOrange,
              ),
              Text(
                "Couldn't retrieve content",
                style: TextStyle(
                    // color: lightGreyColor,
                    ),
              ),
            ]),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
                // valueColor: AlwaysStoppedAnimation<Color>(
                //   redditOrange,
                // ),
                // backgroundColor: darkGreyColor,
                ),
          );
        }
      },
    );
  }
}
