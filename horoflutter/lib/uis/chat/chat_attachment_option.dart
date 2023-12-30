import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatAttachmentOption extends StatelessWidget {
  const ChatAttachmentOption({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });
  final String label;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(_) => InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          width: 70,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color.fromARGB(255, 29, 64, 69),
              ),
              const Gap(5),
              Text(
                label,
                style: const TextStyle(
                  color: Color.fromARGB(255, 29, 64, 69),
                ),
              ),
            ],
          ),
        ),
      );
}
