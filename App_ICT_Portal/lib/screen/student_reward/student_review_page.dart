import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/user/user_provider.dart';
import 'package:provider/provider.dart';

class StudentReviewPage extends StatefulWidget {
  const StudentReviewPage({Key? key}) : super(key: key);

  @override
  _StudentReviewPageState createState() => _StudentReviewPageState();
}

class _StudentReviewPageState extends State<StudentReviewPage> {
  String studentName = '';
  String enrollment_number = '';

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    enrollment_number = user?.enrollment ?? '';
    fetchStudentName(enrollment_number).then((name) {
      setState(() {
        studentName = name;
      });
    }).catchError((error) {
      print('Error fetching student name: $error');
    });
  }

  Future<String> fetchStudentName(String enrollmentNumber) async {
    final response = await http.get(Uri.parse(
        'https://www.ictmu.in/ict_portal/api/student.php?key=student@ict'));

    if (response.statusCode == 200) {
      final List<dynamic> students = json.decode(response.body);
      final student = students.firstWhere(
        (student) => student['enroll'] == enrollmentNumber,
        orElse: () => null,
      );
      if (student != null) {
        return '${student['fn']} ${student['mn']} ${student['ln']}';
      } else {
        throw Exception('Student not found');
      }
    } else {
      throw Exception('Failed to load student data');
    }
  }

  Future<List<dynamic>> fetchReviews() async {
    final response = await http.get(Uri.parse(
        'http://192.168.137.1/ICT/API_ICT_Portal/fetch_student_reward.php?enrollment_number=$enrollment_number'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Student Reviews'),
      drawer: SideMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              studentName.isNotEmpty
                  ? 'Student Reviews - $studentName'
                  : 'Student Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchReviews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<dynamic> reviews = snapshot.data!;
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (BuildContext context, int index) {
                      final review = reviews[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${review['timestamp']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Professor ID: ${review['professor_id']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Review:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (review['deep_understanding'] != null)
                                    Text(
                                        'Deep Understanding: ${review['deep_understanding']}'),
                                  if (review['problem_solving'] != null)
                                    Text(
                                        'Problem Solving: ${review['problem_solving']}'),
                                  if (review['research_skills'] != null)
                                    Text(
                                        'Research Skills: ${review['research_skills']}'),
                                  if (review['analytical_skills'] != null)
                                    Text(
                                        'Analytical Skills: ${review['analytical_skills']}'),
                                  if (review['critical_thinking'] != null)
                                    Text(
                                        'Critical Thinking: ${review['critical_thinking']}'),
                                  if (review['solution_proposals'] != null)
                                    Text(
                                        'Solution Proposals: ${review['solution_proposals']}'),
                                  if (review['research_methodology'] != null)
                                    Text(
                                        'Research Methodology: ${review['research_methodology']}'),
                                  if (review['data_analysis'] != null)
                                    Text(
                                        'Data Analysis: ${review['data_analysis']}'),
                                  if (review['conclusions'] != null)
                                    Text(
                                        'Conclusions: ${review['conclusions']}'),
                                  if (review['creativity'] != null)
                                    Text('Creativity: ${review['creativity']}'),
                                  if (review['innovative_solutions'] != null)
                                    Text(
                                        'Innovative Solutions: ${review['innovative_solutions']}'),
                                  if (review['technical_competence'] != null)
                                    Text(
                                        'Technical Competence: ${review['technical_competence']}'),
                                  if (review['tool_proficiency'] != null)
                                    Text(
                                        'Tool Proficiency: ${review['tool_proficiency']}'),
                                  if (review['software_skills'] != null)
                                    Text(
                                        'Software Skills: ${review['software_skills']}'),
                                  if (review['hardware_skills'] != null)
                                    Text(
                                        'Hardware Skills: ${review['hardware_skills']}'),
                                  if (review['collaboration'] != null)
                                    Text(
                                        'Collaboration: ${review['collaboration']}'),
                                  if (review['communication'] != null)
                                    Text(
                                        'Communication: ${review['communication']}'),
                                  if (review['responsibility'] != null)
                                    Text(
                                        'Responsibility: ${review['responsibility']}'),
                                  if (review['clarity'] != null)
                                    Text('Clarity: ${review['clarity']}'),
                                  if (review['presentation'] != null)
                                    Text(
                                        'Presentation: ${review['presentation']}'),
                                  if (review['listening_skills'] != null)
                                    Text(
                                        'Listening Skills: ${review['listening_skills']}'),
                                  if (review['punctuality'] != null)
                                    Text(
                                        'Punctuality: ${review['punctuality']}'),
                                  if (review['ethics'] != null)
                                    Text('Ethics: ${review['ethics']}'),
                                  if (review['attitude'] != null)
                                    Text('Attitude: ${review['attitude']}'),
                                  if (review['social_awareness'] != null)
                                    Text(
                                        'Social Awareness: ${review['social_awareness']}'),
                                  if (review['environmental_consciousness'] !=
                                      null)
                                    Text(
                                        'Environmental Consciousness: ${review['environmental_consciousness']}'),
                                  if (review['community_engagement'] != null)
                                    Text(
                                        'Community Engagement: ${review['community_engagement']}'),
                                  if (review['financial_literacy'] != null)
                                    Text(
                                        'Financial Literacy: ${review['financial_literacy']}'),
                                  if (review['resource_management'] != null)
                                    Text(
                                        'Resource Management: ${review['resource_management']}'),
                                  if (review['cost_effectiveness'] != null)
                                    Text(
                                        'Cost Effectiveness: ${review['cost_effectiveness']}'),
                                  if (review['fairness'] != null)
                                    Text('Fairness: ${review['fairness']}'),
                                  if (review['equality'] != null)
                                    Text('Equality: ${review['equality']}'),
                                  if (review['integrity'] != null)
                                    Text('Integrity: ${review['integrity']}'),
                                  if (review['curiosity'] != null)
                                    Text('Curiosity: ${review['curiosity']}'),
                                  if (review['adaptability'] != null)
                                    Text(
                                        'Adaptability: ${review['adaptability']}'),
                                  if (review['continuous_improvement'] != null)
                                    Text(
                                        'Continuous Improvement: ${review['continuous_improvement']}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
