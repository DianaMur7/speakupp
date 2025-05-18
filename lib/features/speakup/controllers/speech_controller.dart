import 'package:get/get.dart';
import 'package:azure_speech_recognition_null_safety/azure_speech_recognition_null_safety.dart';
import 'package:speakup/features/speakup/controllers/text_to_speech_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechController extends GetxController {
  late AzureSpeechRecognition _speechAzure;
  bool wasStoppedByUser = false;
  final RxBool _isListening = false.obs;
  final RxString listenText = ''.obs;
  String subKey = '325c5affd8944f2b8a1ab0ce9c9d0817';
  String region = 'southeastasia';
  String lang = 'ru-RU';
  
  final textConroller = Get.find<TextToSpeechController>();

  void activateSpeechRecognizer() {
    AzureSpeechRecognition.initialize(subKey, region, lang: lang, timeout: "1000");

    _speechAzure.setFinalTranscription((text) {
      _isListening.value = false;
      listenText.value = text;
      print(listenText.value);
      AzureSpeechRecognition.stopContinuousRecognition();
    });

    _speechAzure.setRecognitionResultHandler((text) {
      print("Received partial result in recognizer: $text");
      // _isListening.value = false;
    });

    _speechAzure.setRecognitionStartedHandler(() {
      _isListening.value = true;
      print("Recognition started");
    });

    _speechAzure.setRecognitionStoppedHandler(() {
      _isListening.value = false;
      print("Recognition stopped");
      if (!wasStoppedByUser) {
        textConroller.generateText(listenText.value);
      } 
    });
  }


void listen() async {
  var status = await Permission.microphone.status;
  if (status.isDenied) {
    // Мы не имеем разрешения на микрофон, уведомляем пользователя
    Get.snackbar('Нет доступа', 'Пожалуйста, предоставьте доступ к микрофону в настройках');
  } else {
    // У нас есть разрешение на микрофон, продолжаем
    if (!_isListening.value) {
      _isListening.value = true;
      AzureSpeechRecognition.continuousRecording();
    }
  }
}

void stopListening() {
  AzureSpeechRecognition.stopContinuousRecognition();
  listenText.value = '';
  _isListening.value = false;
  print("Stopped recognition");
}

  @override
  void onInit() {
    _speechAzure = AzureSpeechRecognition();
    activateSpeechRecognizer();
    super.onInit();
  }

  bool get isListening => _isListening.value;

  set isListening(bool value) {
    _isListening.value = value;
  }
}