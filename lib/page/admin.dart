import 'dart:convert';
import 'package:app_ticket_ka/page/tambah_admin.dart';
import 'package:app_ticket_ka/page/ubah_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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

void _navigatorTambah(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Tambah()));
}
  void _navigatorUbah(BuildContext context, jadwalModel model) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Ubah(model: model,)));
  }

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  late List<jadwalModel> jadwals = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void fetchData() async {
    var url = Uri.parse('https://simple-ka-api.herokuapp.com/jadwal');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final ress = jsonDecode(response.body);
    final models = ress['data'] as List;

   final resModels =  models.map((e) => jadwalModel.fromJSON(e)).toList();
  
    jadwals = resModels;

    _refreshController.refreshCompleted();

    setState(() {
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Jadwal Kereta Api'),
      ),
      body: SmartRefresher(
        child: SingleChildScrollView(
          child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          // Respond to button press
                          _navigatorTambah(context);
                        },
                        icon: Icon(Icons.add),
                        label: Text('TAMBAH'),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                          onPressed: (){
                                            _navigatorUbah(context, jadwals[index]);
                                          },
                                          child: Text(
                                            'Ubah',
                                            style : TextStyle(
                                                fontSize: 16,
                                        ),
                                      ),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                          onPressed: () async{
                                            final idKereta = jadwals[index].idKereta;

                                             var url = Uri.parse('https://simple-ka-api.herokuapp.com/jadwal/' + idKereta);

                                             print(url);

                                             final response = await http.delete(url).then((_){
                                              var snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.transparent,
                                                    content: AwesomeSnackbarContent(
                                                      title: 'Berhasil!',
                                                      message:
                                                          'Selamat, anda berhasil menghapus jadwal!',
                                                      contentType: ContentType.success,
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                          },
                                          child: Text(
                                            'Hapus',
                                            style : TextStyle(
                                                fontSize: 16,
                                        ),
                                      ),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),
            ),
         ),
         controller: _refreshController,
         onRefresh: fetchData,
      ),
     );
  }
}