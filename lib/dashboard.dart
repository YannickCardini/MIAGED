import 'package:MIAGED/panier.dart';
import 'package:MIAGED/profil.dart';

import 'appdata.service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Vetements").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There is no expense");
          return _build(context, snapshot);
        });
  }

  getVetementItems(
      AsyncSnapshot<QuerySnapshot> snapshot, int bFiltre, int eFiltre) {
    var l = snapshot.data.documents.sublist(bFiltre, eFiltre);
    return l
        .map((doc) => new ListTile(
            title: new Text(doc["titre"]),
            trailing: Image.network(doc["img"]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Details(doc: doc)),
              );
            },
            subtitle: new Text(
                "Prix: " + doc["prix"] + "\nTaille: " + doc["taille"])))
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _build(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Text> _titleOptions = [
      Text("Liste de vêtements"),
      Text("Panier"),
      Text("Mon Profil")
    ];
    List<TabBar> _bottomOptions = [
      TabBar(
        tabs: [
          Text("Tous"),
          Text("Sous-vêtements"),
          Text("Hauts"),
          Text("Autres")
        ],
      ),
      null,
      null
    ];
    List<Widget> _widgetOptions = <Widget>[
      ListView(children: getVetementItems(snapshot, 0, 8)),
      new Panier(),
      new Profil(),
    ];
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: _titleOptions.elementAt(_selectedIndex),
                actions: <Widget>[
                  FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("Déconnexion"),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent)),
                  ),
                ],
                bottom: _bottomOptions.elementAt(_selectedIndex),
              ),
              body: TabBarView(children: [
                Center(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
                ListView(children: getVetementItems(snapshot, 0, 3)),
                ListView(children: getVetementItems(snapshot, 4, 7)),
                ListView(children: getVetementItems(snapshot, 7, 8)),
              ]),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.euro_symbol),
                    label: 'Acheter',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_basket),
                    label: 'Panier',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profil',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
            )));
  }
}

class Details extends StatelessWidget {
  final DocumentSnapshot doc;

  Details({Key key, @required this.doc}) : super(key: key);

  addItemToBasket(DocumentSnapshot doc) async {
    final user = appData.user;
    // Add a new document in collection "panier"
    Firestore.instance
        .collection('Panier')
        .document("0")
        .collection(user)
        .document(UniqueKey().toString())
        .setData(doc.data);
  }

  @override
  Widget build(BuildContext context) {
    final buttonPanier = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Ajouter au panier',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () => {
            AppData.displayToast("Article ajouté au panier", Colors.green),
            addItemToBasket(doc)
          },
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(doc["titre"]),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.network(doc["img"]),
          ),
          Text(
            doc["titre"],
            style: TextStyle(height: 2, fontSize: 28),
          ),
          ListTile(
            title: Text("Prix"),
            subtitle: Text(doc["prix"], style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            title: Text("Marque"),
            subtitle: Text(doc["marque"], style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            title: Text("Taille"),
            subtitle: Text(doc["taille"], style: TextStyle(fontSize: 18)),
          ),
          buttonPanier
        ],
      ),
    );
  }
}
