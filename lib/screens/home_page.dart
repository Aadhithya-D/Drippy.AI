import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:fashion_ai/components/chat_text_field.dart';
import 'package:fashion_ai/components/my_textfield.dart';
import 'package:fashion_ai/controllers/ai_controller.dart';
import 'package:fashion_ai/screens/flipkart_page.dart';
import 'package:fashion_ai/services/chat_service.dart';
import 'package:fashion_ai/services/scrapper_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key});

  final TextEditingController chatController = TextEditingController();
  final AiController aiController = Get.put(AiController());

  @override
  Widget build(BuildContext context) {
    void signUserOut() {
      FirebaseAuth.instance.signOut();
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: Text(
            "Drippy.AI",
            style: GoogleFonts.ibmPlexMono(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: signUserOut,
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: SafeArea(
          child: Obx(() {
            return Column(
              children: [
                SizedBox(height: 5),
                Expanded(child: _buildChatMessageList()),
                _buildPlaceHolder(),
                _buildChatMessageInput(context),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildChatMessageList() {
    return Obx(() {
      if (aiController.humanHistory.isEmpty) {
        return Image.asset(
          "assets/images/undraw_chat_re_re1u.png",
          width: 250,
        );
      } else {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _buildChatMessage(index);
          },
          itemCount: aiController.chatHistory.length,
        );
      }
    });
  }

  Widget _buildPlaceHolder() {
    if (aiController.humanHistory.length > aiController.chatHistory.length) {
      return Column(
        children: [
          BubbleSpecialThree(
            text: aiController.humanHistory.last,
            color: Color(0xFF1B97F3),
            tail: true,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          BubbleNormalImage(
            id: 'id001',
            image: Image.asset(
              "assets/images/animation_lljc1k50_small.gif",
              height: 30,
            ),
            color: Color(0xFFE8E8EE),
            tail: true,
            isSender: false,
          ),
          SizedBox(height: 5),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildChatMessage(int index) {
    return Column(
      children: [
        BubbleSpecialThree(
          text: aiController.chatHistory[index].humanMessage,
          color: Color(0xFF1B97F3),
          tail: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        BubbleSpecialThree(
          text: aiController.chatHistory[index].aiMessage,
          color: Color(0xFFE8E8EE),
          tail: true,
          isSender: false,
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildChatMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        children: [
          Expanded(
            child: ChatTextField(
              controller: chatController,
              hintText: "Message",
              icon: Icons.chat_bubble,
              obscureText: false,
              type: TextInputType.text,
            ),
          ),
          IconButton(
            onPressed: () async {
              var text = chatController.text;
              if (text != "Search") {
                aiController.humanHistory.add(text);
                chatController.clear();
                aiController.chatHistory.add(await ChatService().chat(text));
              } else {
                aiController.humanHistory.add(text);
                chatController.clear();
                var temp = await ChatService()
                    .summary(aiController.chatHistory.last.aiMessage);

                var sum = temp.aiMessage;
                List<String> productArray =
                    sum.replaceAll('[', '').replaceAll(']', '').replaceAll("'", '').split(',');
                aiController.itemList.addAll(productArray);
                ScrapperService().searchFlipkart();
              }
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
