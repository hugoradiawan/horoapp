import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/extensions.dart';
import 'package:horoflutter/ui_loc/login_register_controller.dart';
import 'package:horoflutter/uis/glow_button.dart';

class LoginPage extends GetView<LoginRegisterController> {
  const LoginPage({super.key});

  @override
  Widget build(_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Login",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            child: TextField(
              onChanged: (value) {
                controller.loginUserDto.update((val) {
                  if (val == null) return;
                  val.usernameOrEmail = value;
                });
              },
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration().horoTransparent(
                hintText: 'Enter Email/Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            child: Obx(
              () => TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.loginUserDto.update((val) {
                    if (val == null) return;
                    val.password = value;
                  });
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                obscureText: controller.isObscure.value,
                decoration: const InputDecoration(
                  suffix: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                ).horoTransparent(
                  hintText: 'Enter Password',
                  isObscure: controller.isObscure.value,
                  onPressed: controller.isObscure.toggle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            child: GlowButton(
              text: 'Login',
              onPressed: () => controller.login(),
            ),
          ),
          const Gap(30),
          RichText(
            text: TextSpan(
                text: 'Don\'t have an account? ',
                style: const TextStyle(
                  color: Colors.white,
                ),
                children: [
                  WidgetSpan(
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.yellow,
                    ),
                    child: InkWell(
                      key: const Key('RegisterSwitch'),
                      onTap: controller.toggleLoginRegister,
                      child: const Text(
                        'Register here',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  )
                ]),
          )
        ],
      );
}
