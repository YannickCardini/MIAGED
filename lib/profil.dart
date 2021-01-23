import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'appdata.service.dart';

class Profil extends StatefulWidget {
  _Panier createState() => _Panier();
}

class _Panier extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    print(appData.user);
    return new StreamBuilder(
        stream: Firestore.instance.collection('Login').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Chargement...");
          }
          return _build(context, snapshot);
        });
  }

  DocumentSnapshot foundUser(List<DocumentSnapshot> userDocuments) {
    return userDocuments.firstWhere((doc) => doc["login"] == appData.user);
  }

  void updateUser(DocumentSnapshot doc, Map<String, dynamic> data) {
    Firestore.instance
        .collection("Login")
        .document(doc.documentID)
        .setData(data)
        .then(
          (value) => AppData.displayToast("Profil mis à jour !", Colors.green),
        );
  }

  Widget _build(
      BuildContext context, AsyncSnapshot<QuerySnapshot> userDocuments) {
    var userDocument = foundUser(userDocuments.data.documents);
    var login = userDocument["login"];
    var mdp = userDocument["mdp"];
    var adress = userDocument["adress"];
    var city = userDocument["city"];
    var post = userDocument["post"];
    var birth = userDocument["birth"];

    final inputLogin = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: TextEditingController()..text = userDocument["login"],
        onChanged: (text) => {login = text},
        decoration: InputDecoration(
            labelText: 'Login',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: TextEditingController()..text = userDocument["mdp"],
        onChanged: (text) => {mdp = text},
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final inputBirthDay = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: TextEditingController()..text = userDocument["birth"],
        onChanged: (text) => {birth = text},
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
            labelText: 'Anniversaire',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final inputAddress = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: TextEditingController()..text = userDocument["adress"],
        onChanged: (text) => {adress = text},
        decoration: InputDecoration(
            labelText: 'Adresse',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final inputPostCode = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: TextEditingController()..text = userDocument["post"],
        onChanged: (text) => {post = text},
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Code Postal',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final inputCity = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: TextEditingController()..text = userDocument["city"],
        onChanged: (text) => {city = text},
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'Ville',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final valider = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Valider',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () => {
            updateUser(userDocument, {
              "adress": adress,
              "birth": birth,
              "city": city,
              "login": login,
              "mdp": mdp,
              "post": post
            })
          },
        ),
      ),
    );
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            inputLogin,
            inputPassword,
            inputBirthDay,
            inputAddress,
            inputPostCode,
            inputCity,
            valider,
          ],
        ),
      ),
    ));
  }
}
