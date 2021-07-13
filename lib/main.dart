import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name ,mobile;
  TextEditingController _namecontroller=TextEditingController();
  TextEditingController _mobilecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/circle.png'),

                  ),
                  Positioned(
                     bottom: -40,

                      child: Image.asset('assets/orange-vector.png')),


                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0,left: 30,right: 30),
                child: TextField(
    controller: _namecontroller,
                  decoration: InputDecoration(
                    hintText: 'Name',

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:Color(0xffFF4A32))
                    ),
                    prefixIcon: Icon(Icons.account_circle,size: 30,color: Color(0xffFF4A32),),
                  ),
                  style: TextStyle(
                    letterSpacing: 1.3,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                child: TextField(
                keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Color(0xffFF4A32)),

                    ),
                    hintText: 'Mobile',
                    prefixIcon: Icon(Icons.call,size: 30,color: Color(0xffFF4A32),),


                  ),
controller: _mobilecontroller,
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 1.3
                  ),
                ),
              ),
              ElevatedButton(onPressed: (){
                print(_namecontroller.text);
                print(_namecontroller.text);
              },
                
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.2)),
                  backgroundColor: MaterialStateProperty.all(Color(0xffFF4A32).withOpacity(0.9)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                shadowColor: MaterialStateProperty.all(Colors.grey),
                ),
                  child: Container(margin:EdgeInsets.symmetric(horizontal: 10),child: Text('ORDER')),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Image(
                  image: AssetImage('assets/logo.png'),

                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
