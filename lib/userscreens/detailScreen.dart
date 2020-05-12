import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:valorant_helper/shared/contants.dart';

class DetailScreen extends StatelessWidget {
  final String thePictureName;
  DetailScreen({this.thePictureName});

  @override
  Widget build(BuildContext context) {
    PhotoViewController photoViewController;

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          child: Container(
              height: MediaQuery.of(context).copyWith().size.height,
              width: MediaQuery.of(context).copyWith().size.width,
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: 'Image',
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(
                        color: DynamicTheme.of(context).data.canvasColor,
                      ),
                      controller: photoViewController,
                      imageProvider: CachedNetworkImageProvider(
                          thePictureName,
                       
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: 
                    IconButton(icon: Icon(Icons.clear, color: Constants.WineColor,), onPressed: ()=>  Navigator.pop(context))),
                ],
              )
              
            ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}