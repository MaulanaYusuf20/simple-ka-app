import 'dart:convert';
import 'package:app_ticket_ka/page/pesan.dart';
import 'package:app_ticket_ka/page/transaksi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class jadwalModel{
  String idKereta;
  int hargaTiket;
  String namaKereta;
  String tujuan;
  String asal;

  jadwalModel({required this.asal, required this.tujuan, required this.namaKereta, required this.hargaTiket, required this.idKereta});

  factory jadwalModel.fromJSON(dynamic JSON){
    return jadwalModel(asal: JSON['asal'], tujuan: JSON['tujuan'], namaKereta: JSON['namaKereta'], hargaTiket: JSON['hargaTiket'], idKereta: JSON['idKereta']);
  }
}

void _navigatorPesan(BuildContext context, jadwalModel model, String nik) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pesan(model: model, nik: nik,)));
  }

class Home extends StatefulWidget {
  Home({Key? key, required this.email}) : super(key: key);

  String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<jadwalModel> jadwals = [];
  int selectedIdx = 0;
  Person? user;

  void getNIK() async{
    var url = Uri.parse('https://simple-ka-api.herokuapp.com/user/' + widget.email);
    var response = await http.get(url);
    final body = jsonDecode(response.body);
    user = Person.fromJson(body['data']);
  }

  void fetchData() async {
    var url = Uri.parse('https://simple-ka-api.herokuapp.com/jadwal');
    var response = await http.get(url);

    final ress = jsonDecode(response.body);
    try {

      if(ress['data'] == null) {
        return;
      }

      final models = ress['data'] as List;
    
    
   final resModels =  models.map((e) => jadwalModel.fromJSON(e)).toList();
  
    jadwals = resModels;

    setState(() {
      
    });
    } catch (e) {
      // jadwals = [];
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNIK();
    fetchData();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIdx,
        onTap: (idx) => setState(() {
          selectedIdx = idx;
        }),
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: 
      IndexedStack(
        index: selectedIdx,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/banner.jpg'),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Tiket Kereta Api', 
                          style: TextStyle(
                            fontSize: 25,
                          )
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: jadwals.length,
                          itemBuilder: (context, index) => Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      jadwals[index].idKereta,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(flex: 1,),
                                    Text(
                                      jadwals[index].namaKereta,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Kota Asal',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  Text(
                                      'Kota Tujuan',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  Text(
                                      'Harga',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jadwals[index].asal,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  Text(
                                      jadwals[index].tujuan,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  Text(
                                      'Rp. ${jadwals[index].hargaTiket}',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                        onPressed: (){
                                          _navigatorPesan(context, jadwals[index], user!.nik);
                                        },
                                        child: Text(
                                          'Pesan',
                                          style : TextStyle(
                                              fontSize: 16,
                                      ),
                                    ),
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ) ,)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
          Transaksi( email: widget.email),
        ],
      ),
    );
  }
}