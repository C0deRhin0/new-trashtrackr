import 'package:flutter/material.dart';
import '../../settings/accountpage.dart';

class EditPhoneNum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AccountPage()));
          },
        ),
        title: Text('Phone Number Page'),
      ),
      body: Container(),
    );
  }
}
