import 'package:flutter_riverpod/legacy.dart';

import '../models/order.dart';

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>(
  (ref) => OrderProvider(),
);

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  void setOrders(List<Order> orders) => state = orders;
}
