import 'package:app_ticket_ka/page/admin.dart';
import 'package:app_ticket_ka/page/pesan.dart';
import 'package:app_ticket_ka/page/tambah_admin.dart';
import 'package:app_ticket_ka/page/transaksi.dart';
import 'package:flutter/material.dart';
import 'package:app_ticket_ka/page/login.dart';
import 'package:app_ticket_ka/page/register.dart';
import 'package:app_ticket_ka/page/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Ticket Kereta Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(),
    );
  }
}
