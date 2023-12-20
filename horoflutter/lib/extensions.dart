import 'package:flutter/material.dart';

extension HoroInput on InputDecoration {
  InputDecoration horoTransparent({
    String? hintText,
    bool? isObscure,
    VoidCallback? onPressed,
    bool isDense = false,
    bool isBordered = false,
    String? unit,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.white,
      ),
      filled: true,
      suffix: unit != null
          ? Text(
              unit,
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          : null,
      suffixIcon: isObscure != null
          ? IconButton(
              onPressed: onPressed,
              icon: Icon(
                isObscure == true ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
            )
          : null,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: isBordered
            ? const BorderSide(color: Colors.white)
            : BorderSide.none,
      ),
      isDense: isDense,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: isBordered
            ? BorderSide(color: Colors.white.withOpacity(0.4))
            : BorderSide.none,
      ),
    );
  }
}
