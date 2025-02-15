import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/main_screen.dart';
import 'package:funnavi/screens/register_screen.dart';

import '../class/local_data.dart';
import '../class/ofert_data.dart';
import '../const.dart';
import '../providers/authProvider.dart';
import '../providers/lokalsProvider.dart';
import '../providers/offertsProvider.dart';
import '../providers/ulunioneProvider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const id = 'login';
  LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  UserCredential? credentials;
  List<Lokal> favFb = [];
  @override
  Future<List<Lokal>> pobierzLokale() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await db.collection('venues').get();

      List<Lokal> allVenues = querySnapshot.docs.map((doc) {
        return Lokal.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      allVenues.sort((a, b) => b.ocena.compareTo(a.ocena));

      return allVenues;
    } catch (e) {
      print("Błąd podczas pobierania wszystkich lokali: $e");
      return [];
    }
  }

  Future<List<Oferta>> pobierzOferty() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await db.collection('promotions').get();

      List<Oferta> allOffers = querySnapshot.docs.map((doc) {
        return Oferta.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      print("Pobrano ${allOffers.length} lokali.");
      return allOffers;
    } catch (e) {
      print("Błąd podczas pobierania wszystkich lokali: $e");
      return [];
    }
  }

  Future<String> getUser() async {
    final authState = ref.read(authProvider);
    credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: authState.email, password: authState.haslo);

    return credentials!.user!.uid;
  }

  Future<List<Lokal>> pobierzUlubione() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String userId = await getUser();

    try {
      DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

      List<dynamic> venuesIdDynamic = userDoc.get('venue_ids');
      List<String> venuesId = venuesIdDynamic.cast<String>();

      List<Lokal> selectedVenues = [];

      const int batchSize = 10;
      for (int i = 0; i < venuesId.length; i += batchSize) {
        int end =
            (i + batchSize < venuesId.length) ? i + batchSize : venuesId.length;
        List<String> batch = venuesId.sublist(i, end);

        QuerySnapshot query =
            await db.collection('venues').where('id', whereIn: batch).get();

        for (var doc in query.docs) {
          selectedVenues.add(Lokal.fromMap(doc.data() as Map<String, dynamic>));
        }
      }

      return selectedVenues;
    } catch (e) {
      print("Error fetching venues: $e");
      return [];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: kGradientBR,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(''),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, RegisterScreen.id);
                  },
                  child: Text(
                    'Zarejestruj się',
                    style: kDesctyprionTextStyleBlack,
                  ),
                )
              ],
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CZAS NA RELAX!',
                    style: kSmallerTitleTextStyleWhite,
                  ),
                  Text(
                    'Powiedz czego oczekujesz od dzisiejszego wyjscia a My powiemy ci gdzie tego szukać :)',
                    style: kDesctyprionTextStyleWhite,
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  decoration: kZakladka,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: '   Login'),
                          onChanged: (login) {
                            ///todo:dodac dynamiczny login
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: '    Hasło',
                          ),
                          onChanged: (value) {
                            ///todo:dodac dynamiczne haslo
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(''),
                          ),
                          Text('Zapomniałeś hasła?'),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Colors.black,
                        child: TextButton(
                          onPressed: () async {
                            try {
                              final credentials = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: 'karolmmmm@gmail.com',
                                      password: 'karolmmmm');
                              if (credentials.user != null) {
                                ref
                                    .read(authProvider.notifier)
                                    .setEmail('karolmmmm@gmail.com');
                                ref
                                    .read(authProvider.notifier)
                                    .setHaslo('karolmmmm');

                                final lokale = await pobierzLokale();
                                ref
                                    .read(lokalProvider.notifier)
                                    .setLokale(lokale);

                                final oferty = await pobierzOferty();
                                ref
                                    .read(ofertyProvider.notifier)
                                    .setOferty(oferty);

                                favFb = await pobierzUlubione();
                                ref
                                    .read(ulubioneProvider.notifier)
                                    .addLokale(favFb);
                                for (int i = 0; i < lokale.length; i++) {
                                  print(lokale[i].nazwaLokalu);
                                }
                                Navigator.popAndPushNamed(
                                    context, MainScreen.id);
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            'Zaloguj się',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text('Firebase- fb'),
                      Text('Firebase- gmail'),
                      Text('Firebase- telefon')
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
