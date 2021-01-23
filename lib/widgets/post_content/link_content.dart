import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkContent extends StatefulWidget {
  final Submission post;

  const LinkContent({Key key, this.post}) : super(key: key);

  @override
  _LinkContentState createState() => _LinkContentState();
}

class _LinkContentState extends State<LinkContent> {
  Submission get _post => widget.post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launch(_post.url.toString()),
      child: FlutterLinkPreview(
        url: _post.url.toString(),
        bodyStyle: TextStyle(
          fontSize: 18.0,
        ),
        titleStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        builder: (info) {
          if (info is WebInfo) {
            return SizedBox(
              height: 350,
              child: Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (info.image != null)
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Image.network(
                              info.image,
                              width: double.maxFinite,
                              fit: BoxFit.cover,
                            ),
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(200)),
                                child: Text(
                                  _post.domain,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                      child: Text(
                        info.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (info.description != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(info.description),
                      ),
                  ],
                ),
              ),
            );
          }
          if (info is WebImageInfo) {
            return SizedBox(
              height: 350,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  info.image,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                ),
              ),
            );
          } else if (info is WebVideoInfo) {
            return SizedBox(
              height: 350,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  info.image,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
