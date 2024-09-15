import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoModel {
  final String url;
  final Map<String, dynamic>? attributes;

  PhotoModel({
    required this.url, 
    this.attributes
    });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'attributes': attributes,
    };
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  final List<PhotoModel> galleryItems;
  final int initialIndex;

  const GalleryPhotoViewWrapper({
    Key? key,
    required this.galleryItems,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _GalleryPhotoViewWrapperState createState() => _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.galleryItems[index].url),
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              itemCount: widget.galleryItems.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
              backgroundDecoration: BoxDecoration(
                color: Colors.black,
              ),
              pageController: PageController(initialPage: currentIndex),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}