class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;
  final String category;
  final String author;

  NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.category,
    required this.author,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      source: json['source'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      category: json['category'] ?? '',
      author: json['author'] ?? '',
    );
  }
}
