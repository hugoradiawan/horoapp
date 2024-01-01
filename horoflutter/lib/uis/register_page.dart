import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/extensions.dart';
import 'package:horoflutter/ui_loc/login_register_controller.dart';
import 'package:horoflutter/uis/glow_button.dart';

class RegisterPage extends GetView<LoginRegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Register",
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
            child: ObxValue<RxnString>(
              (val) => TextField(
                key: const Key('emailtec'),
                onChanged: controller.validateEmail,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration().horoTransparent(
                  hintText: 'Enter Email',
                  errorText: val.value,
                ),
              ),
              controller.emailError,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            child: ObxValue<RxnString>(
              (val) => TextField(
                key: const Key('usernametec'),
                onChanged: controller.validateUsername,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration().horoTransparent(
                  errorText: val.value,
                  hintText: 'Enter Username',
                  prefixText: '@',
                ),
              ),
              controller.usernameError,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            child: Obx(
              () => TextField(
                key: const Key('passwordtec'),
                keyboardType: TextInputType.number,
                onChanged: controller.validatePassword,
                style: const TextStyle(color: Colors.white),
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
                  errorText: controller.passwordError.value,
                ),
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
                key: const Key('confirmpasswordtec'),
                keyboardType: TextInputType.number,
                onChanged: controller.validateConfirmPassword,
                style: const TextStyle(color: Colors.white),
                obscureText: controller.isObscure.value,
                decoration: const InputDecoration(
                  suffix: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                ).horoTransparent(
                  hintText: 'Confirm Password',
                  isObscure: controller.isObscure.value,
                  onPressed: controller.isObscure.toggle,
                  errorText: controller.confirmPasswordError.value,
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
              key: const Key('registerbtn'),
              text: 'Register',
              onPressed: () => controller.register(),
            ),
          ),
          const Gap(30),
          RichText(
            text: TextSpan(
                text: 'Have an account? ',
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
                      key: const Key('loginswitch'),
                      onTap: controller.toggleLoginRegister,
                      child: const Text(
                        'Login here',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  )
                ]),
          )
        ],
      );
}
