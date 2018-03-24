import 'parse_object.dart';
import 'parse_user.dart';
import 'parse_livequery.dart';
import 'parse_http_client.dart';

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
