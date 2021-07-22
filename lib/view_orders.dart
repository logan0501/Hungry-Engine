import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders();

  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  List<dynamic> orders = [];
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    fetchFirstOrders();
    scrollController.addListener(_scrollListener);
  }

  Future<void> fetchFirstOrders() async {
    final orderList =
        await FirebaseFirestore.instance.collection('orders').limit(7).get();
    setState(() {
      orders.addAll(orderList.docs);
    });
  }

  Future<void> fecthNextOrders() async {
    final orderList = await FirebaseFirestore.instance
        .collection('orders')
        .startAfterDocument(orders[orders.length - 1])
        .limit(7)
        .get();
    setState(() {
      orders.addAll(orderList.docs);
    });
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      fecthNextOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckOut'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            // height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        child: Text(
                          'Customer Name: ${orders[index].data()['name']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        child: Text(
                          'Phone Number: ${orders[index].data()['phoneNumber']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        child: Text(
                          'Order Total: INR ${orders[index].data()['totalAmount']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ...orders[index].data()['items'].map((e) {
                        return Container(
                          padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                          child: Row(
                            children: [
                              Text(
                                '${e['foodName']}',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'INR ${e['itemCost']}',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
              itemCount: orders.length,
            ),
          ),

          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('orders').get(),
              builder: (context, snapshot) {
                print(snapshot.data.docs.length);
                return Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.orange,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total Orders: ${snapshot.data.docs.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('AlertDialog Title'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Delete and Download'),
                                          Text(
                                              'Would you like to delete data from firebase and download as excel.'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Download'),
                                        onPressed: () {
                                          saveexcel(context);
                                          FirebaseFirestore.instance.collection('orders').get().then((snapshot) {
                                            for (DocumentSnapshot doc in snapshot.docs) {
                                              doc.reference.delete();
                                            }
                                          });
                              Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.download,
                            color: Colors.white,
                          ))
                    ],
                  ),
                );
              }),
          // Container(
          //   child: Text(
          //     'Total Revenue Generated: INR ${orders.length}',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 18,
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> saveexcel(context) async {
    final directory = await getExternalStorageDirectory();
    var excel = Excel.createExcel(); //create an excel sheet
    Sheet sheetObject = excel['Sheet1'];
    var cell = sheetObject.cell(CellIndex.indexByString("A1"));
    cell.value = 8; // Insert value to selected cell;
    FirebaseFirestore.instance.collection('orders').get().then((_qs) {
      for (int i = 0; i < _qs.docs.length; i++) {
        var namecell = sheetObject.cell(CellIndex.indexByString("A" +
            (i + 1)
                .toString())); //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
        namecell.value =
            _qs.docs[i].data()['name']; // Insert value to selected cell;
        var phonecell =
            sheetObject.cell(CellIndex.indexByString("B" + (i + 1).toString()));
        phonecell.value = _qs.docs[i].data()['phoneNumber'];
        var amountcell =
            sheetObject.cell(CellIndex.indexByString("C" + (i + 1).toString()));
        amountcell.value = _qs.docs[i].data()['totalAmount'];
        var datecell =
            sheetObject.cell(CellIndex.indexByString("D" + (i + 1).toString()));
        datecell.value =
            _qs.docs[i].data()['orderedAt'].toDate().day.toString() +
                "/" +
                _qs.docs[i].data()['orderedAt'].toDate().month.toString() +
                "/" +
                _qs.docs[i].data()['orderedAt'].toDate().year.toString();
        var foodnamecell =
            sheetObject.cell(CellIndex.indexByString("E" + (i + 1).toString()));
        foodnamecell.value = _qs.docs[i]
            .data()['items']
            .map((item) => {item['foodName']})
            .toList()
            .join(",");
      }

      excel.encode().then((onValue) {
        File(join(
            "${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.xlsx"))
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File saved at ${directory.path}")));
      });
    });
  }
}
