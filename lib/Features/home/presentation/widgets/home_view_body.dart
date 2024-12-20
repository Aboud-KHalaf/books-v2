import 'package:bookly/Features/home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:bookly/Features/home/presentation/widgets/featured_books_list_view_bloc_builder.dart';
import 'package:bookly/Features/home/presentation/widgets/newest_books_list_view_bloc_builder.dart';
import 'package:bookly/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_app_bar.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({Key? key}) : super(key: key);

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      //
      var currentPostition = _scrollController.position.pixels;
      var maxPosition = _scrollController.position.maxScrollExtent;
      //
      if (currentPostition >= maxPosition * 0.8 && !_isLoadingMore) {
        _isLoadingMore = true;
        context.read<NewestBooksCubit>().loadMoreBooks().then((_) {
          _isLoadingMore = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: CustomAppBar(),
              ),
              const FeaturedBooksListViewBlocBuilder(),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Newest Books',
                  style: Styles.textStyle18.copyWith(
                    color: Theme.of(context).cardColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: NewestBooksListViewBlocBuilder(),
        ),
      ],
    );
  }
}
