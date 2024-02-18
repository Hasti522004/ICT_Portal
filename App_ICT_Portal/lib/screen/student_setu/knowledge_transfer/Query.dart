class Query {
  final String heading;
  final String subject;
  final String description;

  Query({
    required this.heading,
    required this.subject,
    required this.description,
  });

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      heading: json['heading'],
      subject: json['subject'],
      description: json['description'],
    );
  }
}
