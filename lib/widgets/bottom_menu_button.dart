import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/riverpod.dart';

class BottomMenuButton extends ConsumerStatefulWidget {
  final String ekran;
  final IconData ikona;
  bool is_checked;
  BottomMenuButton({
    super.key,
    required this.ekran,
    required this.ikona,
    required this.is_checked,
  });

  @override
  ConsumerState<BottomMenuButton> createState() => _BottomMenuButtonState();
}

class _BottomMenuButtonState extends ConsumerState<BottomMenuButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, widget.ekran);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedLokalProvider.notifier).state = null;
            ref.read(selectedOfertaProvider.notifier).state = null;
          });
        },
        // child: widget.ikona,

        child: widget.is_checked
            ? Card(
                child: Icon(
                  widget.ikona,
                  color: Colors.black,
                  size: 40,
                  weight: 30,
                  opticalSize: 40,
                  // shadows: [Shadow(color: Colors.black)],
                ),
              )
            : Icon(
                widget.ikona,
                color: Colors.black,
                size: 30,
                weight: 20,
                opticalSize: 30,
                // shadows: [Shadow(color: Colors.black)],
              ),
      ),
    );
  }
}
