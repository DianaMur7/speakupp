import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakup/features/authentication/controllers/login_controller.dart';
import 'package:speakup/features/authentication/screens/signup_screen.dart';
import 'package:speakup/util/constants/sizes.dart';
import 'package:speakup/util/device/device_utility.dart';

import '../../../util/constants/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LoginController loginCtrl = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Center(
            child: SizedBox(
              width: SDeviceUtils.getScreenWidth(context) * .8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Добро пожаловать в",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24, fontWeight: FontWeight.w300)),
                  Text("SpeakUP",
                      style: Theme.of(context).textTheme.headlineMedium),
                  const Divider(
                    color: Colors.black,
                    endIndent: SSizes.spaceBtwSections,
                    indent: SSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    height: SDeviceUtils.getScreenHeight(context) * .1,
                  ),
                  TextFormField(
                    controller: loginCtrl.email,
                    decoration:
                        const InputDecoration(hintText: "Электронная почта "),
                  ),
                  const SizedBox(height: SSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: loginCtrl.password,
                    decoration: const InputDecoration(
                        hintText: "Пароль",
                        prefixIcon: Icon(Icons.lock_outline)),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),
                  SizedBox(
                      width: SDeviceUtils.getScreenWidth(context) * .8,
                      child: ElevatedButton(
                          onPressed: () => loginCtrl.login(
                                context,
                                email: loginCtrl.email.text.toString(),
                                password: loginCtrl.password.text.toString(),
                              ),
                          child: const Text("LOG IN"))),
                  const SizedBox(height: SSizes.spaceBtwSections / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Нет аккаунта?",
                          style: Theme.of(context).textTheme.titleLarge),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const SignUpScreen());
                          },
                          child: Text(
                            "SignUp",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: SColors.primary),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
