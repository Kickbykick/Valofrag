import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:valorant_helper/userscreens/explore.dart';

class ExploreMaps extends StatelessWidget {
  final ValueChanged<NavigateInfo> onPush;
  const ExploreMaps({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> globalMaps = ["Haven", "Bind", "Split"];

    return Scaffold(
        appBar: AppBar(
          title: Text('Maps', style: TextStyle(color: Constants.WineColor),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search), 
              onPressed: () {showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );},)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GridView.builder( 
            shrinkWrap: true,
                  itemCount: globalMaps.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  
                  return InkWell(
                    onTap: () async {
                      bool bIsFavourite = await bIsFavorite(globalMaps[index]);

                      onPush( NavigateInfo(bFavPush: bIsFavourite, sObjName: globalMaps[index], type: "Map") );
                    },
                    child: Hero(tag: "${globalMaps[index]}", child: _buildMap(globalMaps[index])),//Text(globalMaps[index])), //
                  );
                },),

      ),
    );
  }

  Widget _buildMap( String map){
    return Padding(
      padding: EdgeInsets.only(top:15, bottom: 5.0, left:5.0, right:5.0),
      child: Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children:<Widget>[
              Flexible(flex:3,
                child: Container(
                  decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: AssetImage("images/map_${map.toLowerCase()}.jpeg"),
                    fit: BoxFit.contain,
                    ),
                )),
              ),

              Flexible(flex:1,child: Text(map.toUpperCase())),
            ]
          ),
      )
    );
  }

  Future <bool> bIsFavorite(String fav) async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList("favorite");
    
    if(favoriteList == null) { return false;}
    else return favoriteList.contains(fav) ? true : false;
  }
}