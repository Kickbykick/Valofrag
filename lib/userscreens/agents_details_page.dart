import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valorant_helper/classlogic/character.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:valorant_helper/shared/loading.dart';
import 'package:valorant_helper/userscreens/detailScreen.dart';

class AgentDetail extends StatefulWidget {
  final String agentName;
  final String agentRole;
  final bool bIsFav;
  AgentDetail({this.agentName, this.agentRole, this.bIsFav});

  @override
  _AgentDetailState createState() => _AgentDetailState();
}

class _AgentDetailState extends State<AgentDetail> { 
  Character character;
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
    
    return  SafeArea(
          child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children:<Widget>[ 
                ClipPath(
                clipper: MyCustomClipper(),
                child: Stack(
                  children: <Widget>[ Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.mirror,
                      colors: [ Constants.WineColor, Constants.BlueishValorant,]),
                    ),
                    child:  Row(
                      children: <Widget>[ 
                        Flexible(flex: 2, child: Container(
                          decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image:  AssetImage("images/agent_${widget.agentName.toLowerCase()}_full.png"), //AssetImage("images/agent_${agentName.toLowerCase()}.jpg"),
                            fit: BoxFit.cover,
                            ),
                        )),),
                        Flexible(flex: 2, child: 
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(widget.agentName.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 30)),
                              Text(widget.agentRole.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 15,)),
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
                      onPressed: () async { setState(() { bFav = !bFav; } ); bFav ? await setFavorite(widget.agentName) : await removeFavorite(widget.agentName); }
                      ),
                    ),
                  )
                  ]
                ),//),
              ),

                SizedBox(height: 20),

                FutureBuilder(
                  future: loadJson(widget.agentName),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(!snapshot.hasData) return Loading();

                    return CreateMoveList(agentData: snapshot.data,);
                  },
                ),

              ]
            ),
          ),
      ),
    );
  }

  Widget characterInfo(String agentName){
    return Text("Let this is my information");
  }

  loadJson(String agentName) async {
    try {
      String data = await rootBundle.loadString('json/agent_${agentName.toLowerCase()}.json');
      var jsonResult = json.decode(data);
      return Character(characterName: jsonResult["agentName"], role: jsonResult["role"], firstAbility: jsonResult["ability1"], secondAbility: jsonResult["ability2"], 
        signatureAbility: jsonResult["signature"], ultimateAbility: jsonResult["ultimate"], agentDetail: jsonResult["agentDetail"],
        firstAbilityLink: jsonResult["ability1Link"], secondAbilityLink: jsonResult["ability2Link"], signatureAbilityLink: jsonResult["signature1Link"], ultimateAbilityLink: jsonResult["ultimate1Link"],
        firstAbilityCost: jsonResult["ability1Credit"], secondAbilityCost: jsonResult["ability2Credit"], signatureAbilityCost: jsonResult["signature1Credit"], ultimateAbilityCost: jsonResult["ultimate1Credit"],
        firstAbilityCharge: jsonResult["ability1Charges"], secondAbilityCharge: jsonResult["ability2Charges"], signatureAbilityCharge: jsonResult["signature1Charges"], ultimateAbilityCharge: jsonResult["ultimate1Charges"]);
    } catch (e) {
      print(e.toString());
    }
    
  }
}

class CreateMoveList extends StatelessWidget {
  final Character agentData;
  CreateMoveList({ this.agentData });

  @override
  Widget build(BuildContext context) {
    bool currColor = DynamicTheme.of(context).data == Constants.lightModeTheme;
    return Column(
      children: <Widget>[

        _createCharacterAbilities(context, currColor ? "images/role_${agentData.role.toLowerCase()}.png" : 
            "images/role_${agentData.role.toLowerCase()}_white.png", "", agentData.agentDetail, -1, -1),
        _createCharacterAbilities(context, currColor ? "images/${agentData.characterName.toLowerCase()}_ability_1_black.png" : 
            "images/${agentData.characterName.toLowerCase()}_ability_1.jpg", agentData.firstAbilityLink, agentData.firstAbility, agentData.firstAbilityCharge, agentData.firstAbilityCost),
        _createCharacterAbilities(context, currColor ? "images/${agentData.characterName.toLowerCase()}_ability_2_black.png" : 
            "images/${agentData.characterName.toLowerCase()}_ability_2.jpg", agentData.secondAbilityLink, agentData.secondAbility, agentData.secondAbilityCharge, agentData.secondAbilityCost),
        _createCharacterAbilities(context, currColor ? "images/${agentData.characterName.toLowerCase()}_ability_3_black.png" : 
            "images/${agentData.characterName.toLowerCase()}_ability_3.jpg", agentData.signatureAbilityLink, agentData.signatureAbility, agentData.signatureAbilityCharge, agentData.signatureAbilityCost),
        _createCharacterAbilities(context, currColor ? "images/${agentData.characterName.toLowerCase()}_ability_ult_black.png" : 
            "images/${agentData.characterName.toLowerCase()}_ability_ult.jpg", agentData.ultimateAbilityLink, agentData.ultimateAbility, agentData.ultimateAbilityCharge, agentData.ultimateAbilityCost),

      ],
    );
  }

  Widget _createCharacterAbilities(context, pictureName, gifLink, agentDetail, int abilityCharge, int abilityCost){
    return GestureDetector(
      onTap: (){
        if(gifLink != "")
        Navigator.push(context, MaterialPageRoute(builder: (_) {return DetailScreen(thePictureName: gifLink);}));
      },
      child: Hero(
        tag: gifLink+pictureName,
        child:  CharacterAbilities(pictureName: pictureName, abilityInfo: agentDetail, abilityCharge: abilityCharge, abilityCost: abilityCost,),
      ),
    );
  }
}

class CharacterAbilities extends StatelessWidget {
  final String pictureName;
  final String abilityInfo;
  final int abilityCharge;
  final int abilityCost;
  CharacterAbilities({this.pictureName, this.abilityInfo, this.abilityCharge, this.abilityCost});

  @override
  Widget build(BuildContext context) {
    String chargeImg = "images/ability_charge_1.png";
    if( abilityCharge == 2 )
      chargeImg = "images/ability_charge_2.png";
    else if( abilityCharge == 3 )
      chargeImg = "images/ability_charge_3.png";

    String abilityCostName = (abilityCost == 6 || abilityCost == 7) ? "$abilityCost Points" : "$abilityCost Credits";
    if(abilityCost == 0)
      abilityCostName = "Free";

    return Card(
      // color: Constants.GreyColor2,
      elevation: 1,
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(flex: 1, child: Column(
              children: <Widget>[
                Container(
                  height: 80,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                  image: new DecorationImage(
                    image: AssetImage(pictureName),
                    fit: BoxFit.cover,
                    ),
                )),

              abilityCharge != -1 ? Container(
                  height: 20,
                  decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: AssetImage(chargeImg),
                    fit: BoxFit.cover,
                    ),
                )) : Container(),

              abilityCost != -1 ? Text(abilityCostName) : Container(),
              ]
            ),),

            Flexible(flex: 3, 
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(abilityInfo)
              ),
            )),
          ]
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path>{
  @override Path getClip(Size size){
    Path path = new Path();

    path.lineTo(0, size.height);
    var endPoint = Offset(size.width-100, size.height);
    var controlPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height-70);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}