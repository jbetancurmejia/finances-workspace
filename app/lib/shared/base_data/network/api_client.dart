import 'package:dio/dio.dart';
import 'package:money_app/shared/base_data/network/auth_token_store.dart';

Dio createApiClient({required String baseUrl, AuthTokenStore? tokenStore}) {
  final client = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Accept': 'application/json'},
    ),
  );

  if (tokenStore != null) {
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenStore.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  return client;
}
