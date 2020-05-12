// (c) 2020 Kiibati
// Unauthorized copying of this file, via any medium is strictly prohibited
// This code is licensed under MIT license (see LICENSE.txt for details)

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:valorant_helper/shared/loading.dart';
import 'package:valorant_helper/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ThemeData currThemeData;

  Future<void> getDefault() async {
    String dynTheme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynTheme = prefs.getString("dynamicTheme") ?? 'Light Mode';
    if(dynTheme == "Light Mode")
      currThemeData = Constants.lightModeTheme;
    else
      currThemeData = Constants.darkModeTheme;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.GreyColor2, // status bar color
    ));
  
    return FutureBuilder(
      future: getDefault(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(currThemeData == null) return Loading();

        return DynamicTheme(
          defaultBrightness: currThemeData.brightness,
          data: (Brightness brightness){ getDefault(); return currThemeData; },
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: Wrapper(theme: theme),
            );
          }
          
        );
      },
    );
    
   }
}