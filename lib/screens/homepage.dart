import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/provider/image_provider.dart';
import 'package:wallpaper_app/screens/photo_grid.dart';
import 'package:wallpaper_app/screens/searchpage.dart';
import 'package:wallpaper_app/screens/settingspage.dart';

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

  final List<Widget> screens = [
    const PhotoGrid(),
    const SearchPage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PhotooProvider>(
        builder: (context, photoProvider, child) {
          return photoProvider.photos.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    screens.elementAt(
                        Provider.of<PhotooProvider>(context).selectedPageIndex),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Align(
                        alignment: const Alignment(0.0, 1.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: BottomNavigationBar(
                            selectedItemColor: Colors.white,
                            unselectedItemColor: Colors.grey,
                            showSelectedLabels: true,
                            showUnselectedLabels: false,
                            backgroundColor: Colors.black,
                            currentIndex: Provider.of<PhotooProvider>(context)
                                .selectedPageIndex,
                            onTap: (int index) {
                              Provider.of<PhotooProvider>(context,
                                      listen: false)
                                  .changeNavigation(index);
                            },
                            items: const [
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.home), label: "Home"),
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.search_off),
                                  label: "Search"),
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.settings), label: "Settings")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
