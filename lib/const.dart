import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kTitleTextStyle =
    GoogleFonts.poppins(fontSize: 70, fontWeight: FontWeight.w900);

var kDesctyprionTextStyleWhite = GoogleFonts.montserrat(
    fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white);

var kDesctyprionTextStyleBlack = GoogleFonts.montserrat(
    fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black);

var kBiggerTitleTextStyle = GoogleFonts.poppins(
    fontSize: 70, fontWeight: FontWeight.w900, color: Colors.white);

var kGradientYO = BoxDecoration(
  gradient: const LinearGradient(
    colors: [Color(0xFFffb114), Color(0xFFFFD700)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  borderRadius: BorderRadius.circular(15),
);
var kGradientBR = LinearGradient(
  colors: [
    Color(0xFF1E3A8A),
    Color(0xFFDB200C),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const kTlo = Color(0xFFE0E0E0);

const kZakladka = BoxDecoration(
  color: kTlo,
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
  ),
);
