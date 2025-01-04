import 'package:eazr_assignment/common/bottom_app_bar.dart';
import 'package:eazr_assignment/providers/news_provider.dart';
import 'package:eazr_assignment/screens/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.fetchArticles(widget.category);
    });
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
  }

  Future<void> _onRefresh() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if(_searchController.text.isEmpty){
      await newsProvider.fetchArticles(widget.category);
    }
    else{
      await newsProvider.searchArticles(_searchController.text);
    }

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
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: newsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : newsProvider.error.isNotEmpty
                    ? Center(child: Text(newsProvider.error))
                    : CustomScrollView(
                        slivers: [

                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SizedBox(
                                      height: 70,
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: 'Search...',
                                          hintStyle: TextStyle(color: Colors.grey[400]),
                                          border: InputBorder.none,
                                          prefixIcon: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(
                                                Icons.arrow_back,
                                                color: Colors.grey[400],
                                                size: 30,
                                              )),
                                          suffixIcon: IconButton(
                                            onPressed: (){
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
                                  Text(
                                    widget.category,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SliverList(
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
                                  .length,
                            ),
                          ),
                        ],
                      )));
  }
}
