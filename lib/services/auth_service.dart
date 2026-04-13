import '../models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(id: '999', email: email, token: 'mock_api_demo_token');
    }

    return null;
  }
}
