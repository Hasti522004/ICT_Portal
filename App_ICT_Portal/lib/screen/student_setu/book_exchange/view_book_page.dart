import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/book_exchange/Book.dart';

class ViewBookPage extends StatefulWidget {
  @override
  _ViewBookPageState createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.ictmu.in/ict_portal/api/booksell.php?key=booksell@ict'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        books = responseData.map((data) {
          // Construct the image path using the base URL and the image name from the API
          String imageName = data['image'];
          String imagePath =
              'https://www.ictmu.in/ict_portal/document/booksimage/$imageName';
          return Book.fromJson(data, imagePath);
        }).toList();
        filteredBooks.addAll(books);
      });
    } else {
      // Handle error
    }
  }

  void _searchBooks(String query) {
    setState(() {
      filteredBooks.clear();
      filteredBooks.addAll(
        books.where(
          (book) => book.name.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'View Books'),
      drawer: SideMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchBooks,
              decoration: InputDecoration(
                labelText: 'Search by book name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        filteredBooks[index].imagePath,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book Name: ${filteredBooks[index].name}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Author: ${filteredBooks[index].author}'),
                            Text('Sell Type: ${filteredBooks[index].sellType}'),
                            Text(
                                'Price/Rent: ${filteredBooks[index].priceRent}'),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showContactDialog(),
                                  child: Text('Contact Seller'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showContactDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contact Seller"),
          content: Text("You can contact the seller via email or phone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
