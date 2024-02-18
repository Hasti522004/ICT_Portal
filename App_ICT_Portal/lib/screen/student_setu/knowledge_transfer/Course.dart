class Course {
  final String heading;
  final String subject;
  final String description;

  Course({
    required this.heading,
    required this.subject,
    required this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      heading: json['heading'],
      subject: json['subject'],
      description: json['description'],
    );
  }

  // If needed, you can add more methods or properties to the Course class
}
