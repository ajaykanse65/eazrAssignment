import 'package:eazr_assignment/common/bottom_app_bar.dart';
import 'package:eazr_assignment/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleScreen extends StatefulWidget {
  final String author;

  const ArticleScreen({super.key, required this.author});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteAuthors = prefs.getStringList('favorite_authors') ?? [];
    setState(() {
      // print(favoriteAuthors);
      _isFavorite = favoriteAuthors.contains(widget.author);
      // print(_isFavorite);
    });
  }


  Future<void> _toggleFavorite() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final favoriteAuthors = prefs.getStringList('favorite_authors') ?? [];

      if (_isFavorite) {
        favoriteAuthors.remove(widget.author);
      } else {
        favoriteAuthors.add(widget.author);
      }

      print(favoriteAuthors);
      await prefs.setStringList('favorite_authors', favoriteAuthors);

      setState(() {
        _isFavorite = !_isFavorite;
      });
    }catch(e){

    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);


    final article = newsProvider.articles.firstWhere(
          (article) => article.author == widget.author,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Article by ${widget.author}'),
      ),
      bottomNavigationBar: BottomBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 222,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      article.urlToImage ?? ''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    article.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                    size: 30,
                    color: _isFavorite ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${article.publishedAt.day}-${article.publishedAt.month}-${article.publishedAt.year}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 16),
            Text(
              article.description ?? 'No description available.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              article.content ?? 'No content available.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}