import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name, mobile;
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _mobilecontroller = TextEditingController();
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
                    child: Image.asset(
                      'assets/orange-vector.png',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 30, right: 30),
                child: TextField(
                  controller: _namecontroller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(25.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffFF4A32),
                      ),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(25.0),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.account_circle,
                      size: 30,
                      color: Color(0xffFF4A32),
                    ),
                  ),
                  style: TextStyle(
                    letterSpacing: 1.3,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(25.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffFF4A32),
                      ),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(25.0),
                      ),
                    ),
                    hintText: 'Mobile',
                    prefixIcon: Icon(
                      Icons.call,
                      size: 30,
                      color: Color(0xffFF4A32),
                    ),
                  ),
                  controller: _mobilecontroller,
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_namecontroller.text.isNotEmpty &&
                          _mobilecontroller.text.length == 10)
                      ? () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc('+91${_mobilecontroller.text}')
                              .set({
                            'name': _namecontroller.text,
                            'mobile_number': '+91${_mobilecontroller.text}',
                          });
                          Navigator.pushNamed(context, "/searchitem");
                        }
                      : () {
                          print(_namecontroller);
                          print(_mobilecontroller.text.length);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _namecontroller.text.isEmpty
                                    ? 'Please Enter your Name'
                                    : 'Please check your Mobile Number',
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffFF4A32).withOpacity(0.9),
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  // style: ButtonStyle(
                  //   overlayColor:
                  //       MaterialStateProperty.all(Colors.white.withOpacity(0.2)),
                  //   backgroundColor: MaterialStateProperty.all(
                  //       Color(0xffFF4A32).withOpacity(0.9)),
                  //   foregroundColor: MaterialStateProperty.all(Colors.white),
                  //   shadowColor: MaterialStateProperty.all(Colors.grey),
                  // ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('ORDER'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Image(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}