import 'package:flutter/material.dart';

import '../const.dart';

class CategorySlider extends StatefulWidget {
  String text;
  double ocena;
  void Function(double) onSlide;
  double maxSlide;
  Color bgcolor1;
  Color bgcolor2;
  int precyzja;

  CategorySlider(
      {super.key,
      required this.text,
      required this.onSlide,
      required this.maxSlide,
      required this.ocena,
      required this.bgcolor1,
      required this.bgcolor2,
      required this.precyzja});

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.bgcolor1,
              widget.bgcolor2,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15), // Zaokrąglenie rogów
        ),
        width: double.infinity,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  widget.text,
                  style: kDesctyprionTextStyleBlack,
                ),
              ),
              Expanded(
                child: Text(
                  widget.ocena.toStringAsFixed(2),
                  style: kDesctyprionTextStyleBlack,
                ),
              ),
              Expanded(
                flex: 3,
                child: Slider(
                    activeColor: Color(0xFF1E3A8A),
                    min: 0,
                    max: widget.maxSlide,
                    divisions: widget.precyzja,
                    value: widget.ocena,
                    onChanged: (value) {
                      setState(() {
                        widget.onSlide(value);
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
