import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valorant_helper/classlogic/weapons.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:valorant_helper/shared/loading.dart';
import 'package:valorant_helper/shared/weapon_icons_icons.dart';
import 'package:valorant_helper/userscreens/agents_details_page.dart';
import 'package:valorant_helper/userscreens/map_detail_screen.dart';
import 'package:valorant_helper/userscreens/weapon_details_page.dart';

List<String> allData = ["Tactical Knife", "Classic", "Shorty", "Frenzy", "Ghost", "Sheriff"
  , "Stinger", "Spectre", "Bucky", "Judge", "Bulldog", "Guardian", "Phantom"
  , "Vandal", "Marshal", "Operator", "Ares", "Odin", "Light Shield", "Heavy Shield", 
  "Breach", "Cypher", "Brimstone", "Jett", "Sova", "Omen", "Phoenix", "Raze", "Sage", "Viper", "Haven", "Bind", "Split"];
List<String> globalAgents = ["Breach", "Cypher", "Brimstone", "Jett", "Sova", "Omen", "Phoenix", "Raze", "Sage", "Viper"];
List<String> globalWeapons = ["Tactical Knife", "Classic", "Shorty", "Frenzy", "Ghost", "Sheriff"
    , "Stinger", "Spectre", "Bucky", "Judge", "Bulldog", "Guardian", "Phantom"
    , "Vandal", "Marshal", "Operator", "Ares", "Odin", "Light Shield", "Heavy Shield"];
List<String> globalMaps = ["Haven", "Bind", "Split"];


class NavigateInfo{
  bool bFavPush;
  String sObjName;
  String type;
  String role;
  Weapons weaponInfo;

  NavigateInfo({ this.bFavPush, this.sObjName, this.type, this.role, this.weaponInfo });
}

String createImageName(context, String weapon){
  if(weapon.contains("Shield")){
    if(DynamicTheme.of(context).data == Constants.lightModeTheme)
      return weapon == "Light Shield" ? "images/weapon_light.jpg" : "images/weapon_heavy.jpg";
    else
      return weapon == "Light Shield" ? "images/weapon_light_white.png" : "images/weapon_heavy_white.png";
  }
  else if(weapon.contains("Knife"))
    return "images/weapon_tactical_knife.jpg";
  else if(weapon == "Haven" || weapon == "Bind" || weapon == "Split")
    return "images/map_${weapon.toLowerCase()}.jpeg";
  else if(weapon == "Sheriff")
    return "images/weapon_${weapon.toLowerCase()}.png";
  else
    return "images/weapon_${weapon.toLowerCase()}.jpg";   
}

class Explore extends StatelessWidget {
  final ValueChanged<NavigateInfo> onPush;
  const Explore({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = ["images/agent_breach.jpg", "images/agent_cypher.jpg", "images/agent_brimstone.jpg", "images/agent_jett.jpg", 
    "images/agent_sova.jpg", "images/agent_omen.jpg", "images/agent_phoenix.jpg", "images/agent_raze.jpg", 
    "images/agent_sage.jpg", "images/agent_viper.jpg"];
    List<String> roles = ["Controller", "Sentinel", "Controller", "Duelist", "Controller", "Controller", "Duelist", "Duelist", "Sentinel", "Controller"];

    return Scaffold(
        appBar: AppBar(
          title: Text('Agents', style: TextStyle(color: Constants.WineColor),),
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
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  
                  return InkWell(
                    onTap: () async {
                      
                      bool bIsFavourite = await bIsFavorite(globalAgents[index]);
                      // AgentInfo(bFavPush: bIsFavorite, sAgentName: agents[index]);
                      onPush(NavigateInfo(bFavPush: bIsFavourite, sObjName: globalAgents[index], type: "Agent", role: roles[index]));
                      // Navigator.push(
                      //   context, MaterialPageRoute( builder: (context) => AgentDetail(agentName: agents[index], bIsFav: bIsFavourite,),),
                      // );
                    },
                    child: _buildCharacterCard(images[index], globalAgents[index]),
                    // Container(
                    //   height: 50,
                    //   decoration: new BoxDecoration(
                    //   image: new DecorationImage(
                    //     image: AssetImage(images[index]),
                    //     fit: BoxFit.cover,
                    //     ),
                    // )),
                  );
                },),

      ),
    );
  }

  Future <bool> bIsFavorite(String fav) async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList("favorite");
    
    if(favoriteList == null) { return false;}
    else return favoriteList.contains(fav) ? true : false;
  }

  Widget _buildCharacterCard(String picName, String name) {
    return Container(
      height: 250,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 7,
            child: Container(
              decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              image: new DecorationImage(
                image: AssetImage(picName),
                fit: BoxFit.cover,
                ),
            )),
          ),
          
          Flexible(
              flex: 1,child: Text(name.toUpperCase(),)),
        ],
      ),
    );
  }
}



class ExploreWeapons extends StatefulWidget {
  final ValueChanged<NavigateInfo> onPush;
  ExploreWeapons({Key key, this.onPush}) : super(key: key);

  @override
  _ExploreWeaponsState createState() => _ExploreWeaponsState();
}

class _ExploreWeaponsState extends State<ExploreWeapons> {

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Weapons', style: TextStyle(color: Constants.WineColor),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search), 
              onPressed: () {showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );},)
          ],
        ),
        body: FutureBuilder(
          future: loadJson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) return Loading();

          List<Weapons> _allWeapons = snapshot.data;
          return DefaultTabController(
            length: 8,
            child: Column(
              // shrinkWrap: true,
              children:<Widget>[ 
                Flexible(
                  flex: 1,
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      labelColor: Constants.WineColor,
                      isScrollable: true,
                      labelPadding: EdgeInsets.only(right: 45.0),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(child: Text('ALL', style: TextStyle(fontSize: 20),),),
                        Tab(child: Text('SIDEARMS', style: TextStyle(fontSize: 20),),),
                        Tab(child: Text('SMGS', style: TextStyle(fontSize: 20),),),
                        Tab(child: Text('SHOTGUNS', style: TextStyle(fontSize: 20),),),
                        Tab(child: Text('RIFLES', style: TextStyle(fontSize: 20),),),
                        Tab(child: Text('SNIPER', style: TextStyle(fontSize: 20),),),
                        Tab(child: Text('HEAVIES', style: TextStyle(fontSize: 20),),),
                        Tab(child: Text('OTHERS', style: TextStyle(fontSize: 20),),),
                      ]
                    ),
                  ),
                ),

                Flexible(
                  flex: 9,
                  child: TabBarView(
                    children: <Widget>[
                      _gridWeapons("All", _allWeapons),
                      _gridWeapons("Sidearm", _allWeapons),
                      _gridWeapons("Smg", _allWeapons),
                      _gridWeapons("Shotgun", _allWeapons),
                      _gridWeapons("Rifle", _allWeapons),
                      _gridWeapons("Sniper", _allWeapons),
                      _gridWeapons("Heavy", _allWeapons),
                      _gridWeapons("Other", _allWeapons),
                  ]),
                ),
      ]
            ),
          );}
        ),
    );

  }

  Widget _gridWeapons(String weaponClass, List<Weapons> weapons){

    List<Weapons> createWeapon = List<Weapons>();

    // if(weaponClass == "")
    
    for(int i = 0; i < weapons.length; i++){
      if(weaponClass == "Other") {
        if( weapons[i].weaponClass.contains("Melee") || weapons[i].weaponClass.contains("Shield") )
          createWeapon.add(weapons[i]); }
      else{
        if( weapons[i].weaponClass.contains(weaponClass) )
          createWeapon.add(weapons[i]); 
      }
    }

    if(createWeapon.isEmpty )
      createWeapon = weapons;
    return GridView.builder( 
      // physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
          itemCount: createWeapon.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async{
              bool bIsFavourite = await bIsFavorite(createWeapon[index].weaponName);
              widget.onPush(NavigateInfo(bFavPush: bIsFavourite, sObjName: createWeapon[index].weaponName, type: "Weapon", role: createWeapon[index].weaponClass, weaponInfo: createWeapon[index]));
            },
            child: _buildWeaponCard(context, createWeapon[index].weaponName)); //GunListView(weapon: _allWeapons[index],);
      },
    );
  }

  loadJson() async {
    List<String> weapons = ["Tactical Knife", "Classic", "Shorty", "Frenzy", "Ghost", "Sheriff"
    , "Stinger", "Spectre", "Bucky", "Judge", "Bulldog", "Guardian", "Phantom"
    , "Vandal", "Marshal", "Operator", "Ares", "Odin", "Light Shield", "Heavy Shield"];

    List<Weapons> _allWeapons = List<Weapons>();
    
    try {
      String data = await rootBundle.loadString('json/weapons.json');
      var jsonResult = json.decode(data);
      for (var i = 0; i < weapons.length; i++) {
        DamageDetails noArmor;
        DamageDetails lightArmor;
        DamageDetails heavyArmor;
        String details = weapons[i]+"Details";
        if(jsonResult[weapons[i]].contains("No Armor"))
        {
          noArmor = DamageDetails( damageDistance: jsonResult[details][0]["No Armor"][0], headDamage: int.tryParse(jsonResult[details][0]["No Armor"][1]), 
            bodyDamage: int.tryParse(jsonResult[details][0]["No Armor"][2]), legDamage: int.tryParse(jsonResult[details][0]["No Armor"][3]) ); 
            }

        if(jsonResult[weapons[i]].contains("Light Armor"))
        { lightArmor = DamageDetails( damageDistance: jsonResult[details][1]["Light Armor"][0], headDamage: int.tryParse(jsonResult[details][1]["Light Armor"][1]), 
            bodyDamage: int.tryParse(jsonResult[details][1]["Light Armor"][2]), legDamage: int.tryParse(jsonResult[details][1]["Light Armor"][3]) );  }
        
        if(jsonResult[weapons[i]].contains("Heavy Armor"))
        { heavyArmor = DamageDetails( damageDistance: jsonResult[details][2]["Heavy Armor"][0], headDamage: int.tryParse(jsonResult[details][2]["Heavy Armor"][1]), 
            bodyDamage: int.tryParse(jsonResult[details][2]["Heavy Armor"][2]), legDamage: int.tryParse(jsonResult[details][2]["Heavy Armor"][3]) );  }
        
        _allWeapons.add(
          Weapons(price: int.tryParse(jsonResult[weapons[i]][0]), weaponType: jsonResult[weapons[i]][1], magazine: jsonResult[weapons[i]][2], 
          fireRate: jsonResult[weapons[i]][3], wallPenetration: jsonResult[weapons[i]][4], imageName: jsonResult[weapons[i]][5], weaponClass: jsonResult[weapons[i]][6], 
          weaponName: weapons[i], noArmor: noArmor, lightArmor: lightArmor, heavyArmor: heavyArmor)
        );
      }

      return _allWeapons;
    } catch (e) {
      print(e.toString());
    }
  }

  Future <bool> bIsFavorite(String fav) async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList("favorite");
    
    if(favoriteList == null) { return false;}
    else return favoriteList.contains(fav) ? true : false;
  }

  Widget _buildWeaponCard(context, String weaponName){
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
                    image: AssetImage(createImageName(context, weaponName)),
                    fit: BoxFit.contain,
                    ),
                )),
              ),

              Flexible(flex:1,child: Text(weaponName.toUpperCase())),
            ]
          ),
          
        
      )
    );
  }
}



class GunListView extends StatelessWidget {
  final Weapons weapon;
  const GunListView({Key key, this.weapon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        color: Constants.GreyColor2,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: 10,),
            Flexible(flex: 2, child: _firstPart(weapon)),
            Flexible(flex: 5, child: _secondPart(weapon))
            
          ],
        ),
      ),
    );
  }

  Widget _firstPart(Weapons weapon){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Flexible(flex: 1, child: Text("${weapon.weaponName}")),
        SizedBox(height:5),
        Flexible(flex: 2, child: Container(
          height: 70,
          decoration: new BoxDecoration(
          image: new DecorationImage(
            image: AssetImage("${weapon.imageName}"),
            fit: BoxFit.contain, 
            ),
        ))),
        SizedBox(height:5),
        Flexible(flex: 1, child: Text("${weapon.price}")),

      ],
    );
  }

  Widget _secondPart(Weapons weapon){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        
        Row(children:<Widget>[Icon(WeaponIcons.view_head_icon, color: Colors.white,), SizedBox(height:10), Text("${weapon.magazine}")]) ,
        Row(children:<Widget>[Icon(WeaponIcons.view_body_icon, color: Colors.white,), SizedBox(height:10), Text("${weapon.magazine}")]) ,
        Row(children:<Widget>[Icon(WeaponIcons.view_leg_icon, color: Colors.white,), SizedBox(height:10), Text("${weapon.magazine}")]) ,

      ],
    );
  }
}




/////////////////////////////////////
///// SEARCH BAR
////////////////////////////////////
class CustomSearchDelegate extends SearchDelegate {
  List<String> recentSearch = ["Viper", "Tactical Knife", "Bind"];

  loadWeapon(String weaponName) async {  
    try {
      String data = await rootBundle.loadString('json/weapons.json');
      var jsonResult = json.decode(data);
      
        DamageDetails noArmor;
        DamageDetails lightArmor;
        DamageDetails heavyArmor;
        String details = weaponName+"Details";
        if(jsonResult[weaponName].contains("No Armor"))
        {  noArmor = DamageDetails( damageDistance: jsonResult[details][0]["No Armor"][0], headDamage: int.tryParse(jsonResult[details][0]["No Armor"][1]), 
            bodyDamage: int.tryParse(jsonResult[details][0]["No Armor"][2]), legDamage: int.tryParse(jsonResult[details][0]["No Armor"][3]) ); }

        if(jsonResult[weaponName].contains("Light Armor"))
        { lightArmor = DamageDetails( damageDistance: jsonResult[details][1]["Light Armor"][0], headDamage: int.tryParse(jsonResult[details][1]["Light Armor"][1]), 
            bodyDamage: int.tryParse(jsonResult[details][1]["Light Armor"][2]), legDamage: int.tryParse(jsonResult[details][1]["Light Armor"][3]) );  }
        
        if(jsonResult[weaponName].contains("Heavy Armor"))
        { heavyArmor = DamageDetails( damageDistance: jsonResult[details][2]["Heavy Armor"][0], headDamage: int.tryParse(jsonResult[details][2]["Heavy Armor"][1]), 
            bodyDamage: int.tryParse(jsonResult[details][2]["Heavy Armor"][2]), legDamage: int.tryParse(jsonResult[details][2]["Heavy Armor"][3]) );  }
        
        return Weapons(price: int.tryParse(jsonResult[weaponName][0]), weaponType: jsonResult[weaponName][1], magazine: jsonResult[weaponName][2], 
        fireRate: jsonResult[weaponName][3], wallPenetration: jsonResult[weaponName][4], imageName: jsonResult[weaponName][5], weaponClass: jsonResult[weaponName][6], 
        weaponName: weaponName, noArmor: noArmor, lightArmor: lightArmor, heavyArmor: heavyArmor);
    
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildCard(context, String agentName){
    String agentRole = "Controller";
    String currImg = "";
    if(isAgent(agentName))
      currImg = "images/agent_${agentName.toLowerCase()}_full.png";
    else if(isWeapon(agentName))
      currImg = createImageName(context, agentName);
    else if(isMap(agentName))
      currImg = "images/map_${agentName.toLowerCase()}.jpeg";

    if(agentName == "Cyher" || agentName == "Sage")
      agentRole = "Sentinel";
    else if(agentName == "Jett" || agentName == "Raze" || agentName == "Pheonix")
      agentRole = "Duelist";
    else if(agentName == "Sova" || agentName == "Brimstone")
      agentRole = "Initiator";
    
    return Padding(
      padding: EdgeInsets.only(top:15, bottom: 5.0, left:5.0, right:5.0),
      child: InkWell(
        onTap:() async {
          bool bIsFavourite = await bIsFavorite(agentName);
          if(isAgent(agentName))
            Navigator.push(
              context, MaterialPageRoute( builder: (context) => AgentDetail(agentName: agentName, bIsFav: bIsFavourite, agentRole: agentRole,),),
            );
          if(isMap(agentName))
            Navigator.push(
              context, MaterialPageRoute( builder: (context) => MapDetailScreen(bIsFav: bIsFavourite, mapName: agentName,),
            ),
            );
          if(isWeapon(agentName))
          {
            Weapons weapon = await loadWeapon(agentName);
            Navigator.push(
              context, MaterialPageRoute( builder: (context) => WeaponDetail(weaponName: agentName, bIsFav: bIsFavourite, weaponDetail: weapon,),),
            );
          }
        },
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
                    image: AssetImage(currImg),
                    fit: BoxFit.contain,
                    ),
                )),
              ),

              Flexible(flex:1,child: Text(agentName.toUpperCase())),
            ]
          ),
          
        )
      )
    );
  }

  Future <bool> bIsFavorite(String fav) async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList("favorite");
    
    if(favoriteList == null) { return false;}
    else return favoriteList.contains(fav) ? true : false;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recentSearch :
      allData.where((val) => val.toLowerCase().contains(query)).toList();   

    return GridView.builder( 
        shrinkWrap: true,
        itemCount: suggestionList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
      
      return _buildCard(context, suggestionList[index]);
     },
    );
  }
}

bool isAgent(String element){
  return globalAgents.contains(element);
}

bool isWeapon(String element){
  return globalWeapons.contains(element);
}

bool isMap(String element){
  return globalMaps.contains(element);
}