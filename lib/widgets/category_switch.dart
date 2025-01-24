import 'package:flutter/material.dart';
import 'package:funnavi/const.dart';
// import 'package:funnavi/data/jsonData.dart';

class CategorySwitch extends StatefulWidget {
  String text;
  bool isSwitched;
  void Function(bool) onSwitch;
  Color bgcolor;

  CategorySwitch(
      {super.key,
      required this.isSwitched,
      required this.text,
      required this.onSwitch,
      required this.bgcolor});

  @override
  State<CategorySwitch> createState() => _CategoryRodzajState();
}

class _CategoryRodzajState extends State<CategorySwitch> {
  bool isfirts = true;
  late bool switcher;
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
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: kDesctyprionTextStyle,
              ),
              Switch(
                value: isfirts ? widget.isSwitched : switcher,
                onChanged: (value) {
                  setState(() {
                    isfirts = false;
                    switcher = value;
                    widget.isSwitched = value;
                  });
                  widget.onSwitch(value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
