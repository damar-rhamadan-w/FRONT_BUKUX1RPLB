import 'package:bukuflutter/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarApps extends StatefulWidget {
  const NavBarApps({super.key});

  @override
  State<NavBarApps> createState() => _NavBarAppsState();
}

class _NavBarAppsState extends State<NavBarApps> {
  int _selectedIndex = 0;
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(
      dynamic action, Icon icon, String label, int index) {
    return BottomNavigationBarItem(
        label: '',
        icon: IconButton(
            onPressed: action,
            color: _selectedIndex == index ? Colors.blue : Colors.grey,
            icon: icon));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildNavItem(() {

        }, const Icon(Icons.home), "Beranda", 0),
        _buildNavItem((){
          //Buku
          Navigator.pushReplacementNamed(context, '/buku');
        }, const Icon(Icons.book), "Buku", 1),
        _buildNavItem((){

        }, const Icon(Icons.people), "Profil", 2),
        _buildNavItem((){
          final authProvider = Provider.of<AuthProvider>(context, listen:false);
          authProvider.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }, const Icon(Icons.exit_to_app), "Keluar", 3)
      ],
    );
  }
}