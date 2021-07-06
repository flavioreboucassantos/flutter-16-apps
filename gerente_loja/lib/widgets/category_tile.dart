import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = category.data() ?? Map<String, dynamic>();

    if (data.isEmpty)
      return Container(
        child: Text('Data is Empty'),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data['icon']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            data['title'],
            style: TextStyle(
              color: Colors.grey[850],
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: category.reference.collection('items').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                return Column(
                  children: snapshot.data!.docs
                      .map(
                        (doc) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(doc.data()['images'][0]),
                          ),
                          title: Text(doc.data()['title']),
                          trailing: Text(
                            'R\$ ${(doc.data()['price'] as double).toStringAsFixed(2)}',
                          ),
                          onTap: () {},
                        ),
                      )
                      .toList()
                        ..add(
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.add,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            title: Text('Adicionar'),
                            onTap: () {
                              
                            },
                          ),
                        ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
