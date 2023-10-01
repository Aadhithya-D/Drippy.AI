import 'package:fashion_ai/models/chat_model.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:get/get.dart';

import '../controllers/ai_controller.dart';

// Replace with your actual OpenAI API key
const openaiApiKey = "";

class ChatService {
  final AiController aiController = Get.put(AiController());

  Future<ChatModel> chat(String humanInput) async {
    final llm = ChatOpenAI(
        temperature: 0, apiKey: openaiApiKey, model: 'gpt-3.5-turbo');

    // Define the system template with comments for better readability
    const systemTemplate =
        "You are Drippy AI\n"
        "You are a helpful assistant that recommends users outfits based upon their personalised fashion needs, gender, age, location, and occasion. IF THE USER ASKS ANYTHING ELSE DENY THEM\n"
        "Ask open-ended questions to determine the user's gender, age, location. Listen carefully to the response and take notes.\n"
        "Do not Include Purchase Links AND Price\n"
        "GENERATE AN OUTFIT ONLY AFTER COLLECTING AGE GENDER AND LOCATION, ONCE COMPLETED RETURN THE OUTFIT\n"
        "AND SPECIFY FOR WHOM THE USER'S AGE, GENDER, AND LOCATION\n"
        "Do not give multiple options to the user. Do not include the word 'or' or any equivalent to it.";

    final systemMessagePrompt =
        SystemChatMessagePromptTemplate.fromTemplate(systemTemplate);

    // Define the human template
    const humanTemplate = "{text}";
    final humanMessagePrompt =
        HumanChatMessagePromptTemplate.fromTemplate(humanTemplate);

    // Create the chat prompt
    final chatPrompt = ChatPromptTemplate.fromPromptMessages(
        [systemMessagePrompt, humanMessagePrompt]);
    final formattedPrompt =
        chatPrompt.formatPrompt({'text': humanInput}).toChatMessages();

    ChatModel newChat = ChatModel(
        humanMessage: humanInput,
        aiMessage: "Loading",
        timeStamp: DateTime.now().millisecondsSinceEpoch);

    final conversation = ConversationChain(
      llm: llm,
      memory: AiController.memory,
    );

    final aiMsg = await conversation.run(formattedPrompt).then((value) {
      String start
