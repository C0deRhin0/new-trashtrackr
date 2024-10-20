import 'package:flutter/material.dart';
import '../../settings/accountpage.dart';

class EditPassword extends StatelessWidget {
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
        title: Text('Edit Password Page'),
      ),
      body: Container(),
    );
  }
}
