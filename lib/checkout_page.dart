import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hungry_engine/FoodItem.dart';
import 'package:flutter_sms/flutter_sms.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage();

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const platform = const MethodChannel('sendSms');
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final finalList = (ModalRoute.of(context).settings.arguments
        as Map<String, dynamic>)['finalList'] as List<FoodItem>;
    final name = (ModalRoute.of(context).settings.arguments
        as Map<String, dynamic>)['name'];
    final phoneNumber = (ModalRoute.of(context).settings.arguments
        as Map<String, dynamic>)['phoneNumber'];
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
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Card(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 15,
                ),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Details:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text('Name: $name'),
                    Text('Phone Number: $phoneNumber'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: finalList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                            'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574'),
                      ),
                      title: Text(finalList[index].name),
                      subtitle: Text(
                        '${finalList[index].count.toString()} Pcs X Rs: ${finalList[index].cost.toString() ?? 20.00}',
                      ),
                      trailing: Container(
                        height: 50,
                        width: 80,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            'Rs: ${finalList[index].count * (finalList[index].cost)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () async {
              String messageString = '';
              finalList.forEach((element) {
                messageString +=
                    '${element.name} ---- ${element.count} Pcs X Rs ${element.cost} = Rs ${element.count * element.cost}\n';
                return totalPrice += element.cost * element.count;
              });
              print(totalPrice);
              List<String> recipients = ['+91$phoneNumber'];
              String _result = await sendSMS(
                message:
                    "Order has been processed\nTotal Amount: $totalPrice\nOrder Details: \n$messageString \nHappy Shopping - Hungry Engine",
                recipients: recipients,
              ).catchError((onError) {
                print(onError);
              });
              print(_result);
              await FirebaseFirestore.instance.collection('orders').add({
                'phoneNumber': '+91$phoneNumber',
                'name': name,
                'items': finalList.map((e) {
                  return {
                    'foodName': e.name,
                    'itemCount': e.count,
                    'itemCost': e.cost,
                    'total': e.cost * e.count,
                  };
                }).toList(),
                'totalAmount': totalPrice,
                'orderedAt': DateTime.now(),
              });
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Center(
                child: Text(
                  'Save to Database and Notify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
