import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

class DrawingToolsButton extends StatefulWidget {
  const DrawingToolsButton({
    super.key,
    required this.controller,
    this.onUndoCallback,
    this.onRedoCallback,
    this.onClearCallback,
  });

  final DrawingController controller;
  final Function? onUndoCallback;
  final Function? onRedoCallback;
  final Function? onClearCallback;

  @override
  State<DrawingToolsButton> createState() => _DrawingToolsButtonState();
}

class _DrawingToolsButtonState extends State<DrawingToolsButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            children: [
              ..._buildActions(),
              const VerticalDivider(
                color: Colors.grey,
                thickness: 1,
                indent: 4,
                endIndent: 4,
              ),
              _buildTools(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      SizedBox(
        height: 24,
        width: 160,
        child: ExValueBuilder<DrawConfig>(
          valueListenable: widget.controller.drawConfig,
          shouldRebuild: (DrawConfig p, DrawConfig n) => p.strokeWidth != n.strokeWidth,
          builder: (_, DrawConfig dc, ___) {
            return Slider(
              value: dc.strokeWidth,
              max: 50,
              min: 1,
              onChanged: (double v) => widget.controller.setStyle(strokeWidth: v),
            );
          },
        ),
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.arrow_turn_up_left),
        onPressed: () {
          if (widget.controller.canUndo()) {
            widget.controller.undo();
          }
        },
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.arrow_turn_up_right),
        onPressed: () {
          if (widget.controller.canRedo()) {
            widget.controller.redo();
          }
        },
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.trash),
        onPressed: () {
          widget.controller.clear();
        },
      ),
    ];
  }

  Widget _buildTools() {
    return ExValueBuilder<DrawConfig>(
      valueListenable: widget.controller.drawConfig,
      shouldRebuild: (DrawConfig p, DrawConfig n) => p.contentType != n.contentType,
      builder: (_, DrawConfig dc, ___) {
        final Type currType = dc.contentType;

        final children = [
          DefToolItem(
              isActive: currType == SimpleLine,
              icon: Icons.edit,
              onTap: () => widget.controller.setPaintContent(SimpleLine())),
          DefToolItem(
              isActive: currType == SmoothLine,
              icon: Icons.brush,
              onTap: () => widget.controller.setPaintContent(SmoothLine())),
          DefToolItem(
              isActive: currType == StraightLine,
              icon: Icons.show_chart,
              onTap: () => widget.controller.setPaintContent(StraightLine())),
        ]
            .map((DefToolItem item) => IconButton(
                  onPressed: item.onTap,
                  icon: Icon(
                    item.icon,
                    color: item.isActive ? item.activeColor : item.color,
                    size: item.iconSize,
                  ),
                ))
            .toList();

        return Row(children: children);
      },
    );
  }
}

class DefToolItem {
  DefToolItem({
    required this.icon,
    required this.isActive,
    this.onTap,
    this.color,
    this.activeColor = Colors.blue,
    this.iconSize,
  });

  final Function()? onTap;
  final bool isActive;

  final IconData icon;
  final double? iconSize;
  final Color? color;
  final Color activeColor;
}
