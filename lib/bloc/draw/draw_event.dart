part of 'draw_bloc.dart';

@immutable
sealed class DrawEvent extends Equatable {
  const DrawEvent();

  @override
  List<Object> get props => [];
}

final class DrawFigureDrawn extends DrawEvent {
  const DrawFigureDrawn({
    required this.figure,
  });

  final Map<String, dynamic> figure;

  @override
  List<Object> get props => [figure];
}

final class DrawClearAllDrawns extends DrawEvent {
  const DrawClearAllDrawns();
}
