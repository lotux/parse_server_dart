// TODO: Put public facing types in this file.
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/src/streamed_response.dart';
import 'package:http/src/base_request.dart';
import 'parse_object.dart';
import 'parse_user.dart';
import 'parse_livequery.dart';

class Credentials {
  final String applicationId;
  final String masterKey;
  String sessionId;

  Credentials(this.applicationId, [this.masterKey]);

  @override
  String toString() => "${applicationId}";

}

abstract class ParseBaseObject {
  final String className;
  final ParseHTTPClient client;
  String path;
  Map<String, dynamic> objectData;

  String get objectId => objectData['objectId'];

  void _handleResponse(Map<String, dynamic> response){}

  ParseBaseObject(String this.className, [ParseHTTPClient this.client]);
}

class ParseHTTPClient extends http.BaseClient {
  final http.Client _client = new http.Client();
  final String _userAgent = "Dart Parse SDK 0.1";
  String baseURL;
  String liveQueryURL;
  User currentUser;
  Credentials credentials;
  ParseHTTPClient();


  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['user-agent'] = _userAgent;
    request.headers['X-Parse-Application-Id'] = credentials.applicationId;
    request.headers['Content-Type']= 'application/json';
    return _client.send(request);
  }
}

class Parse {
  Credentials credentials;
  final String liveQueryServerURL;
  final String serverURL;
  final ParseHTTPClient client = new ParseHTTPClient();

  Parse(Credentials credentials, String serverURL,[String liveQueryServerURL])
    : credentials = credentials,
      serverURL = serverURL,
      liveQueryServerURL = liveQueryServerURL {
      client.baseURL = serverURL;
      client.liveQueryURL ??= liveQueryServerURL;
      client.credentials = credentials;
  }

  ParseObject _parseObject;
  User _user;
  LiveQuery _liveQuery;

  ParseObject object(objectName) {
    return _parseObject = new ParseObject(objectName, client);
  }

  User user() {
    return _user = new User(client);
  }
  LiveQuery liveQuery() {
    return _liveQuery = new LiveQuery(client);
  }

}
