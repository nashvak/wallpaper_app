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
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      // Trigger fetch when 200 pixels near the bottom
      Provider.of<PhotooProvider>(context, listen: false).fetchPhotos();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<String> categories = ["Activity", "community", "shop"];
  @override
  Widget build(BuildContext context) {
    final photos = Provider.of<PhotooProvider>(context).photos;
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        // snap: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: const Center(
                child: Text(
              "All Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
          ),
        ),
        pinned: true,
        floating: false,
        flexibleSpace: FlexibleSpaceBar(
          background: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        expandedHeight: 200,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red)),
                  onPressed: () {},
                  child: const Text(
                    "Follow",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),

        //IconButton
        //<Widget>[]
      ), //
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: MasonryGridView.builder(
              padding: const EdgeInsets.all(0),
              controller: _scrollController,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
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
      )
    ]
        // body: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 5),
        //   child: MasonryGridView.builder(
        //       controller: _scrollController,
        //       gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //       ),
        //       shrinkWrap: true,
        //       mainAxisSpacing: 5,
        //       crossAxisSpacing: 5,
        //       itemCount: photos.length,
        //       itemBuilder: (context, index) {
        //         double height = (index % 10 + 1) * 100;
        //         final photo = photos[index];
        //         return ClipRRect(
        //           borderRadius: BorderRadius.circular(8.0),
        //           child: CachedNetworkImage(
        //             height: height > 300 ? 300 : height,
        //             imageUrl: photo.imagePotraitPath,
        //             // placeholder: (context, url) => Center(
        //             //   child: CircularProgressIndicator(),
        //             // ),
        //             errorWidget: (context, url, error) => Icon(Icons.error),
        //             fit: BoxFit.cover,
        //           ),
        //         );
        //       }),
        // ),

        );
  }
}

// appBar: AppBar(
//         title: Icon(Icons.arrow_back_ios),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all(Colors.red)),
//                 onPressed: () {},
//                 child: Text(
//                   "Follow",
//                   style: TextStyle(color: Colors.white),
//                 )),
//           )
//         ],
//       ),
