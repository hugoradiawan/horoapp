import 'package:flutter/material.dart';

extension HoroInput on InputDecoration {
  InputDecoration horoTransparent({
    String? hintText,
    String? prefixText,
    bool? isObscure,
    VoidCallback? onPressed,
    Widget? prefixIcon,
    String? errorText,
    TextStyle? hintStyle,
    bool isDense = false,
    bool isBordered = false,
    String? unit,
    double borderRadius = 10,
  }) {
    return InputDecoration(
      hintText: hintText,
      errorText: errorText,
      prefixText: prefixText,
      hintStyle: hintStyle ??
          const TextStyle(
            color: Colors.white,
          ),
      filled: true,
      prefixIcon: prefixIcon,
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
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: isBordered
            ? const BorderSide(color: Colors.white)
            : BorderSide.none,
      ),
      isDense: isDense,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: isBordered
            ? const BorderSide(color: Colors.white)
            : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: isBordered
            ? BorderSide(color: Colors.white.withOpacity(0.4))
            : BorderSide.none,
      ),
    );
  }
}
