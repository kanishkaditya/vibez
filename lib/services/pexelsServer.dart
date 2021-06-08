import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wallpaper_app/constants/constants.dart';
import 'package:wallpaper_app/constants/custom_exceptions.dart';
import 'package:wallpaper_app/models/imagesmodel.dart';

abstract class PexelsServer {
  Future<Images> getBestWallpapers();
}

class PexelsServerBase {
  Future<Response> _getData({required String url}) async {
    // print(url);
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": api_key,
    });
    return response;
  }

  Future<Images> getBestWallpapers() async {
    Response _response = await _getData(url: bestWallpaperUrl);
    try {
      if (_response.statusCode == 500) {
        throw SocketException("internet");
      }
    } on SocketException {
      throw CustomException(message: "Internet error"); //"Internet error"
    } on FormatException {
      throw CustomException(message: 'Try Again Later'); //"Try Again Later"
    } on HttpException {
      throw CustomException(message: 'Server Error'); //"Server Error"
    }
    final _results = jsonDecode(_response.body);
    // print(_results);

    Map<String, dynamic> map = _results as Map<String, dynamic>;
    Images image = Images.fromMap(map);
    // print(image.photos.first.src.portrait);
    return image;
  }
  Future<Images> getByCategories(String categories) async {
    Response _response = await _getData(url: searchBaseUrl+categories);
    try {
      if (_response.statusCode == 500) {
        throw SocketException("internet");
      }
    } on SocketException {
      throw CustomException(message: "Internet error"); //"Internet error"
    } on FormatException {
      throw CustomException(message: 'Try Again Later'); //"Try Again Later"
    } on HttpException {
      throw CustomException(message: 'Server Error'); //"Server Error"
    }
    final _results = jsonDecode(_response.body);
    // print(_results);

    Map<String, dynamic> map = _results as Map<String, dynamic>;
    Images image = Images.fromMap(map);
    // print(image.photos.first.src.portrait);
    return image;
  }
}
