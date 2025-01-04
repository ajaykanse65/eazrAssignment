import 'package:dio/dio.dart';
import 'package:eazr_assignment/model/article_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsService {
  final String apikey = dotenv.env['API_KEY'] ?? '';
  final String baseUrl =  dotenv.env['BASE_URL'] ?? '';
  final String searchUrl = dotenv.env['SEARCH_BASE_URL'] ?? '';
  final Dio dio = Dio();

  Future<List<ArticleElement>> fetchArticles(String category) async {
    if (category == 'Top Headlines') {
      category = '';
    }
    try {

      final response = await dio.get(
        '$baseUrl?apiKey=$apikey&category=$category&country=us',
        options: Options(
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['articles'];

        final List<ArticleElement> articles = data
            .where((json) => json['content'] != null &&
            json['content'] != '[Removed]' &&
            json['title'] != '[Removed]' &&
            json['description'] != '[Removed]')
            .map((json) => ArticleElement.fromJson(json))
            .toList();

        return articles;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Failed to load articles');
    }
  }


  Future<List<ArticleElement>> searchArticles(String query) async {
    try {
      // Ensure query is not empty
      if (query.isEmpty) {
        throw Exception('Search query cannot be empty');
      }

      final response = await dio.get(
        '$searchUrl?q=$query&apiKey=$apikey',
        options: Options(
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['articles'];

        final List<ArticleElement> articles = data
            .where((json) =>
        json['content'] != null &&
            json['content'] != '[Removed]' &&
            json['title'] != '[Removed]' &&
            json['description'] != '[Removed]')
            .map((json) => ArticleElement.fromJson(json))
            .toList();

        return articles;
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Failed to load search results');
    }
  }

}



