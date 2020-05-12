import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valorant_helper/classlogic/weapons.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:valorant_helper/shared/weapon_details_icons_icons.dart';
import 'package:valorant_helper/shared/weapon_icons_icons.dart';

class WeaponDetail extends StatefulWidget {
  final String weaponName;
  final bool bIsFav;
  final Weapons weaponDetail;
  WeaponDetail({this.weaponName, this.bIsFav, this.weaponDetail});

  @override
  _WeaponDetailState createState() => _WeaponDetailState();
}

class _WeaponDetailState extends State<WeaponDetail> { 
  Weapons weapon;
  bool bFav = false;
  
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

  @override
  void initState() { 
    super.initState();
    bFav = widget.bIsFav == null ? false : widget.bIsFav;
  }

  void addDistict(favoriteList, fav){
    if(!favoriteList.contains(fav)) favoriteList.add(fav);
  }

  @override
  Widget build(BuildContext context) {
    String weaponVal = widget.weaponDetail.price == 0 ? "Free" : "${widget.weaponDetail.price} Credits";

    return  SafeArea(
          child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children:<Widget>[ 
                ClipPath(
                clipper: MyCustomClipper(),
                child: 
                Stack(
                  children: <Widget>[ Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.mirror,
                      colors: [ Constants.WineColor, Constants.BlueishValorant,]),
                      // color: Colors.black
                    ),
                    child:  Column(
                      children: <Widget>[ 
                        SizedBox(height:40),
                        Flexible(flex: 2, child: Container(
                          width: 250,
                          padding: EdgeInsets.all(40),
                          decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image:  AssetImage( widget.weaponDetail.imageName ), //AssetImage("images/agent_${agentName.toLowerCase()}.jpg"),
                            fit: BoxFit.contain,
                            ),
                        )),),
                        Flexible(flex: 2, child: 
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            
                            children: <Widget>[
                              Text(widget.weaponName.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.justify,),
                              Text("${widget.weaponDetail.weaponClass.toUpperCase()} - ${weaponVal.toUpperCase()}" ?? "WEAPON", style: TextStyle(color: Colors.white, fontSize: 15,)),
                            ]
                          ),
                        ),)
                    ]),
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(icon: Icon( Icons.arrow_back, color: Colors.white, ),
                      onPressed: () { Navigator.of(context).pop(); }
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(icon: Icon( bFav ? Icons.star : Icons.star_border), color: Colors.white,
                      onPressed: () async { setState(() { bFav = !bFav; } ); bFav ? await setFavorite(widget.weaponName) : await removeFavorite(widget.weaponName); }
                      ),
                    ),
                  )
                  ]
                ),//),
              ),

                SizedBox(height: 20),

                CreateWeaponDetail(weapons: widget.weaponDetail,)
              ]
            ),
          ),
      ),
    );
  }

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

class CreateWeaponDetail extends StatelessWidget {
  final Weapons weapons;
  CreateWeaponDetail({ this.weapons });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 5),
              Icon(WeaponDetailsIcons.magazine, size: 40,),
              Container(color: Constants.GreyColor2, width: 10, child: VerticalDivider()),
              Text(weapons.magazine.toString()),
            ]
          ),

          Row(
            children: <Widget>[
              Icon(WeaponDetailsIcons.wall_penetration, size: 40,),
              Container(color: Constants.GreyColor2 ,child: VerticalDivider()),
              Text(weapons.wallPenetration.toString()),
            ]
          ),

          Row(
            children: <Widget>[
              Icon(WeaponDetailsIcons.fire_rate, size: 40,),
              Container(color: Constants.GreyColor2 ,child: VerticalDivider()),
              Text(weapons.fireRate.toString()),
            ]
          ),
                  
          weapons.lightArmor != null ? Row(
            children: <Widget>[
              Text("Type ", style: TextStyle( fontSize: 17),),
              Container(color: Constants.GreyColor2 ,child: VerticalDivider()),
              Text(weapons.weaponType),
            ]
          ) : Container(),

          SizedBox(height: 10),

          weapons.noArmor != null ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("No Armor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
              _damageDetails(weapons.noArmor)
            ]
          ) : Container(),
          
          SizedBox(height: 10),

          weapons.lightArmor != null ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Light Armor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
              _damageDetails(weapons.lightArmor)
            ]
          ) : Container(),

          SizedBox(height: 10),

          weapons.heavyArmor != null ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("High Armor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
              _damageDetails(weapons.heavyArmor)
            ]
          ) : Container(),
          
          // _createIconInfo(WeaponDetailsIcons.magazine, weapons.magazine.toString()),
          // _createIconInfo(WeaponDetailsIcons.fire_rate, weapons.fireRate.toString()),
          // _createIconInfo(WeaponDetailsIcons.wall_penetration, weapons.wallPenetration.toString()),
          // weapons.noArmor != null ? _damageDetails(weapons.noArmor) : Container(),
          // weapons.lightArmor != null ? _damageDetails(weapons.lightArmor) : Container(),
          // weapons.heavyArmor != null ? _damageDetails(weapons.heavyArmor) : Container(),
        ],
      ),
    );
  }

  Widget _damageDetails( DamageDetails damageDetails){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        
        Row(children:<Widget>[Icon(Icons.place, color: Colors.black,), SizedBox(height:10), Text("${damageDetails.damageDistance}")]) ,
        Row(children:<Widget>[Icon(WeaponIcons.view_head_icon, color: Colors.black,), SizedBox(height:10), Text("${damageDetails.headDamage}")]) ,
        Row(children:<Widget>[Icon(WeaponIcons.view_body_icon, color: Colors.black,), SizedBox(height:10), Text("${damageDetails.bodyDamage}")]) ,
        Row(children:<Widget>[Icon(WeaponIcons.view_leg_icon, color: Colors.black,), SizedBox(height:10), Text("${damageDetails.legDamage}")]) ,

      ],
    );
  }
}


class MyCustomClipper extends CustomClipper<Path>{
  @override Path getClip(Size size){
    Path path = new Path();

    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height- 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height-30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}