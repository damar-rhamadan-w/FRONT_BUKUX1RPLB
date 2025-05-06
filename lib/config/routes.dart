import 'package:bukuflutter/pages/buku/buku_index.dart';
import 'package:bukuflutter/pages/login/login_pages2.dart';
import 'package:flutter/material.dart';

//Konfigurasi Routing
Map<String,WidgetBuilder> appRoutes = {
  '/login'  :(context) => const LoginView(),
  '/buku'   :(context) => const BukuIndex(),
  
};