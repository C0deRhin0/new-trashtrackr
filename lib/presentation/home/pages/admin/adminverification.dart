import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signin.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup_or_signin.dart';
import 'package:new_trashtrackr/presentation/settings/accountpage.dart';
import 'package:new_trashtrackr/presentation/settings/notificationsettings.dart';
import 'package:new_trashtrackr/presentation/settings/locationsettings.dart';
import 'package:new_trashtrackr/presentation/settings/analyticspage.dart';
import 'package:new_trashtrackr/presentation/settings/supportpage.dart';
import 'package:new_trashtrackr/presentation/settings/privacy.dart';

class AdminVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Verification"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // insert verification function, for now assume na verification is succeful after pressing complete verification

            Navigator.pop(context, true); // Pass verification result back
          },
          child: Text("Complete Verification"),
        ),
      ),
    );
  }
}
