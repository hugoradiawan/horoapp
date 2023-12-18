import 'package:flutter/material.dart';

class GlowButton extends StatelessWidget {
  const GlowButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(_) => InkWell(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 98, 205, 203),
                Color.fromARGB(255, 69, 153, 219)
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ),
        ),
      );
}
