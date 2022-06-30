import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class Person {
  String nama;
  String email;
  String noHp;
  String nik;

  Person(
      {required this.nama,
      required this.email,
      required this.noHp,
      required this.nik});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      nik: json['nik'],
      nama: json['nama'],
      email: json['email'],
      noHp: json['noHp'],
    );
  }
}

class KA {
  String idTx;
  String idKereta;
  String tanggal;
  int total;
  String asal;
  String tujuan;

  KA(
      {required this.idTx,
      required this.idKereta,
      required this.tanggal,
      required this.total,
      required this.asal,
      required this.tujuan});

  factory KA.fromJson(Map<String, dynamic> json) {
    return KA(
      idTx: json['idTx'],
      idKereta: json['idKereta'],
      tanggal: json['tanggal'],
      total: json['total'],
      asal: json['asal'],
      tujuan: json['tujuan'],
    );
  }
}

class Transaksi extends StatefulWidget {
  Transaksi({Key? key, required this.email}) : super(key: key);

  String email;

  @override
  State<Transaksi> createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  late Person user;
  late List<KA> ka;

  final refreshController = RefreshController();

  void getNIK() async {
    var url =
        Uri.parse('https://simple-ka-api.herokuapp.com/user/' + widget.email);
    await http.get(url).then((value) {
    final body = jsonDecode(value.body);
    user = Person.fromJson(body['data']);

    print(user);

    getTicket(user.nik);

    setState(() {});
    });
  }

  void getTicket(String nik) async{
    
    var url =
        Uri.parse('https://simple-ka-api.herokuapp.com/orders/' + nik);
    var response = await http.get(url).then((value) {
      refreshController.refreshCompleted();
      return value;
    });

    final body = jsonDecode(response.body);
    try {
      final tickets = body['data'] as List;
    ka = tickets.map((e) => KA.fromJson(e)).toList();
    setState(() {
      
    });
    } catch (e) {
      ka = [];
    }
    print(ka);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNIK();
    // getTicket();
    // getTicket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshController,
          onRefresh: () => getTicket(user.nik),
          child: ListView(
            children: [
              // FutureBuilder(builder: (context, snapshot) => ,),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            user.nama,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            user.noHp,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: () {},
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            color: Colors.red,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Daftar Transaksi",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (ka.length == 0) ? SizedBox.shrink() : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: ka.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                ka[index].idTx,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                ka[index].tanggal,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ka[index].idKereta,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            user.nama,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Kota Asal",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                "Kota Tujuan",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                ka[index].asal,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                ka[index].tujuan,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Total Harga",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Rp. ${ka[index].total}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
