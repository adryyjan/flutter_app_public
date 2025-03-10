import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../class/local_data.dart';
import '../class/ofert_data.dart';

class DataGetter {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserCredential? credentials;

  Future<List<Lokal>> fetchAllVenues() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('venues').get();
      List<Lokal> allVenues = querySnapshot.docs.map((doc) {
        return Lokal.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      allVenues.sort((a, b) => b.ocena.compareTo(a.ocena));
      return allVenues;
    } catch (e) {
      print("Błąd pobierania lokali: $e");
      return [];
    }
  }

  Future<List<Oferta>> fetchAllOffers() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('promotions').get();
      List<Oferta> allOffers = querySnapshot.docs.map((doc) {
        return Oferta.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return allOffers;
    } catch (e) {
      print("Błąd pobierania ofert: $e");
      return [];
    }
  }

  Future<List<Lokal>> fetchFavoriteVenues(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(userId).get();
      List<dynamic> venuesIdDynamic = userDoc.get('venue_ids');
      List<String> venuesId = venuesIdDynamic.cast<String>();
      List<Lokal> selectedVenues = [];

      const int batchSize = 10;
      for (int i = 0; i < venuesId.length; i += batchSize) {
        int end =
            (i + batchSize < venuesId.length) ? i + batchSize : venuesId.length;
        List<String> batch = venuesId.sublist(i, end);

        QuerySnapshot query =
            await _db.collection('venues').where('id', whereIn: batch).get();

        for (var doc in query.docs) {
          selectedVenues.add(Lokal.fromMap(doc.data() as Map<String, dynamic>));
        }
      }

      return selectedVenues;
    } catch (e) {
      print("Błąd pobierania ulubionych lokali: $e");
      return [];
    }
  }
}
