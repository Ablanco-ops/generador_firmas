import 'package:flutter/material.dart';
import 'package:generador_firmas/datos.dart';
import 'package:generador_firmas/separador_screen.dart';
import 'package:provider/provider.dart';

import 'home.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => Datos())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Home(),
      routes: {
        SeparadorScreen.routeName: (context)=> const SeparadorScreen()
      },
    );
  }
}
