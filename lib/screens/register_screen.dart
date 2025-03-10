import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../const.dart';
import '../providers/authProvider.dart';
import '../providers/lokalsProvider.dart';
import '../providers/offertsProvider.dart';
import '../providers/ulunioneProvider.dart';
import '../services/dataGetter.dart';
import '../services/userGetter.dart';
import 'main_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const id = 'register';
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  UserCredential? credentials;
  bool isWaiting = false;
  DataGetter dg = DataGetter();

  @override
  Widget build(BuildContext context) {
    UserGetter ug = UserGetter(ref);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isWaiting,
        child: Container(
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
                    child:
                        Text('Zaloguj się', style: kDesctyprionTextStyleBlack),
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
                      'DOŁĄCZ DO NAS!',
                      style: kSmallerTitleTextStyleWhite,
                    ),
                    Text(
                      'Załóż konto i nie zastanawiaj się już nigdy gdzie spedzisz wieczór- my zrobimy to za Ciebie :0',
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
                                        email: 'test1aaa@gmail.com',
                                        password: 'test1aaa');
                                if (credentials.user != null) {
                                  ref
                                      .read(authProvider.notifier)
                                      .setEmail('adrian2137@gmail.com');
                                  ref
                                      .read(authProvider.notifier)
                                      .setHaslo('adrian2137');

                                  final lokale = await dg.fetchAllVenues();
                                  ref
                                      .read(lokalProvider.notifier)
                                      .setLokale(lokale);

                                  final oferty = await dg.fetchAllOffers();
                                  ref
                                      .read(ofertyProvider.notifier)
                                      .setOferty(oferty);
                                  Navigator.popAndPushNamed(
                                      context, MainScreen.id);
                                  final favFb = await dg
                                      .fetchFavoriteVenues(await ug.getUser());
                                  ref
                                      .read(ulubioneProvider.notifier)
                                      .addLokale(favFb);
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
                        // SizedBox(
                        //   height: 50,
                        // ),
                        Text('Firebase- fb'),
                        Text('Firebase- gmail'),
                        Text('Firebase- telefon')
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
