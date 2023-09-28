class ChatModel{
  String humanMessage;
  String aiMessage;
  int timeStamp;

  ChatModel(
      {required this.humanMessage,
        required this.aiMessage,
        required this.timeStamp,});

  static Map<String, dynamic> fromObjtoMap(ChatModel article) {
    Map<String, dynamic> data = {
      "humanMessage": article.humanMessage,
      "aiMessage": article.aiMessage,
      "timeStamp": article.timeStamp,
    };
    return data;
  }

  static ChatModel fromMaptoObj(Map<String, dynamic> data) {
    ChatModel obj = ChatModel(
        humanMessage: data["humanMessage"],
        aiMessage: data["aiMessage"],
        timeStamp: data["timeStamp"],
    );
    return obj;
  }
}
