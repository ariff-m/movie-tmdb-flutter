import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_tmdb/view/details_page.dart';
import 'package:movie_tmdb/view/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_tmdb/view_model/detail_movie_view_model.dart';
import 'package:movie_tmdb/view_model/home_view_model.dart';
import 'package:movie_tmdb/view_model/popular_view_model.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PopularViewModel()),
        ChangeNotifierProvider(create: (context) => DetailMovieViewModel()),
      ],
      child: MaterialApp(
        title: 'The Movie',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/detailPage': (context) {
            final movieId = ModalRoute.of(context)!.settings.arguments as int;
            return DetailsPage(movieId: movieId);
          },
        },
      ),
    );
  }
}
