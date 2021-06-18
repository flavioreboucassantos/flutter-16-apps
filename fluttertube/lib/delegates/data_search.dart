import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  Future<List> _suggestions(String search) async {
    http.Response response = await http.get(
      Uri.parse(''
          'http://suggestqueries.google.com/complete/search?hl=en&ds=yt'
          '&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)[1].map((v) => v[0]).toList();
    } else
      throw Exception('Failed to load suggestions');
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty)
      return Container();
    else
      return FutureBuilder<List>(
        future: _suggestions(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            List data = snapshot.data ?? [];
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(data[index]),
                leading: Icon(Icons.play_arrow),
                onTap: () {
                  close(context, data[index]);
                },
              ),
              itemCount: data.length,
            );
          }
        },
      );
  }
}
