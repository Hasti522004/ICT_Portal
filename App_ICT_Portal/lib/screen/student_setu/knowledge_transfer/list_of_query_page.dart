import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/Query.dart';

class ListOfQueryPage extends StatefulWidget {
  ListOfQueryPage({Key? key}) : super(key: key);

  @override
  _ListOfQueryPageState createState() => _ListOfQueryPageState();
}

class _ListOfQueryPageState extends State<ListOfQueryPage> {
  List<Query> submittedQueries = [];

  @override
  void initState() {
    super.initState();
    fetchQueries();
  }

  Future<void> fetchQueries() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.30.48.1/ICT/API_ICT_Portal/fetch_queries.php')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          submittedQueries =
              data.map((queryData) => Query.fromJson(queryData)).toList();
        });
      } else {
        throw Exception('Failed to fetch queries');
      }
    } catch (e) {
      print('Error fetching queries: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch queries. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'List of Queries'),
      drawer: SideMenu(),
      body: ListView.builder(
        itemCount: submittedQueries.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Query Heading: ${submittedQueries[index].heading}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject: ${submittedQueries[index].subject}'),
                  Text(
                      'Brief Description: ${submittedQueries[index].description}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
