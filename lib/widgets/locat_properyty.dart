import 'package:flutter/material.dart';

class LocalProperyty extends StatelessWidget {
  String text;
  String? wartosc;
  LocalProperyty({super.key, required this.text, required this.wartosc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFffb114),
              Color(0xFFDB200C),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        // color: kBgDarker,

        // height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Expanded(
              child: SizedBox(),
            ),
            // SizedBox(
            //   width: 50,
            // ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  wartosc.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
