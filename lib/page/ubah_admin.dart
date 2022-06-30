import 'package:app_ticket_ka/page/admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


class Ubah extends StatefulWidget {
  const Ubah({Key? key, required this.model}) : super(key: key);
  final jadwalModel model;

  @override
  State<Ubah> createState() => _UbahState();
}

class _UbahState extends State<Ubah> {

  TextEditingController id = TextEditingController();
  TextEditingController namaKereta = TextEditingController();
  TextEditingController asal = TextEditingController();
  TextEditingController tujuan = TextEditingController();
  TextEditingController hargaTiket = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    id.value = TextEditingValue(text: widget.model.idKereta);
    namaKereta.value = TextEditingValue(text: widget.model.namaKereta);
    asal.value = TextEditingValue(text: widget.model.asal);
    tujuan.value = TextEditingValue(text: widget.model.tujuan);
    hargaTiket.value = TextEditingValue(text: widget.model.hargaTiket.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Ubah Jadwal Kereta'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.key),
                        labelText: 'Kode Kereta',
                      ),
                      controller: id,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.badge),
                        labelText: 'Nama Kereta',
                        ),
                        controller: namaKereta,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_circle_left_outlined),
                        labelText: 'Asal',
                        ),
                        controller: asal,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_circle_right_outlined),
                        labelText: 'Tujuan',
                        ),
                        controller: tujuan,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.attach_money),
                        labelText: 'Harga Tiket',
                        ),
                        controller: hargaTiket,
                    ),
                  ],
                ),  
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: 
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  onPressed: (){
                    void Tambah() async {

                     var idText = id.text;
                     var namaKeretaText = namaKereta.text;
                     var asalText = asal.text;
                     var tujuanText = tujuan.text;
                     var hargaText = hargaTiket.text;

                     if (idText == '' || namaKeretaText == '' || asalText == '' || tujuanText == '' || hargaText == ''){
                      var snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Gagal!',
                            message:
                                'Silahkan isi form dengan lengkap!',
                            contentType: ContentType.failure,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      return;
                     }

                    var url = Uri.parse('https://simple-ka-api.herokuapp.com/jadwal');
                    var body = {
                      'idKereta': idText,
                      'namaKereta': namaKeretaText,
                      'asal': asalText,
                      'tujuan': tujuanText,
                      'hargaTiket': hargaText,
                    };
                    var response = await http.put(url, body: body).then((value){
                      var snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Berhasil!',
                          message:
                              'Selamat, anda berhasil mengubah data!',
                          contentType: ContentType.success,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                    // print('Response status: ${response.statusCode}');
                    // print('Response body: ${response.body}');
                    }
                    Tambah();
                  },
                  child: 
                    Text('UBAH', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    color: Colors.blue,
                    textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}