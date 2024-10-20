import 'package:flutter/material.dart';
import '../../settings/accountpage.dart';

class EditEmail extends StatelessWidget {
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
        title: Text('Edit Email Page'),
      ),
      body: Container(),
    );
  }
}
