import 'package:MIAGED/appdata.service.dart';
import 'package:MIAGED/vetement.class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Panier extends StatefulWidget {
  _Panier createState() => _Panier();
}

class _Panier extends State<Panier> {
  int prixTotal;
  @override
  Widget build(BuildContext context) {
    var _body = _buildBody(context);
    return Scaffold(
      body: _body,
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Panier')
          .document('0')
          .collection(appData.user)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    prixTotal = 0;
    var l = ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList());
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text("Prix total: $prixTotal €")),
      ),
      Expanded(child: l)
    ]);
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    var docId = data.documentID;
    print(docId);
    var vet = Vetement.fromSnapshot(data);
    var prixVet = int.parse(vet.prix.substring(0, vet.prix.length - 1));
    prixTotal += prixVet;
    return Padding(
      key: ValueKey(docId),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(vet.titre),
          subtitle: Text('Prix: ' + vet.prix + ' Taille:' + vet.taille),
          leading: Image.network(vet.img.toString()),
          trailing: IconButton(
              icon: new Icon(Icons.cancel),
              color: Colors.red[900],
              onPressed: () => deleteFromBasket(docId, prixVet)),
        ),
      ),
    );
  }

  deleteFromBasket(String docId, int prixVet) {
    Firestore.instance
        .collection('Panier')
        .document('0')
        .collection(appData.user)
        .document(docId)
        .delete();
  }
}
