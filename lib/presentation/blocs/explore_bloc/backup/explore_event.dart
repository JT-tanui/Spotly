import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class LoadExploreData extends ExploreEvent {
  const LoadExploreData();
}

class RefreshExploreData extends ExploreEvent {
  const RefreshExploreData();
}

class FilterByCategory extends ExploreEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}
