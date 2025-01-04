import 'package:eazr_assignment/common/bottom_app_bar.dart';
import 'package:eazr_assignment/providers/news_provider.dart';
import 'package:eazr_assignment/screens/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedArticle extends StatefulWidget {
  const SavedArticle({super.key});

  @override
  State<SavedArticle> createState() => _SavedArticleState();
}

class _SavedArticleState extends State<SavedArticle> {
  List<String> favoriteAuthors = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteAuthorsList = prefs.getStringList('favorite_authors') ?? [];
    setState(() {
      favoriteAuthors = favoriteAuthorsList;
    });

  }


  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final filteredArticles = newsProvider.articles
        .where((article) => favoriteAuthors.contains(article.author))
        .toList();

    return Scaffold(
      bottomNavigationBar: BottomBar(),
      body: RefreshIndicator(
        onRefresh: _loadFavoriteStatus,
        child: newsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : newsProvider.error.isNotEmpty
                ? Center(child: Text(newsProvider.error))
                : CustomScrollView(
                    slivers: [
                      // Sliver for search bar and category title
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Your saved',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // SliverList for the article items
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final article = filteredArticles[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ArticleScreen(
                                              author: article.author,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                height: 222,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                article.urlToImage ?? ''),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.fromRGBO(0, 0, 0, 0.4),
                                              Color.fromRGBO(0, 0, 0, 0),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      right: 16,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.fromRGBO(0, 0, 0, 0.6),
                                              Color.fromRGBO(0, 0, 0, 0),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${article.publishedAt.day}-${article.publishedAt.month}-${article.publishedAt.year}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: filteredArticles.length,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
