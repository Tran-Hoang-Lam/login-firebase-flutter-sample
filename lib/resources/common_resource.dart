import 'package:flutter/material.dart';

class CommonResource {
  static DecorationImage backgroundImage = DecorationImage(
      image: ExactAssetImage('asset/blur-background-6z-800x1280.jpg'),
      fit: BoxFit.cover);

  static Image defaultLogoImage = Image.asset('asset/flutter-logo-round.png');

  static Widget logo(String url) => Padding(
      padding: EdgeInsets.only(top: 100.0, bottom: 20.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90.0,
        child: url != null ? Image.network(url) : defaultLogoImage,
      ));

  static Widget defaultLogo = Padding(
      padding: EdgeInsets.only(top: 100.0, bottom: 20.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90.0,
        child: defaultLogoImage,
      ));
}
