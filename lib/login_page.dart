import 'package:MIAGED/appdata.service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Login').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return safeArea(context, snapshot.data.documents);
      },
    );
  }

  safeArea(BuildContext context, List<DocumentSnapshot> snapshot) {
    final loginController = TextEditingController();
    final mdpController = TextEditingController();
    final header = AppBar(
      title: const Text("MIAGED"),
      centerTitle: true,
    );
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: CircleAvatar(
            radius: 56.0,
            child: Image.asset('assets/miage.png'),
          )),
    );
    final inputLogin = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: loginController,
        decoration: InputDecoration(
            hintText: 'Login',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: mdpController,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Se connecter',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () => {
            if (pwdCorrect(snapshot, loginController.text, mdpController.text))
              {
                appData.user = loginController.text,
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Dashboard()))
              }
            else
              AppData.displayToast("Utilisateur non existant", Colors.red)
          },
        ),
      ),
    );

    return SafeArea(
        child: Scaffold(
      appBar: header,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            logo,
            inputLogin,
            inputPassword,
            buttonLogin,
          ],
        ),
      ),
    ));
  }

  pwdCorrect(List<DocumentSnapshot> snapshot, String login, String mdp) {
    for (var i = 0; i < snapshot.length; i++) {
      if (snapshot[i]["login"] == login && snapshot[i]["mdp"] == mdp)
        return true;
    }
    return false;
  }
}
