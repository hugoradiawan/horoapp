import 'package:flutter/material.dart';

extension HoroInput on InputDecoration {
  InputDecoration horoTransparent(
          {String? hintText, bool? isObscure, VoidCallback? onPressed}) =>
      InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        filled: true,
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
          borderSide: BorderSide.none,
        ),
      );
}
