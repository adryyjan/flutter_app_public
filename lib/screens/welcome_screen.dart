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

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Czas trwania animacji
    )..repeat(reverse: true); // Powtarza animację tam i z powrotem

    _animation = Tween<double>(begin: 100, end: 150).animate(_controller);
  }

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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Image.asset(
                          'images/PIWO.png',
                          width: 150,
                          height: _animation.value,
                        );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'FUNNAVI',
                    style: kTitleTextStyleBlack,
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
                        height: 20,
                      ),
                      Text(
                        'Witaj !',
                        style: kTitleTextStyleWhite,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'TY wybierasz vibe, My dajemy ci spoty',
                            style: kDesctyprionTextStyleBlack,
                          ),
                          Text(
                            'Może za rogiem czeka Twój nowy ulubony lokal ?  👀👀',
                            style: kDesctyprionTextStyleBlack,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 80,
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
                      // const SizedBox(
                      //   height: 100,
                      // )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
