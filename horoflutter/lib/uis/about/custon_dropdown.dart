import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.rxValue,
    required this.options,
  });

  final RxnString rxValue;
  final List<String> options;

  @override
  Widget build(_) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: Obx(
            () => DropdownButton<String>(
              value: rxValue.value,
              onChanged: rxValue,
              icon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: const Color.fromARGB(255, 11, 24, 30),
              items: options
                  .map(
                    (e) => DropdownMenuItem<String>(
                      alignment: Alignment.centerRight,
                      value: e,
                      child: SizedBox(
                        width: Get.width * 0.45,
                        child: Text(
                          e,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

      
}
