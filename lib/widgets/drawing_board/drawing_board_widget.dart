import 'package:drawing_together/bloc/draw/draw_bloc.dart';
import 'package:drawing_together/providers/auth_provider.dart';
import 'package:drawing_together/utils/draw_repository.dart';
import 'package:drawing_together/widgets/drawing_board/drawing_tools_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:provider/provider.dart';

class DrawingBoardComponent extends StatefulWidget {
  const DrawingBoardComponent({super.key});

  static const boardWidth = 1024.0;
  static const boardHeight = 1024.0;

  @override
  State<DrawingBoardComponent> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoardComponent> {
  final DrawingController _drawingController = DrawingController();

  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<AuthProvider>(context).onUserChanged.listen((usr) {
      print(usr?.color);
      _drawingController.setStyle(color: usr?.color);
    });
  }

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  void _restBoard() {
    _transformationController.value = Matrix4.identity();
  }

  /// Get Json content
  Future<void> _getJsonList(BuildContext context) async {
    final historyList = _drawingController.getHistory;
    final index = _drawingController.currentIndex;
    final currentContent = historyList[index - 1].toJson();

    context.read<DrawBloc>().add(DrawFigureDrawn(figure: currentContent));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.pink,
        child: Column(
          children: [
            Expanded(
              child: DrawingBoard(
                alignment: Alignment.center,
                showDefaultActions: false,
                showDefaultTools: false,
                transformationController: _transformationController,
                controller: _drawingController,
                background: Container(
                  width: DrawingBoardComponent.boardWidth,
                  height: DrawingBoardComponent.boardHeight,
                  color: Colors.white,
                ),
                onPointerUp: (_) {
                  _getJsonList(context);
                },
              ),
            ),
            DrawingToolsButton(
              controller: _drawingController,
              onClearCallback: () => context.read<DrawBloc>().add(const DrawClearAllDrawns()),
              onRedoCallback: () => print('onRedoCallback'),
              onUndoCallback: () => print('onUndoCallback'),
            ),
          ],
        ),
      ),
    );
  }
}
