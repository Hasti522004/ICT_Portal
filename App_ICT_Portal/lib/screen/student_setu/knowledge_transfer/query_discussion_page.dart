import 'package:flutter/material.dart';
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';


class QueryDiscussionPage extends StatelessWidget {
  const QueryDiscussionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Query Discussion'),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Asked Queries',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildQueryCard('User A', 'How to solve a particular problem?'),
            _buildQueryCard('User B', 'Any tips for effective studying?'),
            SizedBox(height: 16),
            Text(
              'Replied Queries',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildRepliedQueryCard('Expert X', 'You can try the following...'),
            _buildRepliedQueryCard(
                'Expert Y', 'Here is a step-by-step guide...'),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryCard(String username, String query) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('$username asked:'),
        subtitle: Text(query),
      ),
    );
  }

  Widget _buildRepliedQueryCard(String expertName, String reply) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('$expertName replied:'),
        subtitle: Text(reply),
      ),
    );
  }
}
