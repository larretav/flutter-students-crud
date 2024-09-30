import 'package:abc_3/Services/estudiantes_services.dart';
import 'package:abc_3/Services/student_form_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/HomePage.dart';


void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> EstudiantesServices()),
        ChangeNotifierProvider(create: (_)=> StudentFormService(null)),
      ],
      
    child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

