import 'package:examify/app.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MyApp can be instantiated', () {
    const app = MyApp(initialRoute: Routes.onboarding);
    expect(app, isNotNull);
  });
}
