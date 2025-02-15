import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/filter.dart';
import '../const.dart';
import '../providers/filterProvider.dart';

class CategoryRodzajList extends ConsumerStatefulWidget {
  String text;
  List<String> lista;
  final String filterKey;
  Color bgcolor1;
  Color bgcolor2;

  void Function(dynamic) onSelect;

  CategoryRodzajList({
    super.key,
    required this.text,
    required this.onSelect,
    required this.filterKey,
    required this.lista,
    required this.bgcolor1,
    required this.bgcolor2,
  });

  @override
  ConsumerState<CategoryRodzajList> createState() => _CategoryRodzajListState();
}

class _CategoryRodzajListState extends ConsumerState<CategoryRodzajList> {
  dynamic _getFilterValue(FilterData filter) {
    switch (widget.filterKey) {
      case 'rodzajLokalu':
        return filter.rodzajLokalu;
      case 'glownaSpecjalnosc':
        return filter.glownaSpecjalnosc;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(filterProvider);

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
              DropdownButton<String>(
                value: widget.lista.contains(_getFilterValue(filter))
                    ? _getFilterValue(filter)
                    : widget.lista.first,
                elevation: 16,
                iconSize: 30.0,
                icon: Padding(
                  padding: EdgeInsets.all(0), // Zmniejszenie odstępu
                  child: Icon(Icons.arrow_drop_down),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    if (widget.filterKey == 'rodzajLokalu') {
                      filter.rodzajLokalu = value!;
                    } else if (widget.filterKey case 'glownaSpecjalnosc') {
                      filter.glownaSpecjalnosc = value!;
                    } else {
                      return null;
                    }
                  });
                  widget.onSelect(value);
                },
                items:
                    widget.lista.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
