import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/extensions.dart';
import 'package:horoflutter/uis/about/about_tile_controller.dart';
import 'package:horoflutter/uis/about/custon_dropdown.dart';

class AboutTextField extends GetView<AboutTileController> {
  const AboutTextField({
    super.key,
    required this.label,
    this.tec,
    this.isNumberic = false,
    this.unit,
    this.isDate = false,
    this.isReadOnly = false,
    this.options = const <String>[],
  });

  final String label;
  final String? unit;
  final bool isNumberic, isDate, isReadOnly;
  final List<String> options;
  final TextEditingController? tec;

  @override
  Widget build(_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                "$label:",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              flex: 4,
              child: options.isEmpty
                  ? TextField(
                      controller: tec,
                      textAlign: TextAlign.end,
                      readOnly: isReadOnly || isDate,
                      onTap: isDate ? () => controller.pickDate(tec) : null,
                      keyboardType: isNumberic
                          ? TextInputType.number
                          : TextInputType.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration().horoTransparent(
                        isBordered: true,
                        isDense: true,
                        unit: unit,
                      ),
                    )
                  : CustomDropdown(
                      rxValue: controller.selectedGender,
                      options: options,
                    ),
            ),
          ],
        ),
      );
}