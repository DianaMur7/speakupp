import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:speakup/features/authentication/screens/login_screen.dart';
import 'package:speakup/features/speakup/controllers/text_to_speech_controller.dart';
import 'package:speakup/features/speakup/screens/home_screen.dart';
import 'package:speakup/firebase_options.dart';
import 'package:speakup/util/helpers/firebase_hepler.dart';
import 'package:speakup/util/theme/theme.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;

  Get.lazyPut(() => TextToSpeechController());

  runApp(const SpeakUp());
}

class SpeakUp extends StatelessWidget {
  const SpeakUp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: STheme.sTheme,
      home: SFireHelper.fireAuth.currentUser != null
          ? HomeScreen()
          : const LoginScreen(),
    );
  }
}
