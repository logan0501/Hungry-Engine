import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry_engine/SearchItem.dart';
import 'package:hungry_engine/add_item.dart';
import 'package:hungry_engine/checkout_page.dart';
import 'package:hungry_engine/view_orders.dart';

import 'MyHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => MyHomePage(),
        "/searchitem": (context) => SearchItem(),
        "/checkout": (context) => CheckoutPage(),
        "/add-item": (context) => AddItem(),
        '/view-orders': (context) => ViewOrders(),
      },
    );
  }
}
