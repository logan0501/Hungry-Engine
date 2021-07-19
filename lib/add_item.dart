import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController foodCostController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Hungry Engine',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xffFFAD4B),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xffFFAD4B),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextField(
                    controller: foodNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Food Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffFFAD4B),
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextField(
                    controller: foodCostController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Food Cost',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffFFAD4B),
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: GestureDetector(
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xffFFAD4B),
          ),
          child: Center(
              child: Text(
            'Add Food',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
        onTap: () {
          if (foodNameController.text.isEmpty ||
              foodNameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Food Name and Food Cost -> Required.'),
              ),
            );
            return;
          }
          setState(() {
            isLoading = true;
          });
          final doc = FirebaseFirestore.instance.collection('foods').doc();
          FirebaseFirestore.instance.collection('foods').doc(doc.id).set({
            'foodName': foodNameController.text,
            'foodCost': foodNameController.text,
            'foodId': doc.id,
          });
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${foodNameController.text} was added successfully...'),
              duration: Duration(
                seconds: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}
