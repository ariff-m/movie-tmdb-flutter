import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_tmdb/utils/api_constant.dart';
import 'package:movie_tmdb/view/widget/shimmer_loading.dart';
import 'package:movie_tmdb/view_model/detail_movie_view_model.dart';

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<DetailMovieViewModel>(context);

    return Consumer<DetailMovieViewModel>(
      builder: (context, viewModel, child) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            return true;
          },
          child: viewModel.isLoading && viewModel.recommendationsData == null
              ? const LoadingWidget()
              : viewModel.recommendationsData?.results == null ||
                      viewModel.recommendationsData!.results.isEmpty
                  ? const Center(child: Text('No recommendations available'))
                  : SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            viewModel.recommendationsData?.results.length ?? 0,
                        itemBuilder: (context, index) {
                          final movie =
                              viewModel.recommendationsData!.results[index];
                          final posterUrl =
                              '${ApiConstant.imageUrl}${movie.posterPath}';
                          final title = movie.title.length > 12
                              ? '${movie.title.substring(0, 12)}...'
                              : movie.title;

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detailPage',
                                arguments: movie.id,
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 7),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      posterUrl,
                                      height: 210,
                                      width: 140,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    title,
                                    style: GoogleFonts.poppins(
                                        textStyle:
                                            const TextStyle(fontSize: 15)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }
}
