import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/provider/image_provider.dart';

class PhotoGrid extends StatefulWidget {
  const PhotoGrid({super.key});

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<PhotooProvider>(context, listen: false).fetchPhotos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<String> categories = ["Activity", "community", "shop"];
  @override
  Widget build(BuildContext context) {
    final photos = Provider.of<PhotooProvider>(context).photos;

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/girl.jpg"),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red)),
                        onPressed: () {},
                        child: const Text(
                          "Follow",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                right: 10,
              ),
              child: Container(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                        onPressed: () {
                          Provider.of<PhotooProvider>(context, listen: false)
                              .selectButton(index);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Provider.of<PhotooProvider>(context)
                                      .selectedIndex ==
                                  index
                              ? Colors.black // Selected button color
                              : Colors.white, //,
                          backgroundColor: Provider.of<PhotooProvider>(context)
                                      .selectedIndex ==
                                  index
                              ? Colors.white // Selected button color
                              : null, // Default color
                        ),
                        child: Text(categories[index]));
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                        width: 20); // Add spacing between items
                  },
                ),
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: const Center(
                child: Text(
              "All Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
          ),
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: MasonryGridView.builder(
                    padding: const EdgeInsets.all(0),
                    controller: _scrollController,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 7,
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      double height = (index % 10 + 1) * 100;
                      final photo = photos[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<PhotooProvider>(context, listen: false)
                                .downloadImage(
                                    imageId: photo.imageID,
                                    imageUrl: photo.imagePotraitPath,
                                    context: context);
                          },
                          child: CachedNetworkImage(
                            height: height > 300 ? 300 : height,
                            imageUrl: photo.imagePotraitPath,
                            // placeholder: (context, url) => Center(
                            //   child: CircularProgressIndicator(),
                            // ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
