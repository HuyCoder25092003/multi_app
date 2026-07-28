import 'package:flutter_riverpod/legacy.dart';

import '../models/vendor.dart';

final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>(
  (ref) => VendorProvider(),
);

class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
    : super(
        Vendor(
          id: "",
          fullName: "",
          email: "",
          state: "",
          city: "",
          locality: "",
          role: "",
          password: "",
        ),
      );

  Vendor? get vendor => state;

  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  void signOut() => state = null;
}
