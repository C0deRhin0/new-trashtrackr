import 'package:dartz/dartz.dart';
import 'package:new_trashtrackr/core/usecase/usecase.dart';
import 'package:new_trashtrackr/data/models/auth/create_user_req.dart';
import 'package:new_trashtrackr/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}
