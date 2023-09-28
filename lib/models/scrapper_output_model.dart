class ScrapperOutputModel {
  String name;
  String link;
  int currentPrice;
  int originalPrice;
  bool discounted;
  String thumbnail;
  String queryUrl;

  ScrapperOutputModel({
    required this.name,
    required this.link,
    required this.currentPrice,
    required this.originalPrice,
    required this.discounted,
    required this.thumbnail,
    required this.queryUrl,
  });

}
