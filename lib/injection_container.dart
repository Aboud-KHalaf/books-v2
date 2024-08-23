import 'package:bookly/Features/home/data/data_sources/home_local_data_sources.dart';
import 'package:bookly/Features/home/data/data_sources/home_remote_data_sources.dart';
import 'package:bookly/Features/home/data/repos/home_repo_imple.dart';
import 'package:bookly/Features/home/domain/repos/home_repo.dart';
import 'package:bookly/Features/home/domain/use_cases/fetch_featured_books_usecase.dart';
import 'package:bookly/Features/home/domain/use_cases/fetch_newest_books_usecase.dart';
import 'package:bookly/Features/home/presentation/manager/cubit/newest_books_cubit.dart';
import 'package:bookly/Features/home/presentation/manager/featured_books_cubit/featured_book_cubit.dart';
import 'package:bookly/core/utils/api_services.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Register external dependencies
  sl.registerLazySingleton<Dio>(() => Dio());

  // Register services
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));

  // Register data sources
  sl.registerLazySingleton<HomeLocalDataSources>(
      () => HomeLocalDataSourcesImpl());
  sl.registerLazySingleton<HomeRemoteDataSources>(
      () => HomeRemoteDataSourcesImpl(sl<ApiService>()));

  // Register repositories
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImple(
        homeLocalDataSources: sl<HomeLocalDataSources>(),
        homeRemoteDataSources: sl<HomeRemoteDataSources>(),
      ));

  // Register use cases
  sl.registerLazySingleton<FetchFeaturedBooksUseCase>(
      () => FetchFeaturedBooksUseCase(sl<HomeRepo>()));
  sl.registerLazySingleton<FetchNewestBooksUseCase>(() =>
      FetchNewestBooksUseCase(
          sl<HomeRepo>())); // Register FetchNewestBooksUseCase

  // Register cubits
  sl.registerFactory<FeaturedBookCubit>(
      () => FeaturedBookCubit(sl<FetchFeaturedBooksUseCase>()));
  sl.registerFactory<NewestBooksCubit>(() => NewestBooksCubit(
      sl<FetchNewestBooksUseCase>())); // Register NewestBooksCubit
}