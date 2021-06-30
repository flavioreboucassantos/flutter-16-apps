import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) => UserTile(),
            separatorBuilder: (context, index) => Divider(),
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
