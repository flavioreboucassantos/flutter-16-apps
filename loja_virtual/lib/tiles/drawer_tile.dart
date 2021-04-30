import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;

  final PageController _pageController;
  final int _page;

  DrawerTile(this.icon, this.text, this._pageController, this._page);

  Color _getColor(BuildContext context) {
    return _pageController.page.round() == _page
        ? Theme.of(context).primaryColor
        : Colors.grey[700];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _pageController.jumpToPage(_page);
        },
        child: Container(
          padding: EdgeInsets.only(left: 32.0),
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32.0,
                color: _getColor(context),
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: _getColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
