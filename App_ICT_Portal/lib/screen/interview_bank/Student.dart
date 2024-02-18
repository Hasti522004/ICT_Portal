class Student {
  int id;
  String studentName;
  String enrollment;
  String companyName;
  String package;
  String date;
  String interviewExperience;

  Student({
    required this.id,
    required this.studentName,
    required this.enrollment,
    required this.companyName,
    required this.package,
    required this.date,
    required this.interviewExperience,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: int.parse(json['id']),
      studentName: json['studentName'],
      enrollment: json['enrollment'],
      companyName: json['companyName'],
      package: json['package'],
      date: json['date'],
      interviewExperience: json['interviewExperience'] ??
          '', // Assign an empty string if interviewExperience is null
    );
  }
}
