import 'package:parse_server/parse_server.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Parse parse;

    setUp(() {
      parse = new Parse(new Credentials("appId"), "http://localhost");
    });

    test('First Test', () {
      expect(parse.credentials, isTrue);
    });
  });
}
