import 'package:flutter/material.dart';
import 'package:funnavi/const.dart';
// import 'package:funnavi/data/jsonData.dart';

class CategorySwitch extends StatefulWidget {
  String text;
  bool isSwitched;
  void Function(bool) onSwitch;
  Color bgcolor1;
  Color bgcolor2;

  CategorySwitch({
    super.key,
    required this.isSwitched,
    required this.text,
    required this.onSwitch,
    required this.bgcolor1,
    required this.bgcolor2,
  });

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
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: kDesctyprionTextStyleBlack,
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
