import 'package:flutter/foundation.dart';
import 'package:movie_tmdb/models/detail_movie_model.dart';
import 'package:movie_tmdb/models/recommendations_model.dart';
import 'package:movie_tmdb/services/detail_movie_service.dart';
import 'package:movie_tmdb/services/recommendations_sevice.dart';

class DetailMovieViewModel extends ChangeNotifier {
  final DetailMovieService _detailMovieService = DetailMovieService();
  final RecommendationService _recommendationService = RecommendationService();

  DetailsMovieModel? detailsMovieData;
  RecommendationsModel? recommendationsData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchDetailMovie(int idMovie) async {
    isLoading = true;
    notifyListeners();

    try {
      detailsMovieData =
          await _detailMovieService.getDetailMovie(idMovie: idMovie);
      recommendationsData =
          await _recommendationService.getRecommendations(idMovie: idMovie);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      detailsMovieData = null;
      recommendationsData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String formattedRating(double rating) {
    return rating.toStringAsFixed(1);
  }
}
