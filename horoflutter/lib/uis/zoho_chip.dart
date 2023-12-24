import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ZohoChip extends StatelessWidget {
  const ZohoChip({
    super.key,
    required this.iconName,
    required this.data,
  });

  final String iconName, data;

  @override
  Widget build(_) => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconName),
            const Gap(5),
            Text(
              data,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
