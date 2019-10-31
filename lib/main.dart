import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlab_overflow/view/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomAppBarColor: Color.fromRGBO(227, 227, 227, 1),
        cardColor: Color.fromRGBO(242, 242, 242, 1),
      ),
      home: HomePage(),
    );
  }
}

String stringToDateFormat(String date) {
  var object ;
  if(date == null){
    return '-';
  }
  else{
    object = new DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("dd/MM/yyyy").format(object);
  }
}
