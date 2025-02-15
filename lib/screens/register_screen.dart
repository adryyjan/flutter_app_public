import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/login_screen.dart';

import '../class/local_data.dart';
import '../class/ofert_data.dart';
import '../const.dart';
import '../providers/authProvider.dart';
import '../providers/lokalsProvider.dart';
import '../providers/offertsProvider.dart';
import 'main_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const id = 'register';
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  Future<List<Lokal>> pobierzLokale() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await db.collection('venues').get();

      List<Lokal> allVenues = querySnapshot.docs.map((doc) {
        return Lokal.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      print("Pobrano ${allVenues.length} lokali.");
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

  @override
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
                      Navigator.popAndPushNamed(context, LoginScreen.id);
                    },
                    child: const Text('Zaloguj się'))
              ],
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dołącz do nas!',
                    style: kTitleTextStyleWhite,
                  ),
                  Text(
                    'Załóż konto i nie zastanawiaj się już nigdy gdzie spedzisz wieczór- my zrobimy to za Ciebie :0',
                    style: kDesctyprionTextStyleWhite,
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
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
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: '   Login'),
                          onChanged: (value) {
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
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: '    Hasło',
                          ),
                          onChanged: (value) {
                            ///todo:dodac dynamiczen haslo
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: '   Powtórz hasło',
                          ),
                          onChanged: (value) {
                            ///todo:dodac dynamiczen haslo
                          },
                        ),
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
                                  .createUserWithEmailAndPassword(
                                      email: 'adrian2137@gmail.com',
                                      password: 'adrian2137');
                              if (credentials.user != null) {
                                ref
                                    .read(authProvider.notifier)
                                    .setEmail('adrian2137@gmail.com');
                                ref
                                    .read(authProvider.notifier)
                                    .setHaslo('adrian2137');

                                final lokale = await pobierzLokale();
                                ref
                                    .read(lokalProvider.notifier)
                                    .setLokale(lokale);

                                final oferty = await pobierzOferty();
                                ref
                                    .read(ofertyProvider.notifier)
                                    .setOferty(oferty);
                                Navigator.popAndPushNamed(
                                    context, MainScreen.id);
                              }

                              User? user = credentials.user;
                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .set(
                                  {
                                    'user_id': user.uid,
                                    // 'email': user.email,
                                    'venue_ids': [],
                                  },
                                  SetOptions(merge: true),
                                );
                                print("User added to Firestore!");
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            'Zarejestruj się',
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
