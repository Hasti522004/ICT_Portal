import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final String text;

  MarqueeWidget({required this.text});

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollText();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollText() {
    Future.delayed(Duration(seconds: 1), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 5),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: [
          SizedBox(width: 16.0), // Add padding to start
          Text(
            widget.text,
            style: TextStyle(fontSize: 18.0), // Adjust font size as needed
          ),
          SizedBox(width: 16.0), // Add padding to end
        ],
      ),
    );
  }
}
