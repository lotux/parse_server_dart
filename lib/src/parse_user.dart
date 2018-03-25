import 'dart:convert';
import 'dart:async';

import 'parse_base.dart';
import 'parse_http_client.dart';

class User implements ParseBaseObject {
  final String className = '_User';
  final ParseHTTPClient client;
  String password;
  String path;
  Map<String, dynamic> objectData = {};

  String get objectId => objectData['objectId'];
  String get sessionId => objectData['sessionToken'];
  String get username => objectData['username'];
  String get userId => objectData['objectId'];


  User([ParseHTTPClient client])
      : path = "/parse/classes/_User",
        client = client;

  void set(String attribute, dynamic value){
    objectData[attribute] = value;
  }

  Future<dynamic> get(attribute) async {
    final response = this.client.get(client.baseURL + "${path}/${objectId}");
    return response.then((value){
      objectData = JSON.decode(value.body);
      return objectData[attribute];
    });
  }

  Future<dynamic> me(attribute) async {
    final response = this.client.get(
        client.baseURL + "${path}/me",
        headers: {
          "X-Parse-Session-Token": sessionId
        }
    );
    return response.then((value){
      objectData = JSON.decode(value.body);
      return objectData[attribute];
    });
  }

  Map<String, dynamic> _handleResponse(String response){
    Map<String, dynamic> responseData = JSON.decode(response);
    if (responseData.containsKey('objectId')) {
      objectData = responseData;
      this.client.credentials.sessionId = sessionId;
    }
    return responseData;
  }


  void _resetObjectId(){
    if (objectId != null)
      objectData.remove('objectId');
    if (sessionId != null)
      objectData.remove('sessionToken');
  }

  Future<Map<String, dynamic>> signUp([Map<String, dynamic> objectInitialData]) async {
    if(objectInitialData != null) {
      objectData = {}..addAll(objectData)..addAll(objectInitialData);
    }
    _resetObjectId();
    print(objectData);
    final response = this.client.post("${client.baseURL}${path}",
        headers: {
          'X-Parse-Revocable-Session': "1",
        },
        body: JSON.encode(objectData));
    return response.then((value){
      _handleResponse(value.body);
      return objectData;
    });
  }

  Future<Map<String, dynamic>> login() async {
    Uri url = new Uri(
        path: "${client.baseURL}/parse/login",
        queryParameters: {
          "username": objectData['username'],
          "password": objectData['password']
        });

    final response = this.client.post(url,
        headers: {
          'X-Parse-Revocable-Session': "1",
        });
    return response.then((value){
      _handleResponse(value.body);
      return objectData;
    });
  }

  Future<Map<String, dynamic>> verificationEmailRequest() async {
    final response = this.client.post(
        "${client.baseURL}/parse/verificationEmailRequest",
        body: JSON.encode({"email": objectData['email']})
    );
    return response.then((value){
      return _handleResponse(value.body);
    });
  }

  Future<Map<String, dynamic>> requestPasswordReset() async {
    final response = this.client.post(
        "${client.baseURL}/parse/requestPasswordReset",
        body: JSON.encode({"email": objectData['email']})
    );
    return response.then((value){
      return _handleResponse(value.body);
    });
  }

  Future<Map<String, dynamic>> save([Map<String, dynamic> objectInitialData]){
    objectData = {}..addAll(objectData)..addAll(objectInitialData);
    if (objectId == null){
      return signUp(objectData);
    }
    else {
      final response = this.client.put(
          client.baseURL + "${path}/${objectId}",  body: JSON.encode(objectData));
      return response.then((value) {
        return _handleResponse(value.body);
      });
    }
  }

  Future<String> destroy(){
    final response = this.client.delete(
        client.baseURL + "${path}/${objectId}",
        headers: {
          "X-Parse-Session-Token": sessionId
        }
    );
    return response.then((value){
      _handleResponse(value.body);
      return objectId;
    });
  }

  Future<Map<String, dynamic>> all(){
      final response = this.client.get(
          client.baseURL + "${path}"
      );
      return response.then((value) {
        return _handleResponse(value.body);
      });
  }
}

