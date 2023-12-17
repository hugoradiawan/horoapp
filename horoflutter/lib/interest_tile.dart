import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/interest_page.dart';

class InterestTile extends StatelessWidget {
  const InterestTile({
    super.key,
  });

  @override
  Widget build(_) => Container(
        height: 125,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  "Interest",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.to(
                    () => const InterestPage(),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Add in your interest to find a better match",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ]),
      );
}
