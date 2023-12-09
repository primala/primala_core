// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/error/failure.dart';
import './store_state.dart';
import 'package:equatable/equatable.dart';
part 'base_future_store.g.dart';

class BaseFutureStore<T> = _BaseFutureStoreBase<T> with _$BaseFutureStore;

abstract class _BaseFutureStoreBase<T> extends Equatable with Store {
  @observable
  late ObservableFuture<Either<Failure, T>> entityOrFailureFuture;

  @observable
  late Either<Failure, T> unwrappedEntityOrFailure;

  _BaseFutureStoreBase({
    required Either<Failure, T> baseEntity,
    required ObservableFuture<Either<Failure, T>> entityFutureParam,
  })  : unwrappedEntityOrFailure = baseEntity,
        entityOrFailureFuture = entityFutureParam;

  @computed
  StoreState get storeState => _computeStoreState(entityOrFailureFuture);

  _computeStoreState(ObservableFuture observable) {
    if (observable.status == FutureStatus.rejected) {
      return StoreState.initial;
    }
    return entityOrFailureFuture.status == FutureStatus.pending
        ? StoreState.loading
        : StoreState.loaded;
  }

  @override
  List<Object> get props => [
        entityOrFailureFuture,
        unwrappedEntityOrFailure,
      ];
}
