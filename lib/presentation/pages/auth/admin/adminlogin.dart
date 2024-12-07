import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/assets/app_vectors.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_trashtrackr/data/models/auth/signin_user_req.dart';
import 'package:new_trashtrackr/domain/usecases/auth/signin.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import 'package:new_trashtrackr/presentation/pages/auth/admin/adminregistration.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup_or_signin.dart';
import 'package:new_trashtrackr/presentation/settings/account%20settings%20pages/forgotpassword.dart';
import 'package:new_trashtrackr/service_locator.dart';

class AdminLoginPage extends StatefulWidget {
  AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        leading: BackButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupOrSigninPage()),
          ),
        ),
        backgroundColor: Colors.transparent,
      )),
      bottomNavigationBar: signInLink(context),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 100,
              horizontal: 70,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppVectors.logo,
                  height: 100,
                  width: 100,
                ),
                _loginTitle(),
                const SizedBox(height: 20),
                _emailField(context),
                const SizedBox(height: 20),
                _passwordField(context),
                const SizedBox(height: 20),
                forgotPasswordButton(context),
                ElevatedButton(
                  onPressed: () async {
                    var result = await sl<SigninUseCase>().call(
                        params: SigninUserReq(
                      email: _email.text.toString(),
                      password: _password.text.toString(),
                    ));
                    result.fold((l) {
                      var snackbar = SnackBar(content: Text(l));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }, (r) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const HomePage(
                                    title: 'Home Page',
                                  )),
                          (route) => false);
                    });
                  },
                  child: const Text('Sign In',
                      style: TextStyle(color: AppColors.textInButton)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: AppColors.switchButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginTitle() {
    return const Text(
      'Login',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      obscureText: isPasswordHidden,
      decoration: InputDecoration(
        hintText: 'Enter Password',
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordHidden ? Icons.visibility_off : Icons.visibility,
          ),
          color: AppColors.iconSecondary,
          onPressed: () {
            setState(() {
              isPasswordHidden = !isPasswordHidden;
            });
          },
        ),
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget forgotPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ForgotPassword(),
                ),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.switchButton,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account yet?",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mainpageText,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AdminRegistrationPage(),
                ),
              );
            },
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.switchButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
