class Book {
  final String name;
  final String author;
  final String sellType;
  final String priceRent;
  final String imagePath;
  final String enrollment;

  Book({
    required this.name,
    required this.author,
    required this.sellType,
    required this.priceRent,
    required this.imagePath,
    required this.enrollment,
  });

  factory Book.fromJson(Map<String, dynamic> json, String imagePath) {
    return Book(
      name: json['bookname'],
      author: json['bookauthor'],
      sellType: json['selltype'],
      priceRent: json['price'],
      imagePath: imagePath,
      enrollment: json['enrollment'],
    );
  }
}
