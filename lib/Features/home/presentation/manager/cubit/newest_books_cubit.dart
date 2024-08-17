import 'package:bloc/bloc.dart';
import 'package:bookly/Features/home/domain/entities/book_entity.dart';
import 'package:bookly/Features/home/domain/use_cases/fetch_newest_books_usecase.dart';
import 'package:meta/meta.dart';

part 'newest_books_state.dart';

class NewestBooksCubit extends Cubit<NewestBooksState> {
  NewestBooksCubit(this.fetchNewestBooksUsecase) : super(NewestBooksInitial());

  final FetchNewestBooksUseCase fetchNewestBooksUsecase;

  Future<void> fetchNewestBooks() async {
    emit(NewestBooksInitial());
    var result = await fetchNewestBooksUsecase.call();
    result.fold(
      (failure) {
        emit(NewestBooksFailure(errMessage: failure.message));
      },
      (books) {
        emit(NewestBooksSuccess(books: books));
      },
    );
  }
}
