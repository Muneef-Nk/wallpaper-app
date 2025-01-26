import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_app/features/wallpaper/views/error.dart';
import 'package:wallpaper_app/features/wallpaper/views/photo_detail_view.dart';

import '../controller/photo_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  final List<String> categories = [
    "All",
    "Nature",
    "Lifestyle",
    "Animals",
    "Abstract",
    "Technology",
    "Fashion",
    "Cities"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        Provider.of<WallpaperController>(context, listen: false).fetchPhotos(
            category: categories[_tabController.index], reset: true);
      }
    });

    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WallpaperController>(context, listen: false).fetchPhotos();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!Provider.of<WallpaperController>(context, listen: false).isLoading) {
        Provider.of<WallpaperController>(context, listen: false).fetchPhotos();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Wallpapers',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.purple,
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.purple,
          onTap: (index) {
            Provider.of<WallpaperController>(context, listen: false)
                .fetchPhotos(category: categories[index], reset: true);
          },
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          return Consumer<WallpaperController>(
            builder: (context, provider, _) {
              if (provider.photos.isEmpty && provider.isLoading) {
                return initialLoading();
              }
              if (provider.errorMessage != null) {
                return ErrorScreen(
                  onPressed: () {
                    provider.retryFetchPhotos();
                  },
                  message: provider.errorMessage!,
                );
              }
              return _buildPhotoGrid(provider);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget initialLoading() {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 235, 235, 235),
      highlightColor: const Color.fromARGB(255, 248, 253, 255),
      child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(10),
        crossAxisCount: 2,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          );
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }

  Widget _buildPhotoGrid(WallpaperController provider) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(10),
      controller: _scrollController,
      crossAxisCount: 2,
      itemCount: provider.photos.length,
      itemBuilder: (context, index) {
        final photo = provider.photos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoDetailView(id: photo.id),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(int.parse("0xFF${photo.avgColor.substring(1)}")),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: photo.src.medium,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.error,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  onTap: () {
                    provider.downloadImage(photo.src.original, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    );
  }
}
