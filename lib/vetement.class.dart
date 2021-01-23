import 'package:cloud_firestore/cloud_firestore.dart';

class Vetement {
  final String titre;
  final String img;
  final String prix;
  final String taille;
  final DocumentReference reference;

  Vetement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['titre'] != null),
        assert(map['img'] != null),
        assert(map['prix'] != null),
        assert(map['taille'] != null),
        titre = map['titre'],
        prix = map['prix'],
        taille = map['taille'],
        img = map['img'];

  Vetement.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Vetement<$titre:$img:$prix:$taille>";
}
