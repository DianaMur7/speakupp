import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextToSpeechController extends GetxController {
  final RxString spokenText = ''.obs;
  final RxBool _isSpeaking = false.obs;
  final RxBool _isThinking = false.obs;
  final player = AudioPlayer();
  final RxString _lastChatResponse = ''.obs;

  Future<void> generateText(String inputText) async {
    _isThinking.value = true;

    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Тебя зовут Спичи, это твое имя. Нужно чтобы бот поддерживал разговор (сonversional bot). "
          "Он отвечал на вопрос или утверждение от пользователя комментариями и поддерживал диалог, задавая наталкивающие вопросы. "
          "Это твой слоган: Привет! Меня зовут Спичи, и я готова с тобой общаться в любое время. Нажми на микрофон, задавай интересующие тебя вопросы или просто расскажи о том, как прошел твой день. "
          "Давай дружить и развиваться!",
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(inputText),
      ],
      role: OpenAIChatMessageRole.user,
    );

    final requestMessages = [systemMessage, userMessage];

    final chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo-1106",
      responseFormat: {"type": "text"},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    final contentItems = chatCompletion.choices.first.message.content;
    String text = contentItems?.map((e) => e.toString()).join(" ") ?? '';
    String newText = text.isNotEmpty ? text.split(" ").skip(3).join(" ").trim() : '';
    if (newText.endsWith('.')) {
      newText = newText.substring(0, newText.length - 1);
    }

    _lastChatResponse.value = newText;
    await speakText(newText);
  }

  Future<void> speakText(String message, {String voice = "nova"}) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String outputPath = "${appDocDir.path}/speechOutput";

    File speechFile = await OpenAI.instance.audio.createSpeech(
      model: "tts-1",
      input: message,
      voice: voice,
      responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
      outputDirectory: await Directory(outputPath).create(),
      outputFileName: "speech",
    );

    await player.play(DeviceFileSource(speechFile.path));
    await player.pause(); // Pause immediately to get duration
    Duration? durationValue = await player.getDuration();

    await player.seek(Duration.zero);
    await player.play(DeviceFileSource(speechFile.path));

    _isThinking.value = false;
    _isSpeaking.value = true;

    if (durationValue != null) {
      await Future.delayed(durationValue);
    }

    _isSpeaking.value = false;
    await player.pause();
  }

  @override
  void onInit() {
    super.onInit();
  }

  bool get isSpeaking => _isSpeaking.value;
  bool get isThinking => _isThinking.value;
  String get lastChatResponse => _lastChatResponse.value;
}
