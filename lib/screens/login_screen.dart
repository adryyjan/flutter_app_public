import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/main_screen.dart';
import 'package:funnavi/screens/register_screen.dart';
import 'package:funnavi/services/userGetter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../class/local_data.dart';
import '../const.dart';
import '../providers/authProvider.dart';
import '../providers/lokalsProvider.dart';
import '../providers/offertsProvider.dart';
import '../providers/ulunioneProvider.dart';
import '../services/dataGetter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const id = 'login';
  LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  UserCredential? credentials;
  List<Lokal> favFb = [];
  bool isWaiting = false;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool _isTextFieldFocused1 = false;
  bool _isTextFieldFocused2 = false;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        _isTextFieldFocused1 = _focusNode1.hasFocus;
      });
    });
    _focusNode2.addListener(() {
      setState(() {
        _isTextFieldFocused2 = _focusNode2.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();

    super.dispose();
  }

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
                      Navigator.popAndPushNamed(context, RegisterScreen.id);
                    },
                    child: Text(
                      'Zarejestruj się',
                      style: kDesctyprionTextStyleBlack,
                    ),
                  )
                ],
              ),
              Flexible(
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
                            focusNode: _focusNode2,
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
                            focusNode: _focusNode1,
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
                              print(screenHeight);
                              print(screenWidth);
                              setState(() {
                                isWaiting = true;
                              });
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

                                  final lokale = await dg.fetchAllVenues();
                                  ref
                                      .read(lokalProvider.notifier)
                                      .setLokale(lokale);

                                  final oferty = await dg.fetchAllOffers();
                                  ref
                                      .read(ofertyProvider.notifier)
                                      .setOferty(oferty);

                                  favFb = await dg
                                      .fetchFavoriteVenues(await ug.getUser());
                                  ref
                                      .read(ulubioneProvider.notifier)
                                      .addLokale(favFb);
                                  Navigator.popAndPushNamed(
                                      context, MainScreen.id);
                                }
                                setState(() {
                                  isWaiting = false;
                                });
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
                        Flexible(
                          child: SizedBox(
                            height: 50,
                          ),
                        ),
                        _isTextFieldFocused1 || _isTextFieldFocused2
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Firebase- fb'),
                                  Text('Firebase- gmail'),
                                  Text('Firebase- telefon')
                                ],
                              )
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
