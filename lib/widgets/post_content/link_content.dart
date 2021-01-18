import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:reddit_client/models/post.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkContent extends StatefulWidget {
  final Post post;

  const LinkContent({Key key, this.post}) : super(key: key);

  @override
  _LinkContentState createState() => _LinkContentState();
}

class _LinkContentState extends State<LinkContent> {
  Post get _post => widget.post;

  Future<dynamic> _fetchMetadata() async {
    // var data = await extract(_post.url.toString());
    try {
      var response = await http.get(_post.url.toString());
      var document = responseToDocument(response);
      var data = MetadataParser.parse(document);
      return data;
    } catch (e) {
      print("Couldn't process ${_post.url.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchMetadata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () => launch(widget.post.url.toString()),
              child: Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    // color: blueColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  // color: darkGreyColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        Icons.launch,
                        // color: blueColor,
                      ),
                      flex: 1,
                    ),
                    VerticalDivider(
                      thickness: 2,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data?.title ?? "Link",
                            style: TextStyle(
                              // color: redditOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.post.domain,
                            // style: TextStyle(color: lightGreyColor),
                          ),
                        ],
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
