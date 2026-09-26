import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(
      {required String email, required String password});
  Future<RegisteredUserModel> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
      requiresAuth: false,
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Empty response from server.');
    }

    return AuthResponseModel.fromJson(data, email: email);
  }

  @override
  Future<RegisteredUserModel> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      },
      requiresAuth: false,
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Empty response from server.');
    }
    return RegisteredUserModel.fromJson(data);
  }
}
