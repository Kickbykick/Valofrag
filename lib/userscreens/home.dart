import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valorant_helper/classlogic/weapons.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:valorant_helper/shared/loading.dart';
import 'package:valorant_helper/shared/pistol_gun_icons.dart';
import 'package:valorant_helper/shared/utility_icons_icons.dart';
import 'package:valorant_helper/userscreens/explore.dart';
import 'package:valorant_helper/userscreens/explore_maps.dart';
import 'package:valorant_helper/userscreens/helppage.dart';
import 'package:valorant_helper/userscreens/media_page.dart';
import 'package:valorant_helper/userscreens/tabnavigator.dart';
import 'package:valorant_helper/userscreens/webview.dart';

List<String> allData = ["Tactical Knife", "Classic", "Shorty", "Frenzy", "Ghost", "Sheriff"
    , "Stinger", "Spectre", "Bucky", "Judge", "Bulldog", "Guardian", "Phantom"
    , "Vandal", "Marshal", "Operator", "Ares", "Odin", "Light Shield", "Heavy Shield", 
    "Breach", "Cypher", "Brimstone", "Jett", "Sova", "Omen", "Phoenix", "Raze", "Sage", "Viper"];

class Home extends StatefulWidget {
  final ThemeData theme;
  Home({this.theme});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> { 
  List<Widget> pages;
  Widget currentPage;
  
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "HomePage": GlobalKey<NavigatorState>(),
    "Agents": GlobalKey<NavigatorState>(),
    "Weapons": GlobalKey<NavigatorState>(),
    "Maps": GlobalKey<NavigatorState>(),
    "Media": GlobalKey<NavigatorState>(),
  };
  List<String> allPages = ["HomePage", "Agents", "Weapons", "Maps", "Media"];

  String currentTab = "HomePage";
  
final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;

  getFavourite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("favorite");
  }

  @override
  void initState() {
    pages = [HomePage(), Explore(), ExploreWeapons(), ExploreMaps(), MediaPage()];

    currentPage = pages[0];
    super.initState();
  }
  
  void _onPageChanged(int index, String currPage) {
    setState(() {
      currentTab = currPage;
      currentPage = pages[index];
      _selectedIndex = index;
    });
  }

  PageController pageController = PageController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {

    return SafeArea(    
          child: WillPopScope(
            onWillPop: () async => !await navigatorKeys[currentTab].currentState.maybePop(),
            child: Scaffold(
        
            // backgroundColor: greyColor,
                    
            body: Stack(children: <Widget>[
              _buildOffstageNavigator("HomePage"),
              _buildOffstageNavigator("Agents"),
              _buildOffstageNavigator("Weapons"),
              _buildOffstageNavigator("Maps"),
              _buildOffstageNavigator("Media"),
            ]),
            // PageStorage(bucket: bucket, child: pagesKeepState[_selectedIndex],),
            // PageView(
            //   controller: pageController,
            //   onPageChanged: _onPageChanged,
            //   children: pages,
            //   physics: NeverScrollableScrollPhysics(),
            // ),
            //body: currentPage,
            bottomNavigationBar: BottomNavigationBar(
                  //elevation: 1,
                  // backgroundColor: DynamicTheme.of(context).data.canvasColor,
                  // fixedColor: Colors.black,
                  //physics: const NeverScrollableScrollPhysics(),
                  selectedItemColor: Constants.WineColor,
                  // unselectedItemColor: Colors.wh/ite,
                  onTap: (int index) { _onPageChanged(index, allPages[index]); },
                  currentIndex: _selectedIndex, // this will be set when a new tab is tapped
                  items: [
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.home),
                      title: new Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.people), //try people
                      title: new Text('Agents'),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(PistolGun.pistol_gun,),
                      title: new Text('Weapons'),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.map),
                      title: new Text('Maps'),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.local_play),
                      title: new Text('Media'),
                    ),
                ],
                type: BottomNavigationBarType.fixed,
              ),
        ),
          ),
    );
  }

  Widget _buildOffstageNavigator(String newTab) {
    Widget child = TabNavigatorHome(navigatorKey: navigatorKeys[newTab],);
    if(newTab == "Agents")
      child = TabNavigator(navigatorKey: navigatorKeys[newTab],);
    else if(newTab == "Weapons")
      child = TabNavigatorWeapons(navigatorKey: navigatorKeys[newTab],);
    else if(newTab == "Maps")
      child = TabNavigatorMap(navigatorKey: navigatorKeys[newTab],);
    else if(newTab == "Media")
      child = TabNavigatorMedia(navigatorKey: navigatorKeys[newTab],);
    
    return Offstage(
      offstage: currentTab != newTab,
      child: child,
    );
  }
}

class HomePage extends StatefulWidget {
  final ThemeData theme;
  final ValueChanged<NavigateInfo> onPush;
  HomePage({Key key, this.theme, this.onPush}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String currImg = "";
  List<String> favoriteList = List<String> ();

  setSharedPrefs(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dynamicTheme', themeName);
    if(themeName == "Light Mode")
      DynamicTheme.of(context).setThemeData(Constants.lightModeTheme);
    else
      DynamicTheme.of(context).setThemeData(Constants.darkModeTheme);
  }
  
    getFavouriteList() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getStringList("favorite");
    }

    Future <bool> bIsFavorite(String fav) async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList("favorite");
    
    if(favoriteList == null) { return false;}
    else return favoriteList.contains(fav) ? true : false;
  }

  loadJson(String weaponName) async {  
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

  Widget _buildCard(String agentName){
    String agentRole = "Controller";
    if(agentName == "Cyher" || agentName == "Sage")
      agentRole = "Sentinel";
    else if(agentName == "Jett" || agentName == "Raze" || agentName == "Pheonix")
      agentRole = "Duelist";
    else if(agentName == "Sova" || agentName == "Brimstone")
      agentRole = "Initiator";
      
    if(isAgent(agentName))
      currImg = "images/agent_${agentName.toLowerCase()}_full.png";
    else if(isWeapon(agentName))
      currImg = createImageName(context, agentName);
    else if(isMap(agentName))
      currImg = "images/map_${agentName.toLowerCase()}.jpeg";

    // String theImg = ;
    return Padding(
      padding: EdgeInsets.only(top:15, bottom: 5.0, left:5.0, right:5.0),
      child: InkWell(
        onTap:() async {
          bool bIsFavourite = await bIsFavorite(agentName);
          

          if(isAgent(agentName))
            widget.onPush(NavigateInfo(bFavPush: bIsFavourite, sObjName: agentName, type: "Agent", role: agentRole));
          else if(isWeapon(agentName)){
            Weapons weapon = await loadJson(agentName);
            widget.onPush(NavigateInfo(bFavPush: bIsFavourite, sObjName: agentName, type: "Weapon", role: agentRole, weaponInfo: weapon));
          } else if(isMap(agentName))
            widget.onPush(NavigateInfo(bFavPush: bIsFavourite, sObjName: agentName, type: "Map"));
          
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
                    image:  AssetImage(currImg),
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

  @override
  Widget build(BuildContext context) {
    bool bLightMode =  DynamicTheme.of(context).data == Constants.lightModeTheme ? true:false;
    // getFavouriteList();
    

    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Constants.OffBlack,
      appBar: AppBar(
          leading: 
              IconButton(
                icon: Icon(Icons.settings, color: Constants.WineColor,), 
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
          
          title: Text("Valofrag", style: TextStyle(color: Constants.WineColor),), 
            
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed:  (){ Navigator.of(context).push(_createRoute( HelpPage() )); },)
          ],
          automaticallyImplyLeading: false,
      ),
      drawer: Container(
        width: 190,
        child: Drawer(
          child: Container(
            // color: Colors.transparent,
            child: Column(
              
              children: <Widget>[
                SizedBox(height: 20,),
                ListTile(
                  title: Text("About", style: TextStyle(fontSize: 16)),
                  leading: Icon(Icons.help, color: Constants.WineColor),
                  onTap: (){ 
                    Navigator.of(context).push(_createRoute( AboutPage() ));
                    // Navigator.of(context).pop();
                    
                  },
                ),
                Divider(color: Constants.GreyColor1,),
                ListTile(
                  title: Text("Ranks", style: TextStyle(fontSize: 16)),
                  leading: Icon(Icons.star, color: Constants.WineColor),
                  onTap: (){ 
                    Navigator.of(context).push(_createRoute( Ranks() ));
                    
                  },
                ),
                Divider(color: Constants.GreyColor1,),
                ListTile(
                  title: Text("Version Log", style: TextStyle(fontSize: 16)),
                  leading: Icon(Icons.build, color: Constants.WineColor),
                  onTap: (){ 
                    Navigator.of(context).push(_createRoute( Version() ));
                    
                  },
                ),
                Divider(color: Constants.GreyColor1,),
                ListTile(
                  title: Text("DPI Calculator", style: TextStyle(fontSize: 16)),
                  leading: Icon(Icons.adjust, color: Constants.WineColor),
                  onTap: (){ 
                    Navigator.of(context).push(_createRoute( Calculator() ));
                    
                  },
                ),
                Divider(color: Constants.GreyColor1,),
                ListTile(
                  title: InkWell(
                    onTap: () => setState(() { bLightMode = !bLightMode; }),
                    child: Switch.adaptive(
                      activeColor: Constants.WineColor,
                      value: bLightMode, 
                      onChanged:(val) { 
                        if( val )
                        { setSharedPrefs("Light Mode"); }
                        else
                        { setSharedPrefs("Dark Mode"); }

                        setState(() {
                          bLightMode = val;
                        });
                        
                      }
                    ),
                  ),
                  leading: Text("Light Mode", style: TextStyle(fontSize: 16)),
              
                ),
              ]
            ),
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),

            Container( 
                height: 70,
                width: 70,
              decoration: new BoxDecoration(
              image: new DecorationImage(
                image: AssetImage("images/valorant_logo_transparent.png"),
                fit: BoxFit.contain 
                ),
          )),
  
          SizedBox(height: 10),
  
          Container(
            // color: DynamicTheme.of(context).data.textTheme.title.color,
            padding: EdgeInsets.all(16.0),
            height: 70,
            child: TextField(
              obscureText: true,
              readOnly: true,
              showCursor: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon:Icon(Icons.search) ,
                labelText: 'Search ...',
              ),
              onTap: () => showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              ),
            ),
          ),

          FutureBuilder(
            future: getFavouriteList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) Loading();
              
              favoriteList = snapshot.data;
              
              return 
              favoriteList == null || favoriteList.length == 0 ? 
              Padding( padding: EdgeInsets.all(30), child: Text("Start picking your favorites ......",)) : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemCount: favoriteList == null ? 0 : favoriteList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 1,
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _buildCard(favoriteList[index]);
                }
              );
            },
          ),
        ],)
      ),
    );
  }
}

//----------------------------------------------------------------------//

Route _createRoute(nextWidget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class AboutPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About", style: TextStyle(color: Constants.WineColor),),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text("Developed by Kickbykick",
                    style: TextStyle(fontFamily: 'Verela', fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
            
            SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:<Widget>[
                InkWell(child: _createMediaAd(UtilityIcons.instagram_filled, "Instagram"), onTap:(){Navigator.of(context).push(_createRoute( WebviewPage(webViewName: "Instagram",websiteLink: "https://www.instagram.com/kickbykick/",) ));} ,),
                InkWell(child:_createMediaAd(UtilityIcons.twitchlogo, "Twitch"), onTap:(){Navigator.of(context).push(_createRoute( WebviewPage(webViewName: "Twitch",websiteLink: "https://www.twitch.tv/kickbykick",) ));}  ,),
                InkWell(child:_createMediaAd(UtilityIcons.twitter_bird, "Twitter"), onTap:(){Navigator.of(context).push(_createRoute( WebviewPage(webViewName: "Twitter",websiteLink: "https://twitter.com/Kiibati",) ));}  ,),
                InkWell(child:_createMediaAd(UtilityIcons.youtube, "Youtube"), onTap:(){Navigator.of(context).push(_createRoute( WebviewPage(webViewName: "Youtube",websiteLink: "https://www.youtube.com/channel/UCH7_4FfakRK4Nx7tFcgLSPQ",) ));}  ,),
              ]
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: Text("Upcoming Features",
                style: TextStyle(fontFamily: 'Verela', fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            _createList(),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Align(
              alignment: Alignment.center,
              child: RichText(
                text: new TextSpan(text: 'Send bug reports and feature ideas - ', style: TextStyle(color: DynamicTheme.of(context).data.textTheme.title.color), children: [
                  new TextSpan(
                    text: 'EMAIL', style: TextStyle(color: Constants.WineColor),
                    recognizer: new TapGestureRecognizer()..onTap = () => _launchURL('kiibatitoo2@gmail.com', 'Bug Report / Feature Idea', 'Hello Kick.'),
                  )
                ]),
              ),
            ),
          ]
        ),
          ),
        ]
      )
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  Widget _createMediaAd(IconData iconData, String info){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(icon: Icon(iconData, color: Constants.WineColor,), onPressed: null),
        Text(info.toUpperCase())
      ],
    );
  }

  Widget _createList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("- Valorant character tips."),
        Text("- Valorant map tips."),
        Text("- Weapon videos."),
        Text("- Etc..."),
      ],
    );
  }
}

class Version extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Version Log", style: TextStyle(color: Constants.WineColor),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Version 1.0", //textAlign: TextAlign.left,
              style: TextStyle(fontFamily: 'Verela', fontSize: 30, fontWeight: FontWeight.bold),
            ),

            _createList(),
            Divider(),
          ]
        ),
      )
    );
  }

  Widget _createList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("- Every character and move list."),
        Text("- Every weapon and weapon stats."),
        Text("- Character ability gifs."),
        Text("- Every map included."),
      ],
    );
  }
}


enum EGames { overwatch, apex, csgo, rainbowsix }

class Calculator extends StatefulWidget {
  Calculator({Key key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  EGames _currGame = EGames.overwatch;
  double _currDivider = 3.18181818;
  double inputValue = 0.0;
  double _sensResult = 0.0;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DPI Calculator", style: TextStyle(color: Constants.WineColor),),
        ),
        body: SingleChildScrollView(
        child: Column(
              children: <Widget>[ ListTile(
                title: const Text('Overwatch'),
                leading: Radio(
                  value: EGames.overwatch,
                  groupValue: _currGame,
                  onChanged: (EGames value) {
                    setState(() {
                      _currGame = value;
                      _currDivider = 10.6;
                      _sensResult = inputValue != null ? double.parse((inputValue / _currDivider).toStringAsFixed(4)) : 0;
                    });
                  },
                ),
              ),
            
            ListTile(
              title: const Text('Apex'),
              leading: Radio(
                value: EGames.apex,
                groupValue: _currGame,
                onChanged: (EGames value) {
                  setState(() {
                    _currGame = value;
                    _currDivider = 3.18181818;
                    _sensResult = inputValue != null ? double.parse((inputValue / _currDivider).toStringAsFixed(4)) : 0;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Rainbow Six'),
              leading: Radio(
                value: EGames.rainbowsix,
                groupValue: _currGame,
                onChanged: (EGames value) {
                  setState(() {
                    _currGame = value;
                    _currDivider = 1.2;
                    _sensResult = inputValue != null ? double.parse((inputValue / _currDivider).toStringAsFixed(4)) : 0;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('CS:GO'),
              leading: Radio(
                value: EGames.csgo,
                groupValue: _currGame,
                onChanged: (EGames value) {
                  setState(() {
                    _currGame = value;
                    _currDivider = 3.18181818;
                    _sensResult = inputValue != null ? double.parse((inputValue / _currDivider).toStringAsFixed(4)) : 0;
                  });
                },
              ),
            ),
            
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'VALORANT SENSITIVITY = ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: '$_sensResult', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ),

            Container(
              width: 100,
              child: TextFormField(
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.WineColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.WineColor),
                  ),
                  counterStyle: new TextStyle(color: Constants.WineColor),
                ),
                maxLength: 30,
                onChanged: (val) {setState(() {
                  inputValue = double.tryParse(val);
                  _sensResult = inputValue != null ? double.parse((inputValue / _currDivider).toStringAsFixed(4)) : 0;
                });
                }
              ),
            ),          
          ],
      ),
        ),
    );
  }
}

class Ranks extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ranks", style: TextStyle(color: Constants.WineColor),),
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_createRank("images/rank_bronze_1.png", "BRONZE 1"), _createRank("images/rank_bronze_2.png", "BRONZE 2"), _createRank("images/rank_bronze_3.png", "BRONZE 3"),],),
              Divider(),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_createRank("images/rank_diamond_1.png", "Diamond 1"), _createRank("images/rank_diamond_2.png", "Diamond 2"), _createRank("images/rank_diamond_3.png", "Diamond 3"),],),
              Divider(),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_createRank("images/rank_gold_1.png", "gold 1"), _createRank("images/rank_gold_2.png", "gold 2"), _createRank("images/rank_gold_3.png", "gold 3"),],),
              Divider(),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_createRank("images/rank_iron_1.png", "iron 1"), _createRank("images/rank_iron_2.png", "iron 2"), _createRank("images/rank_iron_3.png", "iron 3"),],),
              Divider(),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_createRank("images/rank_immortal_1.png", "immortal 1"), _createRank("images/rank_immortal_2.png", "immortal 2"), _createRank("images/rank_immortal_3.png", "immortal 3"),],),
              Divider(),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_createRank("images/rank_platinum_1.png", "platinum 1"), _createRank("images/rank_platinum_2.png", "platinum 2"), _createRank("images/rank_platinum_3.png", "platinum 3"),],),
              Divider(),
              _createRank("images/rank_valorant.png", "VALORANT")
            ]
          ),
        ),
      )
    );
  }

  Widget _createRank(String rankImg, String rankName){
    return Container(
      height: 150,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children:<Widget>[
          Flexible(flex:3,
            child: Container(
              decoration: new BoxDecoration(
              image: new DecorationImage(
                image:  AssetImage(rankImg),
                fit: BoxFit.contain,
                ),
            )),
          ),

          Flexible(flex:1,child: Text(rankName.toUpperCase())),
        ]
      ),
      
    );
  }
}