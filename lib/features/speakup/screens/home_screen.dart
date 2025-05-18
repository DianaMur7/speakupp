import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakup/common/widgets/appbar.dart';
import 'package:speakup/features/speakup/controllers/speech_controller.dart';
import 'package:speakup/features/speakup/screens/map_screen.dart';
import 'package:speakup/util/constants/image_strings.dart';
import 'package:speakup/util/constants/sizes.dart';
import 'package:speakup/util/device/device_utility.dart';
import 'package:speakup/features/speakup/controllers/text_to_speech_controller.dart';
import 'package:video_player/video_player.dart';
import '../../../util/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechController speechController = Get.put(SpeechController());
  final TextToSpeechController textController = Get.put(TextToSpeechController());
  final ValueNotifier<bool> isListeningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);

  late final VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset('assets/images/video.mp4')
      ..initialize().then((_) {
        videoController.setLooping(true);
        setState(() {});
      });
  }

  String get statusText {
    if (speechController.isListening) {
      return 'Слушаю...';
    } else if (textController.isThinking) {
      return 'Думаю...';
    } else if (textController.isSpeaking) {
      return textController.lastChatResponse;
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: buildAppBar(),
    body: Stack(
      children: [
        buildBody(),
        Align(
          alignment: Alignment.bottomCenter,
          child: buildBottomSheet(),
          
        ),
      ],
    ),
  );
}

  SAppBar buildAppBar() {
    return const SAppBar(
      page: "Home",
      title: "Привет, я Спичи!",
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildVideoOrImage(),
            
          ],
        ),
      ),
    );
  }

  Obx buildVideoOrImage() {
      return Obx(() {
    if (textController.isSpeaking) {
      videoController.play();
      return AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: VideoPlayer(videoController),
      );
    } else {
      videoController.pause();
      return Image.asset(
        'assets/images/robo.PNG',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      );
    }
  });
  }

  Container buildBottomSheet() {
    return Container(
      // padding: const EdgeInsets.all(SSizes.spaceBtwSections * 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      
      height: SDeviceUtils.getScreenHeight(context) * .4,
      width: SDeviceUtils.getScreenWidth(context),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildStatusText(),
                ],
              ),
            ),
          ),
          const SizedBox(height: SSizes.spaceBtwSections),
          
          buildMicButton(),
        ],
      ),
    );
  }

Obx buildStatusText() {
  return Obx(() {
    return Container(
      padding: const EdgeInsets.all(SSizes.spaceBtwSections),
      width: MediaQuery.of(context).size.width, // Ensures the container takes full width
      child: Text(
        statusText,
        textAlign: TextAlign.center,  // Optional based on your desired text alignment
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14, height: 2),
      ),
    );
  });
}


  Obx buildLastChatResponse() {
    return Obx(() {
      return Text(
        textController.lastChatResponse,
        style: Theme.of(context).textTheme.titleLarge,
      );
    });
  }

  Obx buildMicButton() {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: IconButton(
              padding: const EdgeInsets.all(8),
              icon: Icon(
                Icons.mic,
                color: Colors.white,
              ),
              iconSize: 80,
              onPressed: () {
                // Если isThinking или isSpeaking равно true, просто вернуться
                if (textController.isThinking || textController.isSpeaking) {
                  return;
                }else{
                  speechController.listen();
                  isListeningNotifier.value = speechController.isListening;
                }
                
              },
              alignment: Alignment.center,
              style: IconButton.styleFrom(
                backgroundColor: speechController.isListening ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      );
    });
  }
}