import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:multi_store_app/controllers/order_controller.dart';
import 'package:multi_store_app/services/manage_http_response.dart';

final deliveredOrderCountProvider =
    StateNotifierProvider<DeliveredOrderCountProvider, int>(
      (ref) => DeliveredOrderCountProvider(),
    );

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider() : super(0);

  Future<void> fetchDeliveredOrderCount(
    String buyerId,
    BuildContext context,
  ) async {
    try {
      OrderController orderController = OrderController();
      int count = await orderController.getDeliveredOrderCount(
        buyerId: buyerId,
      );
      state = count;
    } catch (e) {
      showSnackBar(context, "Error Fetching Delivered order: $e");
    }
  }

  void resetCount() {
    state = 0;
  }
}
