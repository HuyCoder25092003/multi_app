import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/controllers/auth_controller.dart';
import 'package:multi_store_app/global_variables.dart';
import 'package:multi_store_app/provider/user_provider.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  ConsumerState<ShippingAddressScreen> createState() =>
      _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final AuthController authController = AuthController();
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController localityController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    stateController = TextEditingController(text: user?.state ?? "");
    cityController = TextEditingController(text: user?.city ?? "");
    localityController = TextEditingController(text: user?.locality ?? "");
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),

                const SizedBox(width: 20),

                Text(
                  "Updating...",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final updateUser = ref.read(userProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        title: Text(
          "Delivery",
          style: GoogleFonts.montserrat(
            letterSpacing: 1.7,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.96),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "Where will your order\n be shipped",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.7,
                  ),
                ),
                TextFormField(
                  controller: stateController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter state";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(labelText: "State"),
                ),

                SizedBox(height: 15),

                TextFormField(
                  controller: cityController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter city";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(labelText: "City"),
                ),

                SizedBox(height: 15),

                TextFormField(
                  controller: localityController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Locality";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(labelText: "Locality"),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (formKey.currentState!.validate()) {
              showLoadingDialog();
              await authController
                  .updateUserLocation(
                    context: context,
                    id: user!.id,
                    state: stateController.text,
                    city: cityController.text,
                    locality: localityController.text,
                    ref: ref,
                  )
                  .whenComplete(() {
                    updateUser.recreateUserState(
                      state: stateController.text,
                      city: cityController.text,
                      locality: localityController.text,
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
            } else {
              print("Not valid");
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF3854EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Save",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
