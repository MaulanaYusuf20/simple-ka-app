import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:http/http.dart' as http;
import 'package:app_ticket_ka/page/home.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';

class Pesan extends StatefulWidget {
  final String nik;
  final jadwalModel model;
  const Pesan({Key? key, required this.model, required this.nik}) : super(key: key);

  @override
  State<Pesan> createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  TextEditingController orang = TextEditingController();

  String date = '';
  int total = 0;
  int totalTiket = 0;

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs args, BuildContext context) async {
    // TODO: implement your code here
    var hour;
    var minute;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      confirmText: "Pesan",
      cancelText: "Batalkan",
      helpText: "Pilih Jam Keberangkatan",
    );

    if (time != null) {
      hour = time.hour;
      minute = time.minute;
    }

    final tanggal = args.value;

    final dateFinal = tanggal.toString().split(' ');
    final formatedDate = dateFinal[0];
    date = '$formatedDate $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Tanggal dan Jam Keberangkatan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 370,
                  child: SfDateRangePicker(
                    onSelectionChanged:
                        ((DateRangePickerSelectionChangedArgs args) =>
                            _onSelectionChanged(args, context)),
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Jumlah orang',
                  ),
                  controller: orang,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () async {
                    final idKereta = widget.model.idKereta;
                    final nik = widget.nik;
                    final tujuan = widget.model.tujuan;
                    final asal = widget.model.asal;
                    final tanggal = date;
                    final person = orang.text;
                    final total = int.parse(person)*widget.model.hargaTiket;
                    final body = {
                      'idKereta': idKereta,
                      'nik': nik,
                      'tujuan': tujuan,
                      'asal': asal,
                      'tanggal': tanggal,
                      'total': total.toString()
                    };

                    print(body);
        
                    var url = Uri.parse('https://simple-ka-api.herokuapp.com/tickets');
                    var response = await http.post(url, body: body).then((value){
                      var snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Berhasil!',
                            message:
                                'Selamat, anda berhasil pesan!',
                            contentType: ContentType.success,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                  child: Text(
                    'Pesan',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
