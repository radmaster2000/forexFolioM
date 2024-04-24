import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

String base_url="https://journalapis.onrender.com/api/v1/getAllCurrencies";
//String currencyEndpoint="getAllCurrencies";
String api_key="fca_live_noUh6KCB9LAX8QER7658dSYRpODxHYajdHgL5aWz";
Dio _dio =Dio();
Future getCurrency()async{
  String url=base_url;
  try {
    final response = await _dio.get(url);
    return response.data["Currency"];
  } catch (error) {
    // Handle error here
    throw error; // Or rethrow for further handling
  }
}
Future getCurrncies2()async{
 // String url=base_url;
  debugPrint("currency api called");
  try {
    final response = await _dio.get("https://api.freecurrencyapi.com/v1/latest?apikey=$api_key");
    return response.data["data"];
  } catch (error) {
    // Handle error here
    throw error; // Or rethrow for further handling
  }
}