//import 'package:web_socket_channel/io.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
import "package:websockets/websockets.dart";
import './parse_base.dart';
import "dart:convert";
import 'dart:io';
import 'parse_http_client.dart';

class LiveQuery {
  final ParseHTTPClient client;
  WebSocket channel;
  Map<String, dynamic> connectMessage;
  Map<String, dynamic> subscribeMessage;
  Map<String, Function> eventCallbacks = {};

  LiveQuery(ParseHTTPClient client)
  : client = client {
    connectMessage = {
      "op": "connect",
      "applicationId": client.credentials.applicationId,
    };

    subscribeMessage = {
      "op": "subscribe",
      "requestId": 1,
      "query": {
        "className": null,
        "where": {},
      }
    };

  }

  subscribe(String className) async {
    channel = await WebSocket.connect(client.liveQueryURL);
    channel.add(JSON.encode(connectMessage));
    subscribeMessage['query']['className'] = className;
    channel.add(JSON.encode(subscribeMessage));
    channel.listen((message) {
      Map<String, dynamic> actionData = JSON.decode(message);
      if (eventCallbacks.containsKey(actionData['op']))
          eventCallbacks[actionData['op']](actionData);
    });
  }

  void on(String op, Function callback){
    eventCallbacks[op] = callback;
  }

  void close(){
    channel.sink.close();
  }

}