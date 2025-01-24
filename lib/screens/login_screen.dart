import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/main_screen.dart';
import 'package:funnavi/screens/register_screen.dart';

import '../class/local_data.dart';
import '../class/ofert_data.dart';
import '../class/riverpod.dart';
import '../const.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const id = 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
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

  Widget build(BuildContext context) {
    final listaLokali = ref.watch(lokalProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFD700),
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
                    child: const Text('Zarejestruj się'))
              ],
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Czas na relax!',
                    style: kBiggerTitleTextStyle,
                  ),
                  Text(
                    'Powiedz czego oczekujesz od dzisiejszego wyjscia a My powiemy ci gdzie tego szukać :)',
                    style: kDesctyprionTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 5,
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
