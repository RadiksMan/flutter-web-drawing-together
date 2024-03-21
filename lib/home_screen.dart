import 'package:drawing_together/widgets/drawing_board/drawing_board_widget.dart';
import 'package:drawing_together/widgets/main_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_svg/svg.dart';

import 'bloc/authentication/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/icons/logo.svg',
          width: 130,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationLoadingState) {
                const CircularProgressIndicator();
              } else if (state is AuthenticationFailure) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('error'),
                      );
                    });
              }
            },
            builder: (context, state) {
              return DrawingBoardComponent();
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
    );
  }
}
