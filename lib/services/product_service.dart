// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_crud/model/product_model.dart';

class ProductService {
  //Dio paketinin ozelligi ile base url tanimlamasi yapilir
  final Dio _dio;

  ProductService()
      : _dio =
            (Dio(BaseOptions(baseUrl: "http://www.sampleapi.somee.com/api/")));

  //[HTTPget]
  // bu fonksiyon geriye bir ProductModel verecegi icin tipini aListModel olarak tanimliyoruz
  Future<List<ProductModel>?> getProducts() async {
    try {
      var response = await _dio.get('products');

      //eger response 200 ise
      if (response.statusCode == HttpStatus.ok) {
        //_datas degiskenini responsedan gelen dataya esitle
        final _datas = response.data;

        //eger donen data bir liste ise
        if (_datas is List) {
          //bu listeyi product modeline mapleyip return et
          return _datas.map((e) => ProductModel.fromJson(e)).toList();
        }
      }
      //Dio Error sinifini kullanarak eger hata mesaji varsa goster
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        if (kDebugMode) {
          print(e.response?.statusCode);
        }
      } else {
        if (kDebugMode) {
          print(e.message);
        }
      }
    }
  }

  //[HTTP Post]
  Future<bool> postProducts(ProductModel productModel) async {
    try {
      var response = await _dio.post('products',
          data: json.encode(productModel.toJsonPost()));

      return response.statusCode == HttpStatus.created;
    } on DioError catch (e) {
      print(e.response?.data);
    }
    return false;
  }

  //[HTTP put]
  Future<bool> putProducts(ProductModel? productModel, int? id) async {
    try {
      var response = await _dio.put('products/${id}', data: productModel);
      return response.statusCode == HttpStatus.noContent;
    } catch (e) {
      print("Hata");
    }
    return false;
  }

  //[HTTP del]
  Future<bool> delProducts(int? id) async {
    try {
      var response = await _dio.delete('products/${id}');
      return response.statusCode == HttpStatus.noContent;
    } catch (e) {
      print("Hata");
    }
    return false;
  }
}
