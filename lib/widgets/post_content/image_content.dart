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
        return Center(
          child: Padding(
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
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            color: Colors.black12,
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/image-not-found.png',
                  width: 36,
                  height: 36,
                ),
                SizedBox(height: 12),
                Text('Some error occurred while fetching the image'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
