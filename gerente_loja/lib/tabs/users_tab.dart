import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();

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
            onChanged: _userBloc.onChangedSearch,
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> data = snapshot.data ?? [];
                  if (data.length == 0)
                    return Center(
                      child: Text(
                        'Nenhum usuário encontrado!',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                        ),
                      ),
                    );
                  else
                    return ListView.separated(
                      itemBuilder: (context, index) => UserTile(data[index]),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: data.length,
                    );
                } else
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.pinkAccent,
                    ),
                  );
              }),
        ),
      ],
    );
  }
}
