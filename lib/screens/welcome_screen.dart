import 'package:flutter/material.dart';
import 'package:funnavi/screens/register_screen.dart';
import 'package:geolocator/geolocator.dart';

import '../const.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'wlecome';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> permision() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    permision();
    return Scaffold(
      backgroundColor: kTlo,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/beer.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'FUNNAVI',
                  style: kTitleTextStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: kGradientBR,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                // color: Color(0xFFDB200C),
              ),
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    Text(
                      'Witaj !',
                      style: kBiggerTitleTextStyle,
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Zarejestruj się już teraz aby zawsze mić pomysł na miejscókę z ekipą ! ;)',
                            style: kDesctyprionTextStyleBlack,
                          ),
                          Text(
                            'TY wybierasz vibe, My dajemy ci spoty',
                            style: kDesctyprionTextStyleBlack,
                          ),
                          Text(
                            'Może za rogiem czeka Twój nowy ulubony bar ?  👀👀',
                            style: kDesctyprionTextStyleBlack,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          color: Colors.black,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: const Text(
                                'Zaloguj się',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.black,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              child: const Text(
                                'Zarejestruj się',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
