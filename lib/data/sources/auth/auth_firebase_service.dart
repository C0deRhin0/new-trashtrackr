import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_trashtrackr/data/models/auth/create_user_req.dart';
import 'package:new_trashtrackr/data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> updateEmail(String newEmail);
  Future<Either> updatePassword(String newPassword);
  Future<Either> deleteUser();
}

class AuthFireBaseServiceImplementation extends AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: signinUserReq.email, password: signinUserReq.password);
      return const Right('Signin was Successful');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Signin failed');
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: createUserReq.email, password: createUserReq.password);
      return const Right('Signup was Successful');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Signup failed');
    }
  }

  @override
  Future<Either> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser?.updateEmail(newEmail);
      return const Right('Email updated successfully');
    } catch (e) {
      return Left('Failed to update email');
    }
  }

  @override
  Future<Either> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      return const Right('Password updated successfully');
    } catch (e) {
      return Left('Failed to update password');
    }
  }

  @override
  Future<Either> deleteUser() async {
    try {
      await _auth.currentUser?.delete();
      return const Right('Account deleted successfully');
    } catch (e) {
      return Left('Failed to delete account');
    }
  }
}
