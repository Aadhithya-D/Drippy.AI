import 'package:fashion_ai/controllers/ai_controller.dart';
import 'package:fashion_ai/models/chat_model.dart';
import 'package:fashion_ai/models/scrapper_output_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../app_theme.dart';

class ScrapperService {
  static var client = http.Client();
  final AiController aiController = Get.put(AiController());

  Future<void> searchFlipkart() async {
    for (int i = 0; i < aiController.itemList.length; i++) {
      String query = aiController.itemList[i];
      query = query.replaceAll(" ", "_");
      print(
          "https://flipkart-scraper-api.dvishal485.workers.dev/search/$query");
      var response = await client.get(Uri.parse(
          "https://flipkart-scraper-api.dvishal485.workers.dev/search/$query"));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var data = jsonDecode(jsonString);
        var returnData = data['result'];
        var tempList = <ScrapperOutputModel>[];
        for (int j = 0; j < 3; j++) {
          var temp = ScrapperOutputModel(
              name: returnData[j]["name"],
              link: returnData[j]["link"],
              currentPrice: returnData[j]["current_price"],
              originalPrice: returnData[j]["original_price"],
              discounted: returnData[j]["discounted"],
              thumbnail: returnData[j]["thumbnail"],
              queryUrl: returnData[j]["query_url"]);
          tempList.add(temp);
        }
        aiController.productsList.add(tempList);
        print(returnData);
      }
    }
    var output = <TextSpan>[];
    var output1 = "";
    for (int i = 0; i < aiController.itemList.length; i++) {
      var t1 = "Item: ${aiController.itemList[i]}\n\nProduct 1\n\n- Product Name: ${aiController.productsList[i][0].name}\n- Product URL:  ${aiController.productsList[i][0].link}\n- Product Price: ${aiController.productsList[i][0].currentPrice}\n\nProduct 2\n\n- Product Name: ${aiController.productsList[i][1].name}\n- Product URL: ${aiController.productsList[i][1].link}\n- Product Price: ${aiController.productsList[i][1].currentPrice}\n\nProduct 3\n\n- Product Name: ${aiController.productsList[i][2].name}\n- Product URL: ${aiController.productsList[i][2].link}\n- Product Price: ${aiController.productsList[i][2].currentPrice}\n\n";
      var t = TextSpan(
              children: [
                TextSpan(
                    text: "Item: ${aiController.itemList[i]}\n\nProduct 1\n\n- Product Name: ${aiController.productsList[i][0].name}\n- Product URL:  "
                    , style: TextStyle(color: AppTheme.lightThemeData.colorScheme.tertiary,)
                ),
                TextSpan(
                    text: "Click here",
                    style: const TextStyle(color: Color(0xFF1B97F3),),
                    recognizer: TapGestureRecognizer()..onTap =  () async{
                      var url =  Uri.parse(aiController.productsList[i][0].link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                ),
                TextSpan(
                  text: "\n- Product Price: ${aiController.productsList[i][0].currentPrice}\n\nProduct 2\n\n- Product Name: ${aiController.productsList[i][1].name}\n- Product URL: ",
    style: TextStyle(color: AppTheme.lightThemeData.colorScheme.tertiary,),
                ),
                TextSpan(
                    text: "Click here",
                    style: const TextStyle(color: Color(0xFF1B97F3),),
                    recognizer: TapGestureRecognizer()..onTap =  () async{
                      var url =  Uri.parse(aiController.productsList[i][1].link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                ),
                TextSpan(text: "\n- Product Price: ${aiController.productsList[i][1].currentPrice}\n\nProduct 3\n\n- Product Name: ${aiController.productsList[i][2].name}\n- Product URL: ",style: TextStyle(color: AppTheme.lightThemeData.colorScheme.tertiary,),),
                TextSpan(
                    text: "Click here",
                    style: const TextStyle(color: Color(0xFF1B97F3),),
                    recognizer: TapGestureRecognizer()..onTap =  () async{
                      var url =  Uri.parse(aiController.productsList[i][2].link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                ),
                TextSpan(text: "\n- Product Price: ${aiController.productsList[i][2].currentPrice}\n\n", style: TextStyle(color: AppTheme.lightThemeData.colorScheme.tertiary,),)
              ]
          );
      output.add(t);
      output1+=t1;
    }
    aiController.richText.value = RichText(text: TextSpan(children: output),);
    var temp = ChatModel(
        humanMessage: "Search",
        aiMessage: output1.trimRight(),
        timeStamp: DateTime.now().millisecondsSinceEpoch);
    aiController.chatHistory.add(temp);
    // print();
    // print(AiController.productsList.length);
  }
}
