import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_tmdb/utils/api_constant.dart';
import 'package:movie_tmdb/view/widget/shimmer_loading.dart';
import 'package:movie_tmdb/view_model/popular_view_model.dart';

class PopularWidget extends StatelessWidget {
  const PopularWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PopularViewModel>(context);

    if (viewModel.popularData == null && !viewModel.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.fetchPopular();
      });
    }

    return Consumer<PopularViewModel>(
      builder: (context, viewModel, child) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!viewModel.isLoading &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 50) {
              if (viewModel.hasMoreData) {
                if (kDebugMode) {
                  print('User reached bottom, fetching more data...');
                }
                viewModel.fetchPopular();
              }
            }
            return true;
          },
          child: viewModel.isLoading && viewModel.popularData == null
              ? const LoadingWidget()
              : viewModel.popularData?.results == null ||
                      viewModel.popularData!.results.isEmpty
                  ? const Center(child: Text('No data available'))
                  : SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            viewModel.popularData?.results.length ?? 0,
                        itemBuilder: (context, index) {
                          final movie =
                              viewModel.popularData!.results[index];
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
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
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
