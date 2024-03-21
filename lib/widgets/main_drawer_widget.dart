import 'package:drawing_together/bloc/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Business'),
          ),
          ListTile(
            title: const Text('School'),
          ),
          Spacer(),
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationSignOut());
              },
              child: const Text('Log out')),
        ],
      ),
    );
  }
}
