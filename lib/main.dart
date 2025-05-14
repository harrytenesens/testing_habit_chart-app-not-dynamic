import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_habit_chart/firebase_options.dart';
import 'package:testing_habit_chart/homescreen.dart';
import 'package:testing_habit_chart/methods.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Methods())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {  
    return MaterialApp(   
      theme: ThemeData(   
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),   
        useMaterial3: true, 
      ),  
      home: const Homescreen() 
    );
  }
}

