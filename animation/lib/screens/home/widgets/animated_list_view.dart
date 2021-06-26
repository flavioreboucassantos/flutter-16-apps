import 'package:animation/screens/home/widgets/list_data.dart';
import 'package:flutter/material.dart';

class AnimatedListView extends StatelessWidget {
  final Animation<EdgeInsets> _listSlidePosition;
  final AssetImage _profileImage = AssetImage('images/perfil.jpg');

  AnimatedListView(this._listSlidePosition);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 0,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 1,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 2,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 3,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 4,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 5,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 6,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Estudar Flutter',
          image: _profileImage,
          margin: _listSlidePosition.value * 7,
        ),
      ],
    );
  }
}
