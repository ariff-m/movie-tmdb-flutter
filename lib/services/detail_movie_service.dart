import 'package:dio/dio.dart';
import 'package:movie_tmdb/models/detail_movie_model.dart';
import 'package:movie_tmdb/utils/tmdb_api_key.dart';
import 'package:movie_tmdb/utils/api_constant.dart';

class DetailMovieService {
  final Dio _dio = Dio();

  Future<DetailsMovieModel> getDetailMovie({required int idMovie}) async {
    try {
      final response = await _dio.get(
        '${ApiConstant.details}$idMovie?api_key=$tmdbAPiKey',
      );

      if (response.statusCode == 200) {
        return DetailsMovieModel.fromJson(response.data);
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
