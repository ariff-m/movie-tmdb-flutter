import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_tmdb/utils/api_constant.dart';
import 'package:movie_tmdb/view/widget/recommendations_widget.dart';
import 'package:movie_tmdb/view_model/detail_movie_view_model.dart';

class DetailsPage extends StatelessWidget {
  final int movieId;

  const DetailsPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailMovieViewModel()..fetchDetailMovie(movieId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Detail Movie',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<DetailMovieViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                  child: SizedBox(
                width: 75,
                height: 75,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  strokeWidth: 3,
                  colors: [Colors.blue],
                ),
              ));
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            }

            final movie = viewModel.detailsMovieData;

            if (movie == null) {
              return const Center(child: Text('No data available'));
            }

            final posterUrl = '${ApiConstant.imageUrl}${movie.posterPath}';

            final genreList = movie.genres.isNotEmpty
                ? movie.genres.map((genre) => genre.name).join(', ')
                : 'No genres available';

            return ListView(
              children: [
                Image.network(
                  posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Genre: $genreList',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duration: ${movie.runtime} minutes',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rating: ${viewModel.formattedRating(movie.voteAverage)}/10',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        movie.overview,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Recommendations',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const RecommendationsWidget(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
