import 'dart:convert';

import 'package:dmi/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiController{

  Future<dynamic> get(String url,String token) async {
    //Pass headers below
    return http.get(Uri.parse(AppStyle.baseURL+url),
            headers: {"authorization": "Bearer $token"}).then(
            (http.Response response) {
          final int statusCode = response.statusCode;
          //debugPrint("====> response ${response.body.toString()}");

          if (statusCode < 200 || statusCode >= 400 || json == null) {
            throw PlatformException(details: jsonDecode(response.body)["message"],
                code: '$statusCode');
          }
          return json.decode(response.body);
        });
  }

  Future<dynamic> post(String url,Map body,String token) async {
    //Pass headers below
    return http.post(Uri.parse(AppStyle.baseURL+url),
        headers: {"authorization": "Bearer $token"},body: body).then(
            (http.Response response) {
          final int statusCode = response.statusCode;
          //debugPrint("==>token $token\n===>request $body\n====> response ${response.body.toString()}");

          if (statusCode < 200 || statusCode >= 400 || json == null) {
            throw PlatformException(details: jsonDecode(response.body)["message"],
                code: '$statusCode');
          }
          return json.decode(response.body);
        });
  }
}