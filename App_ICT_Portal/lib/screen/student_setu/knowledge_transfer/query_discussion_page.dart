import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/chat_page.dart';

class QueryDiscussionPage extends StatefulWidget {
  const QueryDiscussionPage({Key? key}) : super(key: key);

  @override
  State<QueryDiscussionPage> createState() => _QueryDiscussionPageState();
}

class _QueryDiscussionPageState extends State<QueryDiscussionPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> askedConversations = [];
  List<Map<String, dynamic>> acceptedConversations = [];

  late TabController _tabController;
  final enrollmentNumber = '92100133052';
  late String uname = '';
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
          'https://www.ictmu.in/ict_portal/api/setu-query.php?key=setu-query@ict'));
      if (conversationResponse.statusCode == 200) {
        final List<dynamic> decodedData =
            json.decode(conversationResponse.body);
        // Build conversation lists
        decodedData.forEach((conversation) {
          if (conversation['rec_id'] == enrollmentNumber) {
            acceptedConversations.add(conversation);
          } else if (conversation['gen_id'] == enrollmentNumber) {
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
    return studentMap[enrollmentNumber] ?? 'Unknown';
  }

  // Build conversation list widgets
  Widget buildConversationList(List<Map<String, dynamic>> conversations) {
    return conversations.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No Query discussions found.',
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
              final String genId = conversation['gen_id'];
              final String recId = conversation['rec_id'];

              // Determine which user's name to display based on the conversation type
              final String userName = conversation['rec_id'] == enrollmentNumber
                  ? conversation['gen_id'] // For Query Asked
                  : conversation['rec_id']; // For Query Accepted

              // Determine which subject to display based on the role
              final String subject = 'Subject: ${conversation['subject']}';

              // Determine which query to display based on the role
              final String query = 'Query: ${conversation['query']}';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        genId: genId,
                        recId: recId,
                        uname: getStudentName(userName), // Fetch student name
                        type: "Query",
                      ),
                    ),
                  );
                },
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
                          query,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'By: ${getStudentName(userName)}', // Display student name
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Query"),
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
                'Query Asked',
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
                'Query Accepted',
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
