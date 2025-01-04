import 'package:eazr_assignment/common/bottom_app_bar.dart';
import 'package:eazr_assignment/providers/news_provider.dart';
import 'package:eazr_assignment/screens/article_screen.dart';
import 'package:eazr_assignment/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['Top Headlines', 'General', 'Technology', 'Entertainment', 'Business', 'Health', 'Science', 'Sports'];
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final List<String> categoryImages = [
    'https://cdn.usegalileo.ai/sdxl10/21d9d91d-a379-449b-b15c-4e545d0290fc.png',
    'https://cdn.usegalileo.ai/sdxl10/f75c6fcd-b568-4d14-9289-da2c413414a2.png',
    'https://cdn.usegalileo.ai/sdxl10/1a9d6740-90e3-4589-b5f8-3725968de602.png',
    'https://cdn.usegalileo.ai/sdxl10/2e9d712c-eea4-4234-9c43-df091d187a86.png',
    'https://cdn.usegalileo.ai/sdxl10/d4cd42a9-2739-458d-8306-de36653b6656.png',
    'https://cdn.usegalileo.ai/sdxl10/460244bb-f491-4fad-8ac6-8a58cdad90fa.png',
    'https://cdn.usegalileo.ai/sdxl10/c8091f50-a603-460d-8271-58e8bcbf6eea.png',
    'https://cdn.usegalileo.ai/sdxl10/1a99d87a-63ce-457b-9bcb-fc2884700d5d.png',
  ];

  @override
  void initState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
        });
      } else {
        setState(() {
          _isSearching = true;
        });
      }
    });
    super.initState();
  }

  Future<void> _searchArticles(String query) async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if (query.isNotEmpty) {
      await newsProvider.searchArticles(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomBar(),
      body:  CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20,),
                    child: SizedBox(
                      height: 70,
                      child: TextField(

                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            onPressed: ()  {
                              _searchArticles(_searchController.text);
                              
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                              size: 35,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ),
                  _isSearching
                  ?Text(
                    'Search result',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  :Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ],
              ),
            ),
          ),
          _isSearching
          ? SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final article = newsProvider.articles[index];

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
                                  overflow:
                                  TextOverflow.ellipsis,
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
                                    fontWeight:
                                    FontWeight.normal,
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
              childCount: newsProvider.articles
                  .length, // The number of items in the list
            ),
          )
          : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(category: categories[index]),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                                image: NetworkImage(categoryImages[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
