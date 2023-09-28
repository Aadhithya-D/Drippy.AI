import 'package:fashion_ai/models/chat_model.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:get/get.dart';

import '../controllers/ai_controller.dart';

const openaiApiKey = "";

class ChatService {
  final AiController aiController = Get.put(AiController());


  Future<ChatModel> chat(String humanInput) async {
    final llm = ChatOpenAI(
        temperature: 0, apiKey: openaiApiKey, model: 'gpt-3.5-turbo');
    const systemTemplate =
        "You are Drippy AI"
        "You are a helpful assistant that recommends users outfits based upon their personalised fashion needs,gender,age,location and occasion.IF THE USER ASKS ANYTHING ELSE DENY THEM "
        "Ask open ended questions to determine the users gender,age,location. Listen carefully to the response and take notes."
        "Do not Include Purchase Links AND Price "
        "GENERATE AN OUTFIT ONLY AFTER COLLECTING AGE GENDER AND LOCATION ,ONCE COMPLETED RETURN THE OUTFIT "
        "AND SPECIFY FOR WHOM THE USER'S AGE, GENDER AND LOCATION "
        "Do not give multiple options to the user. Do not include the word 'or' or any equivalent to it.";
    final systemMessagePrompt =
        SystemChatMessagePromptTemplate.fromTemplate(systemTemplate);
    const humanTemplate = "{text}";
    final humanMessagePrompt =
        HumanChatMessagePromptTemplate.fromTemplate(humanTemplate);
    final chatPrompt = ChatPromptTemplate.fromPromptMessages(
        [systemMessagePrompt, humanMessagePrompt]);
    final formattedPrompt =
        chatPrompt.formatPrompt({'text': humanInput}).toChatMessages();
    ChatModel newChat = ChatModel(humanMessage: humanInput, aiMessage: "Loading", timeStamp: DateTime.now().millisecondsSinceEpoch);
    final conversation = ConversationChain(
      llm: llm,
      memory: AiController.memory,
    );
    final aiMsg = await conversation.run(formattedPrompt).then((value) {
      String startTag = "content: "; // 26
      String endTag = ",\n";

      int startIndex = value.indexOf(startTag) + startTag.length;
      int endIndex = value.indexOf(endTag);

      String extractedContent = value.substring(startIndex, endIndex).trim();
      // print(extractedContent);
      newChat = ChatModel(
          humanMessage: humanInput,
          aiMessage: extractedContent,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
    });
    return newChat;
  }


  Future<ChatModel> summary(String aiMessage) async {
    final llm = ChatOpenAI(
        temperature: 0, apiKey: openaiApiKey, model: 'gpt-3.5-turbo');
    const systemTemplate = "You are an expert at forming a list of INDIVIDUAL CLOTHING ITEMS AND ACCESSORIES";
    final systemMessagePrompt = SystemChatMessagePromptTemplate.fromTemplate(systemTemplate);
    const humanTemplate =    """FORM A LIST OF INDIVIDUAL CLOTHING ITEMS AND ACCESSORIES FOR THE GIVEN INPUT
    ====EXAMPLES====
    Input: Sure! I can help you with that. Here's a black dress outfit recommendation for you:\n\nOutfit:\n- A\nblack fit and flare dress with a sweetheart neckline and lace detailing.\n- Pair it with a black\nleather jacket for a stylish and edgy look.\n- Complete the outfit with a pair of black ankle boots\nand accessorize with a silver pendant necklace.\n\nFor a 20-year-old from Bihar, this outfit would be\nsuitable for various occasions such as parties, dinners, or even a night out with friends. It offers\na trendy and chic look while still being comfortable to wear.\n\nPlease note that the availability of\nspecific items may vary depending on your location and the current fashion trends.
    Output: ['Black fit and flare dress with a\nsweetheart neckline and lace detailing','Black Leather jacket','Black ankle boots','silver pendant necklace'

    Input:For a temple visit in Chennai, I recommend a traditional and respectful outfit. Here's an outfit\nsuggestion for you:\n\n- A crisp white cotton shirt: Opt for a comfortable and breathable cotton shirt\nto beat the heat in Chennai.\n- A pair of beige or cream-colored linen trousers: Linen trousers are\nlightweight and perfect for the warm weather in Chennai.\n- A traditional dhoti: As a traditional\ntouch, you can wear a dhoti, which is a garment commonly worn by men in South India for religious\noccasions.\n- Sandals or mojari shoes: Complete your outfit with a pair of comfortable sandals or\nmojari shoes, which are traditional Indian footwear.\n\nRemember to dress modestly and avoid wearing\nshorts or sleeveless shirts when visitin
    Output:['white cotton shirt','beige linen trousers','cream-colored linen trousers','dhoti','Sandals','mojari shoes']

    =====END OF EXAMPLES====

    {ai_response}""";

    final humanMessagePrompt = HumanChatMessagePromptTemplate.fromTemplate(humanTemplate);

    final sumPrompt = ChatPromptTemplate.fromPromptMessages(
        [systemMessagePrompt, humanMessagePrompt]);

    final formattedPrompt = sumPrompt.formatPrompt({'ai_response': aiMessage}).toChatMessages();

    final conversation = await llm(formattedPrompt);

    ChatModel newChat = ChatModel(humanMessage: "Search", aiMessage: conversation.content, timeStamp: DateTime.now().millisecondsSinceEpoch);
    return newChat;
  }
}

final systemMessagePrompt2 = SystemChatMessagePromptTemplate.fromTemplate(
    "You are an expert at summarising clothing information by describing and highlighting the clothing's colour, type of clothing and size.");
const humanTemplate2 =
    """SUMMARISE THIS BY HIGHLIGHTING THE OUTFIT'S FEATURES AND FORMING A LIST
    ====EXAMPLES====
    Input 1: Sure! I can help you with that. Here's a black dress outfit recommendation for you:\n\nOutfit:\n- A\nblack fit and flare dress with a sweetheart neckline and lace detailing.\n- Pair it with a black\nleather jacket for a stylish and edgy look.\n- Complete the outfit with a pair of black ankle boots\nand accessorize with a silver pendant necklace.\n\nFor a 20-year-old from Bihar, this outfit would be\nsuitable for various occasions such as parties, dinners, or even a night out with friends. It offers\na trendy and chic look while still being comfortable to wear.\n\nPlease note that the availability of\nspecific items may vary depending on your location and the current fashion trends.
    Output 1: ['Black fit and flare dress with a\nsweetheart neckline and lace detailing','Black Leather jacket','Black ankle boots','silver pendant necklace'

    Input 2:For a temple visit in Chennai, I recommend a traditional and respectful outfit. Here's an outfit\nsuggestion for you:\n\n- A crisp white cotton shirt: Opt for a comfortable and breathable cotton shirt\nto beat the heat in Chennai.\n- A pair of beige or cream-colored linen trousers: Linen trousers are\nlightweight and perfect for the warm weather in Chennai.\n- A traditional dhoti: As a traditional\ntouch, you can wear a dhoti, which is a garment commonly worn by men in South India for religious\noccasions.\n- Sandals or mojari shoes: Complete your outfit with a pair of comfortable sandals or\nmojari shoes, which are traditional Indian footwear.\n\nRemember to dress modestly and avoid wearing\nshorts or sleeveless shirts when visitin
    Output 2:['white cotton shirt','beige linen trousers','cream-colored linen trousers','dhoti','Sandals','mojari shoes']

    =====END OF EXAMPLES====
    WHEN THE INPUT CONTAINS the word OR (example given above in Input 2) THEN SPLIT THE WORDS AND PUT IT AS DIFFERENT ELEMENTS (Example given in OUTPUT2)

    {ai_response}""";
