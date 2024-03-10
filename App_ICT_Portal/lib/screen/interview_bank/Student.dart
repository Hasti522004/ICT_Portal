class Student {
  final String id;
  final String enr;
  final String title;
  final String clink;
  final String date;
  final String category;
  final String pack;
  final String disc;
  final String img;
  final String audio;

  Student({
    required this.id,
    required this.enr,
    required this.title,
    required this.clink,
    required this.date,
    required this.category,
    required this.pack,
    required this.disc,
    required this.img,
    required this.audio,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      enr: json['enr'],
      title: json['title'],
      clink: json['clink'],
      date: json['date'],
      category: json['category'],
      pack: json['pack'],
      disc: json['disc'],
      img: json['img'],
      audio: json['audio'],
    );
  }
}
