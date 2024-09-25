import 'package:dio/dio.dart';
import 'package:movie_tmdb/models/recommendations_model.dart';
import 'package:movie_tmdb/utils/tmdb_api_key.dart';
import 'package:movie_tmdb/utils/api_constant.dart';

class RecommendationService {
  final Dio _dio = Dio();

  Future<RecommendationsModel> getRecommendations({required int idMovie}) async {
    try {
      final response = await _dio.get(
        '${ApiConstant.recommendations}$idMovie/recommendations?api_key=$tmdbAPiKey',
      );

      if (response.statusCode == 200) {
        return RecommendationsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load data');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
