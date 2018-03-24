import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/src/streamed_response.dart';
import 'package:http/src/base_request.dart';
import 'parse_base.dart';

class ParseHTTPClient extends http.BaseClient {
  final http.Client _client = new http.Client();
  final String _userAgent = "Dart Parse SDK 0.1";
  String baseURL;
  String liveQueryURL;
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
