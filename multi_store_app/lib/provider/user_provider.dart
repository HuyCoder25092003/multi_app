import 'package:flutter_riverpod/legacy.dart';
import 'package:multi_store_app/models/user.dart';

final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);

class UserProvider extends StateNotifier<User?> {
  UserProvider()
    : super(
        User(
          id: "",
          fullName: "",
          email: "",
          state: "",
          city: "",
          locality: "",
          password: "",
          token: "",
        ),
      );

  User? get user => state;

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  void signOut() => state = null;

  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) async {
    try {
      if (this.state != null) {
        this.state = User(
          id: this.state!.id,
          fullName: this.state!.fullName,
          email: this.state!.email,
          state: state,
          city: city,
          locality: locality,
          password: this.state!.password,
          token: this.state!.token,
        );
      }
    } catch (e) {}
  }
}
