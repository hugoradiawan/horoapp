import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ExpandTile extends StatelessWidget {
  const ExpandTile({
    super.key,
    required this.title,
    this.children,
    required this.subtitle,
  });

  final String title, subtitle;
  final List<Widget>? children;

  @override
  Widget build(_) {
    final RxBool isExpanded = false.obs;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ExpansionTile(
            backgroundColor: Colors.white.withOpacity(0.1),
            collapsedBackgroundColor: Colors.white.withOpacity(0.1),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            onExpansionChanged: (value) => isExpanded.value = value,
            controlAffinity: ListTileControlAffinity.trailing,
            trailing: const SizedBox.shrink(),
            title: SizedBox(
              width: double.infinity,
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                      ),
                      if (!isExpanded.value)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Gap(15),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            const Gap(10),
                          ],
                        )
                      else
                        const SizedBox.shrink()
                    ],
                  )),
            ),
            children: children ?? const [],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => !isExpanded.value
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )
                      : TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Save & Update",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                const Gap(20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
