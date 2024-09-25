import 'package:dio/dio.dart';
import 'package:movie_tmdb/utils/tmdb_api_key.dart';
import 'package:movie_tmdb/models/now_playing_model.dart';
import 'package:movie_tmdb/utils/api_constant.dart';

class NowPlayingService {
  final Dio _dio = Dio();

  Future<NowPlayingModel> getNowPlaying({required int page}) async {
    try {
      final response = await _dio.get(
        '${ApiConstant.nowPlaying}?api_key=$tmdbAPiKey&page=$page',
      );

      if (response.statusCode == 200) {
        return NowPlayingModel.fromJson(response.data);
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
