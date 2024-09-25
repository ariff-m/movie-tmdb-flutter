import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:movie_tmdb/models/now_playing_model.dart';
import 'package:movie_tmdb/services/now_playing_service.dart';

class HomeViewModel extends ChangeNotifier {
  final NowPlayingService _nowPlayingService = NowPlayingService();
  NowPlayingModel? nowPlayingData;
  bool isLoading = false;
  String errorMessage = '';
  bool hasMoreData = true;
  int currentPage = 1;

  Future<void> fetchNowPlaying() async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    notifyListeners();

    const timeout = Duration(seconds: 10);

    Future<void> fetchData() async {
      if (kDebugMode) {
        print('Fetching now playing data for page $currentPage...');
      }

      try {
        final data = await _nowPlayingService.getNowPlaying(page: currentPage);
        if (data.results.isEmpty) {
          hasMoreData = false;
          if (kDebugMode) {
            print('No more data available.');
          }
        } else {
          if (kDebugMode) {
            print(
                'Fetched ${data.results.length} items from page $currentPage:');
          }
          for (var movie in data.results) {
            if (kDebugMode) {
              print(' - ${movie.title}');
            }
          }

          nowPlayingData = nowPlayingData == null
              ? data
              : NowPlayingModel(
                  results: [
                    ...(nowPlayingData?.results ?? []),
                    ...data.results
                  ],
                  dates: data.dates,
                  page: data.page,
                  totalPages: data.totalPages,
                  totalResults: data.totalResults,
                );
          currentPage++;
          if (kDebugMode) {
            print('Next page to fetch: $currentPage');
          }
        }
      } catch (e) {
        errorMessage = 'Failed to load data';
        if (kDebugMode) {
          print('Error fetching data: $e');
        }
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }

    try {
      await Future.any([
        fetchData(),
        Future.delayed(
          timeout,
          () => throw TimeoutException('Request timed out'),
        ),
      ]);
    } catch (e) {
      if (e is TimeoutException) {
        errorMessage =
            'It looks like your internet connection might be having issues. Please check your connection and try again.';
        notifyListeners();
      }
    }
  }
}
