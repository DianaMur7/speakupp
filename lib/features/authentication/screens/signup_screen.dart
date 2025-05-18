import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakup/features/authentication/controllers/signup_controller.dart';
import 'package:speakup/util/constants/sizes.dart';
import 'package:speakup/util/device/device_utility.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpCtrl = Get.put(SignUpController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: SSizes.md, vertical: SSizes.sm / 2),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black),
                ),
              ),
              child: const Text("Завести аккаунт"),
            ),
          ],
        ),
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
                  InkWell(
                    onTap: () {
                      signUpCtrl.imagePickerBottomSheet(context);
                    },
                    child: Obx(() {
                      return signUpCtrl.imageFilePath.value.isEmpty
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius:
                                  SDeviceUtils.getScreenWidth(context) * .25,
                              child: Icon(
                                Icons.person_outlined,
                                size: SDeviceUtils.getScreenWidth(context) * .4,
                              ))
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              radius:
                                  SDeviceUtils.getScreenWidth(context) * .25,
                              backgroundImage: FileImage(
                                File(signUpCtrl.imageFilePath.value),
                              ));
                    }),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections * 2),
                  TextFormField(
                    controller: signUpCtrl.fullName,
                    decoration: const InputDecoration(
                      hintText: "ЭФИО",
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: signUpCtrl.email,
                    decoration: const InputDecoration(
                      hintText: "Электронная почта ",
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: signUpCtrl.password,
                    decoration: const InputDecoration(
                      hintText: "Пароль",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: signUpCtrl.rePassword,
                    decoration: const InputDecoration(
                      hintText: "Подтвердите пароль",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),
                  SizedBox(
                      width: SDeviceUtils.getScreenWidth(context) * .8,
                      child: ElevatedButton(
                          onPressed: () => signUpCtrl.signUp(context,
                              fullName: signUpCtrl.fullName.text.toString(),
                              email: signUpCtrl.email.text.toString(),
                              password: signUpCtrl.password.text.toString(),
                              rePassword: signUpCtrl.rePassword.text.toString(),
                              image: signUpCtrl.imageFilePath.value),
                          child: const Text("SIGN UP"))),
                  const SizedBox(height: SSizes.spaceBtwSections / 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
