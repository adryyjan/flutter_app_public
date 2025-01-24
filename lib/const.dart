import 'package:flutter/material.dart';

const kTitleTextStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w900);

const kDesctyprionTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w900,
  color: Colors.black,
);

const kBiggerTitleTextStyle =
    TextStyle(fontSize: 40, fontWeight: FontWeight.w900);

var kGradient = BoxDecoration(
  gradient: const LinearGradient(
    colors: [Color(0xFFffb114), Color(0xFFFFD700)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  borderRadius: BorderRadius.circular(15), // Zaokrąglenie rogów
);

const kTlo = Color.fromRGBO(254, 255, 218, 1);

const kZakladka = BoxDecoration(
  color: kTlo,
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
  ),
);
