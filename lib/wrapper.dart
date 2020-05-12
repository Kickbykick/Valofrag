import 'package:flutter/material.dart';
import 'package:valorant_helper/userscreens/home.dart';

class Wrapper extends StatelessWidget {
  final ThemeData theme;
  Wrapper({this.theme});

  @override
  Widget build(BuildContext context) {
    return Home(theme: theme);
  }
}