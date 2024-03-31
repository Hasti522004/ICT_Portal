import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final String genId;
  final String recId;
  final String uname;
  final String type;
  const ChatPage(
      {Key? key, required this.genId, required this.recId, required this.uname,required this.type})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> chatMessages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChatMessages();
  }

  Future<void> fetchChatMessages() async {
    final apiUrl =
        'https://www.ictmu.in/ict_portal/api/setu-chat.php?key=setu-chat@ict';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        // Cast the decoded data to the correct type
        chatMessages = List<Map<String, dynamic>>.from(decodedData)
            .where((message) =>
                message['sender'] == widget.genId ||
                message['sender'] == widget.recId)
            .toList();
      });
    } else {
      print('Failed to fetch chat messages: ${response.statusCode}');
    }
    print(chatMessages);
  }

  Future<void> sendMessage(String message) async {
    // Implement sending message logic here
    // You can use your API endpoint to send messages
    // For demonstration purpose, let's print the message to console
    print('Message sent: $message');

    // Create a new message map to represent the sent message
    Map<String, dynamic> sentMessage = {
      'sender': widget.genId,
      'msg': message,
      'stamp': DateTime.now().toString(),
    };

    // Add the sent message to the chatMessages list
    setState(() {
      chatMessages.add(sentMessage);
    });

    // Clear the text input field after sending the message
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Implement chat UI here using genId and recId

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.uname),
        backgroundColor: Color(0xFF00A6BE),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatMessages.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatMessages[index];
                      final String sender = message['sender'];
                      final String msg = message['msg'];
                      final String stamp = message['stamp'];
                      final DateTime timeStamp = DateTime.parse(stamp);

                      // Check if the message sender is the current user or the other user
                      final bool isCurrentUser = sender == widget.genId;

                      return Column(
                        children: [
                          // Display date above the center
                          if (index == 0 ||
                              timeStamp.day !=
                                  DateTime.parse(
                                          chatMessages[index - 1]['stamp'])
                                      .day)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '${timeStamp.day}/${timeStamp.month}/${timeStamp.year}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: isCurrentUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              // Display messages on the right side for the current user and left side for the other user
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      isCurrentUser ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      msg,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${timeStamp.hour}:${timeStamp.minute}',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      sendMessage(messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
