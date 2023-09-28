import 'package:fashion_ai/app_theme.dart';
import 'package:fashion_ai/models/chat_model.dart';
import 'package:fashion_ai/models/scrapper_output_model.dart';
import 'package:fashion_ai/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langchain/langchain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiController extends GetxController{
  var isDark;
  var aiResponse = "".obs;
  var chatHistory = <ChatModel>[].obs;
  var humanHistory = <String>[].obs;
  static var memory = ConversationBufferMemory();
  var itemList = <String>[].obs;
  var productsList = <List<ScrapperOutputModel>>[];
  var richText = RichText(text: TextSpan(text: "Searching Flipkart", style: TextStyle(color: AppTheme.lightThemeData.colorScheme.primary,))).obs;


@override
  void onInit() {
    // TODO: implement onInit
  getThemeMode();
  super.onInit();
  }

  Future<void> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("themeMode");
    isDark ??= true;
  }

  Future<void> writeThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("themeMode", isDark);
  }


  void changeTheme(state){
    if (state == true){
      Get.changeThemeMode(ThemeMode.dark);
      isDark = true;
    }
    else{
      Get.changeThemeMode(ThemeMode.light);
      isDark = false;
    }
    writeThemeMode(isDark);
    update();
  }

}