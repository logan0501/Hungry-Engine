import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController foodCostController = TextEditingController();
  bool isLoading = false;
  List<dynamic> fooditems=[];
  var docid=null;
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
                Expanded(
                  child: StreamBuilder (
                    stream: FirebaseFirestore.instance.collection('foods').snapshots(),
                   builder: (context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: Text('Loading'));
      }
                        fooditems = snapshot.data.docs??[];


                      return ListView.builder(
                      itemCount: fooditems.length,
                        itemBuilder: (context,index){
                        return Card(
                          child: ListTile(
                            key:Key(fooditems[index].data()['foodId']),
                            title: GestureDetector(
                              onTap: (){
                                foodNameController.text = fooditems[index].data()['foodName'];
                                foodCostController.text = '${fooditems[index].data()['foodCost']}';

                                setState(() {
                                  docid=fooditems[index].data()['foodId'];
                                });

                              },
                              child: Text(fooditems[index].data()['foodName'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),),
                            ),
                            trailing: IconButton(
                              onPressed: () async{
                               await FirebaseFirestore.instance.collection('foods').doc(fooditems[index].data()['foodId']).delete();
                                foodNameController.clear();
                                foodCostController.clear();
                               },
                                icon:Icon(Icons.delete,color: Colors.orange,)),
                          ),
                        );
                        });}
                  ),
                )
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
        onTap: docid==null?() {
          if (foodNameController.text.isEmpty ||
              foodCostController.text.isEmpty) {
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
            'foodCost': foodCostController.text,
            'foodId': doc.id,
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
          foodNameController.clear();
          foodCostController.clear();
          setState(() {
            isLoading = false;
          });
        }:(){
          if (foodNameController.text.isEmpty ||
              foodCostController.text.isEmpty) {
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

          FirebaseFirestore.instance.collection('foods').doc(docid).set({
            'foodName': foodNameController.text,
            'foodCost': foodCostController.text,
            'foodId': docid,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text('${foodNameController.text} was updated successfully...'),
              duration: Duration(
                seconds: 2,
              ),
            ),
          );
          docid=null;
          foodNameController.clear();
          foodCostController.clear();
          setState(() {
            isLoading = false;
          });
        },
      ),
    );
  }
}
