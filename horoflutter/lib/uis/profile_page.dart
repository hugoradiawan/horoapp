import 'package:flutter/material.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/profile_content.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(_) => const Background(
        child: ProfileContent(),
      );
}