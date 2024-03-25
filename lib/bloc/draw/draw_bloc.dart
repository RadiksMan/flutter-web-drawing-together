import 'package:bloc/bloc.dart';
import 'package:drawing_together/utils/draw_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'draw_event.dart';
part 'draw_state.dart';

class DrawBloc extends Bloc<DrawEvent, DrawState> {
  DrawBloc({required this.drawRepository}) : super(DrawInitial()) {
    on<DrawFigureDrawn>(_onFigureDrawn);
    on<DrawClearAllDrawns>(_onDrawClearAllDrawns);
  }

  final DrawRepository drawRepository;

  void _onFigureDrawn(
    DrawFigureDrawn event,
    Emitter<DrawState> emit,
  ) async {
    final result = await drawRepository.saveDrawing(event.figure);
  }

  void _onDrawClearAllDrawns(
    DrawClearAllDrawns event,
    Emitter<DrawState> emit,
  ) async {
    final result = await drawRepository.clealAllContent();
  }
}
