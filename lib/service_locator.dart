import 'package:get_it/get_it.dart';
import 'package:new_trashtrackr/data/repository/auth/auth_repository_impl.dart';
import 'package:new_trashtrackr/data/sources/auth/auth_firebase_service.dart';
import 'package:new_trashtrackr/domain/repository/auth/auth.dart';
import 'package:new_trashtrackr/domain/usecases/auth/signin.dart';
import 'package:new_trashtrackr/domain/usecases/auth/signup.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(
      AuthFireBaseServiceImplementation());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());
}
