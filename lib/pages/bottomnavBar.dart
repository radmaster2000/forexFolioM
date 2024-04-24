import 'package:flutter/material.dart';
import 'package:fx_journal/pages/myjournal.dart';
import 'package:fx_journal/pages/toolScreen.dart';

class NavBar extends StatefulWidget {
   NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    ToolScreen(),
    MyJournal()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex=1;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       // backgroundColor: Color.fromARGB(255, 24, 21, 21),
        // appBar: AppBar(
        // elevation: 50,
        //   centerTitle: true,
        //   backgroundColor: Colors.transparent,
        //   title: const Text('My Journal',),
        //   actions: [IconButton(onPressed: (){}, icon: Icon(Icons.account_circle))],
        // ),
         body:_pages.elementAt(_selectedIndex) ,
        bottomNavigationBar:
        BottomNavigationBar(
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.hardware_sharp),
                     label: 'Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
                     label: 'MyJournal',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),




        // BottomNavigationBar(
        //   selectedItemColor: Colors.blue,
        //   backgroundColor: Colors.black,
        //   unselectedItemColor: Colors.grey,
        //   items:  <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.hardware_sharp),
        //       label: 'Tools',
        //     ),
        //     // BottomNavigationBarItem(
        //     //   icon: Icon(Icons.camera),
        //     //   label: 'Camera',
        //     // ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.attach_money),
        //       label: 'MyJournal',
        //     ),
        //   ],
        //   type: BottomNavigationBarType.shifting,
        //
        //   onTap: _onItemTapped,
        //   currentIndex: _selectedIndex,
        // ),
      ),
    );
  }
}
