import 'package:flutter/foundation.dart';
import 'package:movie_tmdb/models/popular_model.dart';
import 'package:movie_tmdb/services/popular_service.dart';

class PopularViewModel extends ChangeNotifier {
  final PopularService _popularService = PopularService();
  PopularModel? popularData;
  bool isLoading = false;
  String errorMessage = '';
  bool hasMoreData = true;
  int currentPage = 1;

  Future<void> fetchPopular() async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    notifyListeners();

    try {
      final data = await _popularService.getPopular(page: currentPage);

      if (data.results.isEmpty) {
        hasMoreData = false;
      } else {
        popularData = popularData == null
            ? data
            : PopularModel(
                results: [...(popularData?.results ?? []), ...data.results],
                dates: data.dates,
                page: data.page,
                totalPages: data.totalPages,
                totalResults: data.totalResults,
              );
        currentPage++;
      }
    } catch (e) {
      errorMessage = 'Failed to load data';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
