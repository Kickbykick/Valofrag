import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valorant_helper/shared/contants.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
              //key: key,
            backgroundColor: Colors.black54,
            children: <Widget>[
              Center(
                child: Column(children: [
                  CircularProgressIndicator(backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(Constants.WineColor),),
                  SizedBox(height: 10,),
                  Text("Please Wait....",style: TextStyle(color: Constants.WineColor),)
                ]),
              )
            ]));
      });
  }

  static Future<void> imageDialog(BuildContext context, String gifLink) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(gifLink,),
            // Transform.rotate(
            //   angle: pi/2,
            //   child:Image.network(gifLink,),
            // )
          );
    });
  }

  static Future<void> changeThemeDialog(BuildContext context) async {
    var _theme = "Light Mode";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dynTheme = prefs.getString("dynamicTheme") ?? 'Light Mode';
    if(dynTheme != "Light Mode")
      _theme = "Dark Mode";

    List<String> _listOfThemes = ['Light Mode', 'Dark Mode'];
    
    setSharedPrefs(String themeName) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('dynamicTheme', themeName);
      if(themeName == "Light Mode")
        DynamicTheme.of(context).setThemeData(Constants.lightModeTheme);
      else
        DynamicTheme.of(context).setThemeData(Constants.darkModeTheme);
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
          // backgroundColor: Colors.black,
          title: Text("Search Filter", style: TextStyle(),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            Row(
              children: <Widget> [
                Text("Filter", style: TextStyle(),),
                SizedBox(width:30),
              
              DropdownButton<String>(
                value: _theme.isNotEmpty ? _theme : null,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                //style: TextStyle(color: DynamicTheme.of(context).data.textTheme.title.color),
                onChanged: (String newValue) {
                  if(newValue == "Light Mode")
                  { setSharedPrefs("Light Mode"); }
                  else
                  { setSharedPrefs("Dark Mode"); }
                },
                items: _listOfThemes
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
              ),
            ]
            ),

           
          ],),
        );
        },
        );
      });
  }

 
}