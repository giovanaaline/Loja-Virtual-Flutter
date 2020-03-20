import 'package:flutter/material.dart';
import 'package:lojavirtual/tabs/home_tab.dart';
import 'package:lojavirtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(), //para não deslizar com o dedo (arrastar)
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Container(color: Colors.red,
          child: GestureDetector(
            onTap: (){
              _pageController.jumpToPage(0);
            },
          ),
        ),
        Container(color: Colors.green,
          child: GestureDetector(
            onTap: (){
              _pageController.jumpToPage(0);
            },
          ),
        ),
        Container(color: Colors.blue,
          child: GestureDetector(
            onTap: (){
              _pageController.jumpToPage(0);
            },
          ),
        )
      ],
    );
  }
}
