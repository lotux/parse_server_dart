import 'dart:convert';
import 'dart:async';

import 'parse_base.dart';
import 'parse_http_client.dart';



class ParseObject implements ParseBaseObject {
  final String className;
  final ParseHTTPClient client;
  String path;
  Map<String, dynamic> objectData = {};

  String get objectId => objectData['objectId'];
  ParseObject(String this.className, [ParseHTTPClient this.client]) {
    path = "/parse/classes/${className}";
  }

  Future<Map> create([Map<String, dynamic> objectInitialData]) async {
    objectData = {}..addAll(objectData)..addAll(objectInitialData);

    final response = this.client.post("${client.baseURL}${path}", body: JSON.encode(objectData));
    return response.then((value){
      objectData = JSON.decode(value.body);
      return objectData;
    });
  }

  Future<dynamic> get(attribute) async {
      final response = this.client.get(client.baseURL + "${path}/${objectId}");
      return response.then((value){
        objectData = JSON.decode(value.body);
        return objectData[attribute];
      });
  }

  void set(String attribute, dynamic value){
    objectData[attribute] = value;
  }

  Future<Map> save([Map<String, dynamic> objectInitialData]){
    objectData = {}..addAll(objectData)..addAll(objectInitialData);
    if (objectId == null){
        return create(objectData);
    }
    else {
      final response = this.client.put(
          client.baseURL + "${path}/${objectId}",  body: JSON.encode(objectData));
      return response.then((value) {
        objectData = JSON.decode(value.body);
        return objectData;
      });
    }
  }

  Future<String> destroy(){
    final response = this.client.delete(client.baseURL + "${path}/${objectId}");
    return response.then((value){
      return JSON.decode(value.body);
    });
  }
}

