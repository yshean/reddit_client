import 'package:flutter/material.dart';

class ImageContent extends StatelessWidget {
  final String url;

  const ImageContent({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            // valueColor: AlwaysStoppedAnimation<Color>(
            //   redditOrange,
            // ),
            // backgroundColor: darkGreyColor,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}
