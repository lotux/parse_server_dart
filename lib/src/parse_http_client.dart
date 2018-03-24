//import 'package:http/http.dart';
import 'dart:async';
import 'parse_base.dart';

class ParseHTTPClient extends BaseClient {
  final Client _client = new Client();
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
