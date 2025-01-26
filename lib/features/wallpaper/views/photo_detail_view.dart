import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/features/wallpaper/controller/photo_controller.dart';

class PhotoDetailView extends StatefulWidget {
  final int id;
  const PhotoDetailView({super.key, required this.id});

  @override
  _PhotoDetailViewState createState() => _PhotoDetailViewState();
}

class _PhotoDetailViewState extends State<PhotoDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WallpaperController>(context, listen: false)
          .getPhoto(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Wallpapers',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: Consumer<WallpaperController>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return buildShimmerEffect();
          }
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Expanded(
                  child: PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    imageProvider:
                        NetworkImage(provider.photo?.src.large ?? ''),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered,
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    provider.downloadImage(
                      provider.photo?.src.original ?? '',
                      context,
                    );
                  },
                  child: Ink(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Download",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          Icons.download,
                          color: Colors.white,
                        )
                      ],
                    )),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildShimmerEffect() {
    return Column(
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.all(15),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}
