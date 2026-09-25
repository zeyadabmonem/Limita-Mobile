import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../network/api_client.dart';
import '../router/app_router.dart';
import '../storage/secure_storage_service.dart';
import '../storage/token_storage.dart';

final GetIt sl = GetIt.instance;

/// Registers every dependency exactly once. Call from `main()` before
/// `runApp`.
///
/// Ordering matters: storage -> network -> data -> domain -> presentation.
Future<void> setupServiceLocator() async {
  // ---- Core: storage ----
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));

  // ---- Core: network ----
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      tokenStorage: sl(),
      onUnauthorized: () async {
        // Central hook: wipe the session the moment any call comes back
        // 401, regardless of which feature triggered it.
        await sl<TokenStorage>().clear();
      },
    ),
  );

  // ---- Core: router ----
  sl.registerLazySingleton<AppRouter>(() => AppRouter(sl()));

  // ---- Feature: auth ----
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(loginUseCase: sl(), tokenStorage: sl()));
}
