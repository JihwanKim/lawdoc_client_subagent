import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/subagent_image_provider.dart';

class BoardImage extends StatelessWidget {
  final String path;

  const BoardImage({Key key, this.path}) : super(key: key);

  readImageInfo(context, path) async {
    final prov = Provider.of<SubAgentImageProvider>(context);
    final url = await prov.getByS3Key(path);
    final Image image = Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: Container(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          ),
        );
      },
    );
    // Completer<ui.Image> completer = new Completer<ui.Image>();
    // image.image
    //     .resolve(new ImageConfiguration())
    //     .addListener(new ImageStreamListener((ImageInfo image, bool _) {
    //   completer.complete(image.image);
    // }));
    // ui.Image info = await completer.future;
    // int width = info.width;
    // int height = info.height;
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SubAgentImageProvider>(context);
    return Container(
      // width: image.width,
      // height: image.height,
      child: Stack(
        children: [
          FutureBuilder(
            future: readImageInfo(context, path),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  child: snapshot.data,
                );
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
