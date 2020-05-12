import 'package:flutter/material.dart';
import 'package:valorant_helper/classlogic/weapons.dart';
import 'package:valorant_helper/userscreens/agents_details_page.dart';
import 'package:valorant_helper/userscreens/explore.dart';
import 'package:valorant_helper/userscreens/explore_maps.dart';
import 'package:valorant_helper/userscreens/home.dart';
import 'package:valorant_helper/userscreens/map_detail_screen.dart';
import 'package:valorant_helper/userscreens/media_page.dart';
import 'package:valorant_helper/userscreens/weapon_details_page.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  void _push(BuildContext context, bool bIsFav, String agentName, String agentRole) {
    var routeBuilders = _routeBuilders(context, bIsFav:  bIsFav, agentName: agentName, agentRole: agentRole);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {bool bIsFav, String agentName, String agentRole}) {
    return {
      TabNavigatorRoutes.root: (context) => Explore(
            onPush: (agentInfo) =>
                _push(context, agentInfo.bFavPush, agentInfo.sObjName, agentInfo.role),
          ),
      TabNavigatorRoutes.detail: (context) => AgentDetail(
            agentName: agentName,
            bIsFav: bIsFav,
            agentRole: agentRole,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}


class TabNavigatorWeapons extends StatelessWidget {
  TabNavigatorWeapons({this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  void _push(BuildContext context, bool bIsFav, String weaponName, String role, Weapons weaponInfo) {
    var routeBuilders = _routeBuilders(context, bIsFav:  bIsFav, weaponName: weaponName, role: role, weaponInfo: weaponInfo);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {bool bIsFav, String weaponName, String role, Weapons weaponInfo}) {
    
    return {
      TabNavigatorRoutes.root: (context) => ExploreWeapons(
            onPush: (weaponInfo) =>
                _push(context, weaponInfo.bFavPush, weaponInfo.sObjName, weaponInfo.role, weaponInfo.weaponInfo),
          ),
      TabNavigatorRoutes.detail: (context) => WeaponDetail(
            weaponName: weaponName,
            bIsFav: bIsFav,
            weaponDetail: weaponInfo,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context));
      });
  }
}

class TabNavigatorHome extends StatelessWidget {
  TabNavigatorHome({this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  void _push(BuildContext context, bool bIsFav, String agentName, String agentRole, String type, Weapons weaponInfo) {
    var routeBuilders = _routeBuilders(context, bIsFav:  bIsFav, agentName: agentName, agentRole: agentRole, type: type, weaponInfo: weaponInfo);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {bool bIsFav, String agentName,  String agentRole, String type, Weapons weaponInfo}) {

    if( type == "Agent")
    return {
      TabNavigatorRoutes.root: (context) => HomePage(
            onPush: (agentInfo) =>
                _push(context, agentInfo.bFavPush, agentInfo.sObjName, agentInfo.role, agentInfo.type, agentInfo.weaponInfo),
          ),
      TabNavigatorRoutes.detail: (context) => AgentDetail(
            agentName: agentName,
            bIsFav: bIsFav,
            agentRole: agentRole,
          ),
    };
    else if(type == "Weapon")
    return {
      TabNavigatorRoutes.root: (context) => HomePage(
            onPush: (agentInfo) =>
                _push(context, agentInfo.bFavPush, agentInfo.sObjName, agentInfo.role, agentInfo.type, agentInfo.weaponInfo),
          ),
      TabNavigatorRoutes.detail: (context) => WeaponDetail(
            weaponName: agentName,
            bIsFav: bIsFav,
            weaponDetail: weaponInfo,
          ),
    };
    else
    return {
      TabNavigatorRoutes.root: (context) => HomePage(
            onPush: (agentInfo) =>
                _push(context, agentInfo.bFavPush, agentInfo.sObjName, agentInfo.role, agentInfo.type, agentInfo.weaponInfo),
          ),
      TabNavigatorRoutes.detail: (context) => MapDetailScreen(
            bIsFav: bIsFav,
            mapName: agentName,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}

class TabNavigatorMap extends StatelessWidget {
  TabNavigatorMap({this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  void _push(BuildContext context, bool bIsFav, String mapName) {
    var routeBuilders = _routeBuilders(context, bIsFav:  bIsFav, mapName:  mapName,);
    
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {bool bIsFav, String mapName}) {
    return {
      TabNavigatorRoutes.root: (context) => ExploreMaps(
            onPush: (mapInfo) =>
                _push(context, mapInfo.bFavPush, mapInfo.sObjName),
          ),
      TabNavigatorRoutes.detail: (context) => MapDetailScreen(
            bIsFav: bIsFav,
            mapName: mapName,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}

class TabNavigatorMedia extends StatelessWidget {
  TabNavigatorMedia({this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  void _push(BuildContext context, String mapName) {
    var routeBuilders = _routeBuilders(context, mapName:  mapName,);
    
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, { String mapName}) {
    return {
      TabNavigatorRoutes.root: (context) => MediaPage(
            onPush: (mapInfo) =>
                _push(context, ""),
          ),
      TabNavigatorRoutes.detail: (context) => MapDetailScreen(
            mapName: mapName,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}