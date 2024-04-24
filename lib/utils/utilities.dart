import 'package:flutter/cupertino.dart';

getHeight(BuildContext context,double hgt){
  return MediaQuery.of(context).size.height*hgt;
}
getWidth(BuildContext context,double wdt){
  return MediaQuery.of(context).size.width*wdt;
}