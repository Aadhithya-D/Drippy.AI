import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ai_controller.dart';

class FlipKartPage extends StatelessWidget {
  FlipKartPage({super.key});
  final AiController aiController = Get.put(AiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Obx(() {
        return SafeArea(
          child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(9.0),child: aiController.richText.value)),
        );
      }),
    );
  }
}
