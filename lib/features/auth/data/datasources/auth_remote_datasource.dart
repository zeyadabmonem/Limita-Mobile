import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({required String email, required String password});

  Future<void> logout();
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

    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<void> logout() async {
    await _apiClient.post<void>(ApiEndpoints.logout);
  }
}
