import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speakup/features/speakup/models/user_model.dart';
import 'package:speakup/features/speakup/screens/home_screen.dart';
import 'package:speakup/util/helpers/firebase_hepler.dart';
import 'package:speakup/util/helpers/helper_functions.dart';

class SignUpController extends GetxController {
  /// Text Fields Controller
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController rePassword = TextEditingController();

  /// Image File Variable
  RxString imageFilePath = ''.obs;
  RxString imageUrl = ''.obs;

  /// Fields Validations Function
  void signUp(BuildContext context,
      {required String fullName,
      required String image,
      required String email,
      required String password,
      required String rePassword}) {
    if (image.isNotEmpty) {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          password.isNotEmpty &&
          rePassword.isNotEmpty) {
        if (SHelperFunctions.isEmailValid(email: email)) {
          if (password == rePassword) {
            ///Call SignUp User Function
            signUpUser(context, email: email, password: password)
                .then((value) async {
              try {
                /// Call Upload Image & Get Url Function
                await uploadImageGetLink(image: image).then((value) async {
                  /// Pass Data to UserModel
                  final UserModel user = UserModel(
                      userId: SFireHelper.fireAuth.currentUser!.uid,
                      username: fullName,
                      email: email,
                      password: password,
                      imageUrl: imageUrl.value);

                  /// Call Upload User data
                  await uploadUserData(user).then((value) {
                    SHelperFunctions.hideProgressIndicator();
                    Get.offAll(HomeScreen());
                  });
                });
              } catch (e) {
                SHelperFunctions.showSnackBar(
                    'Error occurred while uploading to Firebase Storage. $e');
              }
            });
          } else {
            SHelperFunctions.showSnackBar(
                "Your password & repassword not same");
          }
        } else {
          SHelperFunctions.showSnackBar("Your email invalid");
        }
      } else {
        SHelperFunctions.showSnackBar("Please Fill All Fields");
      }
    } else {
      SHelperFunctions.showSnackBar("Please Select Image");
    }
  }

  /// Upload User To FireStore Function
  Future<void> uploadUserData(UserModel user) async {
    try {
      await SFireHelper.fireStore
          .collection("Users")
          .doc(SFireHelper.fireAuth.currentUser!.uid)
          .set(user.toJson());
    } catch (e) {
      SHelperFunctions.hideProgressIndicator();
      SHelperFunctions.showSnackBar("Uploading $e");
    }
  }

  /// User SignUp WithMail & Password Function
  Future<void> signUpUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    SHelperFunctions.showProgressIndicator(context);
    try {
      await SFireHelper.fireAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        SHelperFunctions.hideProgressIndicator();
        SHelperFunctions.showSnackBar('The password provided is too weak.');
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        SHelperFunctions.hideProgressIndicator();
        SHelperFunctions.showSnackBar(
            'The account already exists for that email.');
        // print('The account already exists for that email.');
      }
    } catch (e) {
      SHelperFunctions.hideProgressIndicator();
      SHelperFunctions.showSnackBar(e.toString());
    }
  }

  /// Upload Image to Firebase Storage Function
  Future<void> uploadImageGetLink({required String image}) async {
    try {
      String fileName =
          'ProfileImages/${DateTime.now().millisecondsSinceEpoch.toString()}_${Random().nextInt(10000)}.jpg';
      await FirebaseStorage.instance
          .ref(fileName)
          .putFile(File(image))
          .then((value) async {
        await FirebaseStorage.instance
            .ref(fileName)
            .getDownloadURL()
            .then((value) {
          imageUrl.value = value;
        });
      });
    } catch (e) {
      SHelperFunctions.hideProgressIndicator();
      SHelperFunctions.showSnackBar(
          'Error occurred while uploading to Firebase Storage. $e');
    }
  }

  ///Image Picker Function
  Future<String> imagePicker(ImageSource imageSource) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: imageSource);
    // print("picking file");
    if (xFile != null) {
      // CroppedFile? croppedFile = await ImageCropper().cropImage(
      //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      //   sourcePath: xFile.path,
      //   aspectRatioPresets: [
      //     CropAspectRatioPreset.square,
      //   ],
      //   uiSettings: [
      //     AndroidUiSettings(
      //         toolbarTitle: 'Cropper',
      //         toolbarColor: Colors.deepOrange,
      //         toolbarWidgetColor: Colors.white,
      //         initAspectRatio: CropAspectRatioPreset.original,
      //         lockAspectRatio: false),
      //     IOSUiSettings(
      //       title: 'Cropper',
      //     ),
      //   ],
      // );
      // if (croppedFile == null) {
      return xFile.path;
      // }
      // return croppedFile.path;
    } else {
      return '';
    }
  }

  /// Image Picker bottom Sheet Function
  Future<String> imagePickerBottomSheet(BuildContext context) async {
    String? imagePath = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 170,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String imagePath =
                          await imagePicker(ImageSource.camera).then((value) {
                        imageFilePath.value = value;
                        return value;
                      });

                      Navigator.of(context).pop(imagePath);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "CAMERA",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      String imagePath =
                          await imagePicker(ImageSource.gallery).then((value) {
                        imageFilePath.value = value;
                        return value;
                      });

                      Navigator.of(context).pop(imagePath);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "GALLERY",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
    return imagePath ?? "";
  }
}
