import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valorant_helper/shared/contants.dart';

class MapDetailScreen extends StatefulWidget {
  final String mapName;
  final bool bIsFav;
  MapDetailScreen({this.mapName, this.bIsFav});

  @override
  _MapDetailScreenState createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  bool bIsAttack = false;
  bool bFav = false;

  @override
  void initState() {
    super.initState();
    bFav = widget.bIsFav == null ? false : widget.bIsFav;
  }
  
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
                      imageProvider: bIsAttack ? AssetImage("images/${widget.mapName.toLowerCase()}_map_attack.png") : AssetImage("images/${widget.mapName.toLowerCase()}_map_defense.png",),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: 
                    IconButton(icon: Icon(Icons.clear, color: Constants.WineColor,), onPressed: ()=>  Navigator.pop(context))),
                  Align(alignment: Alignment.topCenter,
                    child: Switch.adaptive(
                      activeColor: Constants.WineColor,
                      value: bIsAttack, 
                      onChanged:(val) { 

                        setState(() {
                          bIsAttack = val;
                        });
                      }
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(icon: Icon( bFav ? Icons.star : Icons.star_border), color: bFav ? Constants.WineColor : DynamicTheme.of(context).data.textTheme.title.color,
                      onPressed: () async { setState(() { bFav = !bFav; } ); bFav ? await setFavorite(widget.mapName) : await removeFavorite(widget.mapName); }
                      ),
                    ),
                  )
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

  setFavorite(String fav) async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList("favorite");
    
    if(favoriteList == null) { favoriteList = List<String>(); addDistict(favoriteList, fav);}
    else addDistict(favoriteList, fav);

    prefs.setStringList("favorite", favoriteList);
  }

  removeFavorite(String fav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList("favorite");
    
    if(favoriteList == null) { favoriteList = List<String>(); favoriteList.remove(fav);}
    else favoriteList.remove(fav);

    prefs.setStringList("favorite", favoriteList);
  } 
  
  void addDistict(favoriteList, fav){
    if(!favoriteList.contains(fav)) favoriteList.add(fav);
  }
}