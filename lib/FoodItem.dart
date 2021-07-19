import 'package:flutter/cupertino.dart';

class FoodItem {
  String id;
  int count;
  String name;
  double cost;
  TextEditingController controller;
  FoodItem(id, cost, name) {
    this.id = id;
    this.name = name;
    count = 0;
    this.cost = cost;
    controller = TextEditingController(text: count.toString());
  }

  int getcount() {
    return count;
  }

  void increment() {
    count = int.parse(count.toString()) + 1;
    controller.text = count.toString();
  }

  void setcount(int c) {
    count = c;
  }

  void decrement() {
    count = int.parse(count.toString());
    if (count != 0) {
      count--;
    } else {
      count = 0;
    }
    controller.text = count.toString();
  }

  String getFoodName() {
    return name;
  }
}
