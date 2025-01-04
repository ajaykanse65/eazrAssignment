import 'package:eazr_assignment/screens/home_screen.dart';
import 'package:eazr_assignment/screens/saved_article.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
      shape: const CircularNotchedRectangle(),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            icon: const Icon(Icons.home_sharp, color: Colors.black),
          ),
           IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SavedArticle()));
            },
            icon: Icon(Icons.save_sharp, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
