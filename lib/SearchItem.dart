import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hungry_engine/FoodItem.dart';

class SearchItem extends StatefulWidget {
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  List<FoodItem> finalist=[];
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List<FoodItem> fooditems = [
    FoodItem(1,12, "MASALA DOSA"),
    FoodItem(2,30, "DOSA"),
    FoodItem(3,40, "PODI DOSA"),
    FoodItem(4, 60,"PODI DOSA 2"),
    FoodItem(5, 90,"PODI DOSA 3"),
  ];

  List<FoodItem> items=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.addAll(fooditems);
  }
  void filtersearch(String query){
    List<FoodItem> dummyitems=[];
    dummyitems.addAll(fooditems);
    if(query.isNotEmpty){
      List<FoodItem> dummydata=[];
      dummyitems.forEach((element) {
        if(element.name.toLowerCase().contains(query)){
          dummydata.add(element);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummydata);
      });
      return;

    }  else{
setState(() {
  items.clear();
  items.addAll(fooditems);
});
    }
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        
        key:_scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xffFFAD4B)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:25.0),
                  child: Text('Hungry Engine',
                  style: TextStyle(
                    fontSize: 25,
                     fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.edit,size: 20,),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Add Item',
                      style: TextStyle(
                          fontSize: 18
                      ),

                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.info,size: 20,),
                    SizedBox(
                      width: 20,
                    ),
                    Text('View Details',
                      style: TextStyle(
                          fontSize: 18
                      ),

                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
        body: Column(
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
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    _scaffoldKey.currentState.openDrawer();
                  }, icon: Icon(Icons.menu) ),
                  Expanded(
                    child: TextField(
                      onChanged: (val){filtersearch(val);},
                      style: TextStyle(
                        fontSize: 23,
                      ),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 17, horizontal: 20),
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
                  IconButton(onPressed: (){
                    fooditems.forEach((element) {
                      setState(() {
                        element.controller.text="0";
                        element.count=0;
                      });

                    });
                    finalist.clear();


                  }, icon: Icon(Icons.clear_all) ),
                ],
              ),
            ),
            Expanded(

              child: ListView.builder(

                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: Text('${items[index].name}'),
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            width: 200,
                            child: TextFormField(
                              onChanged: (val){
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
        ),
bottomNavigationBar:Container(
  height: 50,
  width: double.infinity,
  child: GestureDetector(
    child: Center(child: Text('Check Out',
      style: TextStyle(
        color:Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),)),
    onTap: addfinallist,

  ),
  decoration: BoxDecoration(
    color: Color(0xffFFAD4B),

  ),
  padding: EdgeInsets.symmetric(vertical: 15),
) ,
      ),

    );
  }

 void addfinallist() {
    finalist.clear();
    fooditems.forEach((element) {
      if(element.count>0){
        finalist.add(element);
        print("new"+element.name);
      }
    });

 }
}
