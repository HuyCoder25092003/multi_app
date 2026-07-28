import 'package:flutter_riverpod/legacy.dart';

import '../models/order.dart';

final totalEarningsProvider =
    StateNotifierProvider<TotalEarningsProvider, Map<String, dynamic>>(
      (ref) => TotalEarningsProvider(),
    );

class TotalEarningsProvider extends StateNotifier<Map<String, dynamic>> {
  TotalEarningsProvider() : super({"totalEarnings": 0, "totalOrders": 0});

  void calculateEarnings(List<Order> orders) {
    double earnings = 0.0;
    int orderCount = 0;
    for (Order order in orders) {
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    state = {"totalEarnings": earnings, "totalOrders": orderCount};
  }
}
