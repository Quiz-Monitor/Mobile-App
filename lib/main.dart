import 'package:examify/app.dart';
import 'package:examify/core/di/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}
// Line 6: WidgetsFlutterBinding.ensureInitialized() ensures that the Flutter framework's 
// connection to the host platform is established. This is mandatory when calling 
// asynchronous platform-specific code (like plugins) before runApp().
// Line 7: await init() invokes the dependency injection initialization logic from 
// service_locator.dart. Using 'await' ensures that all necessary services and 
// configurations are fully loaded before the UI (MyApp) is rendered.
