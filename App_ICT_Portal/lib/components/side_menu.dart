import 'package:flutter/material.dart';
import 'package:ict_portal/screen/anonymous_feedback/Anonymous_feedback_page.dart';
import 'package:ict_portal/screen/anonymous_feedback/show_Feedback.dart';
import 'package:ict_portal/screen/auth/login_page.dart';
import 'package:ict_portal/screen/home_page.dart';
import 'package:ict_portal/screen/interview_bank/interviewbank_page.dart';
import 'package:ict_portal/screen/leave/leave_history_page.dart';
import 'package:ict_portal/screen/leave/take_leave_page.dart';
import 'package:ict_portal/screen/student_reward/student_review_page.dart';
import 'package:ict_portal/screen/student_reward/student_reward_input_page.dart';
import 'package:ict_portal/screen/student_setu/book_exchange/chat_history_page.dart';
import 'package:ict_portal/screen/student_setu/book_exchange/give_book_page.dart';
import 'package:ict_portal/screen/student_setu/book_exchange/view_book_page.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/course_discusion_page.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/course_generation_page.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/enroll_course_page.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/list_of_query_page.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/query_discussion_page.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/query_generation_page.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF00A6BE),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.comment_bank),
            title: Text('Interview Bank'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InterviewBankPage()),
              );
            },
          ),
          ExpansionTile(
              leading: Icon(Icons.leave_bags_at_home),
              title: Text('Leave'),
              children: [
                ListTile(
                  title: Text('Leave Application'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeavePage()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Leave History'),
                  onTap: () {
                    // Handle List of Query action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveHistoryPage(),
                      ),
                    );
                  },
                ),
              ]),
          ExpansionTile(
            leading: Icon(Icons.school), // Icon for Student Setu
            title: Text('Student Setu'),
            children: [
              // Sub-menu for Knowledge Transfer
              ExpansionTile(
                leading: Icon(Icons.info),
                title: Text('Knowledge Transfer'),
                children: [
                  ListTile(
                    title: Text('Query Generation'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QueryGenerationPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('List of Query'),
                    onTap: () {
                      // Handle List of Query action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QueryListPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Query Discussion'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QueryDiscussionPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Course Generation'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseGenerationPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Enroll Course'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseListPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Course Discussion'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDiscussionPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.book),
                title: Text('Book Setu Sub-menu'),
                children: [
                  ListTile(
                    title: Text('Give Book'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiveBookPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('View Book'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewBookPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Chat History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Anonymous Feedback'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackForm()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Fetch Anonymous Feedback'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnonymousFeedbackPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.reviews),
            title: Text('Give Reviews'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentInfoPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.reviews_rounded),
            title: Text('Show Reviews'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentReviewPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
