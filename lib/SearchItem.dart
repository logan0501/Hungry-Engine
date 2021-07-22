import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hungry_engine/FoodItem.dart';

class SearchItem extends StatefulWidget {
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  List<FoodItem> finalist = [];
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List<FoodItem> fooditems = [];
  List<FoodItem> items = [];
  var isLoading = false;
  int selected = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('foods').get().then((foods) {
      foods.docs.forEach((e) {
        fooditems.add(
          FoodItem(
            e.data()['foodId'],
            double.parse(e.data()['foodCost'].toString()),
            e.data()['foodName'],
          ),
        );
      });
      setState(() {
        items.addAll(fooditems);
        isLoading = false;
      });
    });
  }

  void filtersearch(String query) {
    List<FoodItem> dummyitems = [];
    dummyitems.addAll(fooditems);
    if (query.isNotEmpty) {
      List<FoodItem> dummydata = [];
      dummyitems.forEach((element) {
        if (element.name.toLowerCase().contains(query)) {
          dummydata.add(element);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummydata);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(fooditems);
      });
    }
  }

  Future<void> onRefresh() {
    fooditems = [];
    refreshKey.currentState?.show(atTop: false);
    FirebaseFirestore.instance.collection('foods').get().then((foods) {
      foods.docs.forEach((e) {
        fooditems.add(
          FoodItem(
            e.data()['foodId'],
            double.parse(e.data()['foodCost'].toString()),
            e.data()['foodName'],
          ),
        );
      });
      setState(() {
        items = [];
        items.addAll(fooditems);
        isLoading = false;
      });
    });
    return Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final String username = (ModalRoute.of(context).settings.arguments
        as Map<String, dynamic>)['name'];
    final String phoneNumber = (ModalRoute.of(context).settings.arguments
        as Map<String, dynamic>)['phoneNumber'];
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Color(0xffFFAD4B)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Hungry Engine',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/add-item');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Add Item',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/view-orders');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'View Details',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                key: refreshKey,
                onRefresh: onRefresh,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                              icon: Icon(Icons.menu)),
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                filtersearch(val);
                              },
                              style: TextStyle(
                                fontSize: 23,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 17, horizontal: 20),
                                hintText: 'Search Food Items',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                fooditems.forEach((element) {
                                  setState(() {
                                    element.controller.text = "0";
                                    element.count = 0;
                                  });
                                });
                                finalist.clear();
                              },
                              icon: Icon(Icons.clear_all)),
                        ],
                      ),
                    ),

                  Expanded(
                    child:ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            key: Key('builder' + selected.toString()),
                            initiallyExpanded: index == selected,
                            onExpansionChanged: ((newstate) {
                              if (newstate) {
                                setState(() {
                                  selected = index;
                                });
                              } else {
                                setState(() {
                                  selected = -1;
                                });
                              }
                            }),
                            title: Text('${items[index].name}'),
                            children: [
                              SingleChildScrollView(
                                child: Container(
                                  width: 200,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      items[index].setcount(int.parse(val));
                                    },
                                    controller: items[index].controller,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              items[index].decrement();
                                            });
                                          },
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              items[index].increment();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: items.length,
                      ),
                    ),


                ],
    ),),
        bottomNavigationBar: isLoading
            ? Container()
            : GestureDetector(
                onTap: () => addfinallist(username, phoneNumber),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    'Check Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  decoration: BoxDecoration(
                    color: Color(0xffFFAD4B),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
      ),
    );
  }

  void addfinallist(String userName, String phoneNumber) {
    finalist.clear();
    fooditems.forEach((element) {
      if (element.count > 0) {
        finalist.add(element);
        print("new" + element.name);
      }
    });
    if (finalist.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Add Some Items before proceeding to checkout.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    Navigator.of(context).pushNamed('/checkout', arguments: {
      'finalList': finalist,
      'name': userName,
      'phoneNumber': phoneNumber,
    });
  }
}


















// child: StreamBuilder(
//                       stream: FirebaseFirestore.instance.collection("foods").snapshots(),
//                       builder: (context,snapshot){
//                         if(!snapshot.hasData){
//                           return Text('Empty Menu');
//                         }else{
//                         final items = snapshot.data.documents;
                  
//                         return Text(items[0]["foodname"]);
//                         }
//                       },
//                     )