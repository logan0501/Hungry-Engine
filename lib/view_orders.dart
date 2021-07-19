import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
          Spacer(),
          Container(
            child: Text(
              'Total Orders: ${orders.length}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
          Spacer(),
        ],
      ),
    );
  }
}
