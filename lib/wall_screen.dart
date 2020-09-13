import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'full_screen_image.dart';


class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {

  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference = Firestore.instance.collection("wallpapers");

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Arabic Quotes"),
        ),
        body: wallpapersList != null?
        new StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 4,
          itemCount:wallpapersList.length ,
          itemBuilder: (context, i) {
            String imgPath = wallpapersList[i].data['url'];
            return Material(
              elevation: 8,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return FullScreenImage(imgPath);
                      }
                  ));
                },
                child: Hero(
                  tag: imgPath,
                  child: FadeInImage(
                    image: NetworkImage(imgPath),
                    fit: BoxFit.cover,
                    placeholder: AssetImage("assets/pink2.jpg"),
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (i) => StaggeredTile.count(2, i.isEven? 2 : 3),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ) : Center (
          child: CircularProgressIndicator(),
        )
    );
  }
}