import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/chat_page.dart';

class CourseDiscussionPage extends StatefulWidget {
  const CourseDiscussionPage({Key? key}) : super(key: key);

  @override
  State<CourseDiscussionPage> createState() => _CourseDiscussionPageState();
}

class _CourseDiscussionPageState extends State<CourseDiscussionPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> askedConversations = [];
  List<Map<String, dynamic>> acceptedConversations = [];

  late TabController _tabController;
  final enrollmentNumber = '92100133052';
  Map<String, String> studentMap =
      {}; // Map to store student data (enrollment number -> name)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchStudentDataAndBuildConversations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch student data and build conversation lists
  Future<void> fetchStudentDataAndBuildConversations() async {
    try {
      // Fetch student data
      final studentResponse = await http.get(Uri.parse(
          'https://www.ictmu.in/ict_portal/api/student.php?key=student@ict'));
      if (studentResponse.statusCode == 200) {
        final List<dynamic> students = json.decode(studentResponse.body);
        // Populate student map
        studentMap = Map.fromIterable(students,
            key: (student) => student['enroll'],
            value: (student) =>
                '${student['fn']} ${student['mn']} ${student['ln']}');
      } else {
        throw Exception('Failed to fetch student data');
      }

      // Fetch conversation data
      final conversationResponse = await http.get(Uri.parse(
          'https://www.ictmu.in/ict_portal/api/setu-course.php?key=setu-course@ict'));
      if (conversationResponse.statusCode == 200) {
        final List<dynamic> decodedData =
            json.decode(conversationResponse.body);
        // Build conversation lists
        decodedData.forEach((conversation) {
          if (conversation['rec_id'] == enrollmentNumber) {
            acceptedConversations.add(conversation);
          } else if (conversation['creater'] == enrollmentNumber) {
            askedConversations.add(conversation);
          }
        });
        setState(() {});
      } else {
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    print(studentMap);
  }

  // Fetch student name from the student map
  String getStudentName(String enrollmentNumber) {
    return studentMap[enrollmentNumber] ?? enrollmentNumber;
  }

  // Build conversation list widgets
  Widget buildConversationList(List<Map<String, dynamic>> conversations) {
    return conversations.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No course discussions found.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final String genId = conversation['creater'];
              final String recId = conversation['rec_id'];

              // Determine which user's name to display based on the conversation type
              final String userName = conversation['rec_id'] == enrollmentNumber
                  ? conversation['creater'] // For Course Asked
                  : conversation['rec_id']; // For Course Accepted

              // Determine which subject to display based on the role
              final String subject = conversation['subject'];

              // Determine which course to display based on the role
              final String course = conversation['course'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      subject,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Course: $course',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'By: ${getStudentName(userName)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            genId: genId,
                            recId: recId,
                            uname: getStudentName(userName),
                            type: 'Course', // Fetch student name
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Course"),
      drawer: SideMenu(),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildConversationList(askedConversations),
          buildConversationList(acceptedConversations),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: 8.0), // Adjust padding as needed
              child: Text(
                'Course Asked',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: 8.0), // Adjust padding as needed
              child: Text(
                'Course Accepted',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
