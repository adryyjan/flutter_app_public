import 'package:flutter/material.dart';

import '../const.dart';
// import 'package:funnavi/data/jsonData.dart';

class CategorySlider extends StatefulWidget {
  String text;
  double ocena;
  void Function(double) onSlide;
  double maxSlide;
  Color bgcolor;
  int precyzja;

  CategorySlider(
      {super.key,
      required this.text,
      required this.onSlide,
      required this.maxSlide,
      required this.ocena,
      required this.bgcolor,
      required this.precyzja});

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  bool isFirts = true;
  double rating = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.bgcolor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
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
                  style: kDesctyprionTextStyle,
                ),
              ),
              Expanded(
                child: Text(
                  rating == -1
                      ? widget.ocena.toStringAsFixed(2)
                      : rating.toStringAsFixed(2),
                  style: kDesctyprionTextStyle,
                ),
              ),
              Expanded(
                flex: 3,
                child: Slider(
                    min: 0,
                    max: widget.maxSlide,
                    divisions: widget.precyzja,
                    value: rating == -1 ? widget.ocena : rating,
                    onChanged: (value) {
                      setState(() {
                        isFirts = false;
                        rating = value;
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
