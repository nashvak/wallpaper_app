import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/models/model.dart';
import 'package:wallpaper_app/provider/image_provider.dart';
import 'package:wallpaper_app/screens/photo_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotooProvider>(context, listen: false).fetchPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PhotooProvider>(
        builder: (context, photoProvider, child) {
          return photoProvider.photos.isEmpty
              ? Center(child: CircularProgressIndicator())
              : PhotoGrid();
        },
      ),
    );
  }
}
