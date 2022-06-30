import 'package:app_ticket_ka/page/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isObscure = true;
  TextEditingController nik = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController nohp = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void _navigatorLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/regist.jpg'),
              fit: BoxFit.fill
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Card(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Registrasi', 
                        style: TextStyle(
                        fontSize: 35, 
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        prefixIcon: Icon(Icons.badge),
                        labelText: 'NIK',
                        filled: true,
                        fillColor: Colors.grey[100]
                        ),
                        controller: nik,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Nama Lengkap',
                        filled: true,
                        fillColor: Colors.grey[100]
                        ),
                        controller: nama,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'No. Handphone',
                        filled: true,
                        fillColor: Colors.grey[100]
                        ),
                        controller: nohp,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                        filled: true,
                        fillColor: Colors.grey[100]
                        ),
                        controller: email,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }
                          ),
                        filled: true,
                        fillColor: Colors.grey[100]
                        ),
                        controller: password,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15), child: Text("Sudah punya akun? ")
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child:
                              TextButton(child: Text('Login!'), onPressed: (){
                                _navigatorLogin(context);
                              },)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                    void register() async {

                     var nikText = nik.text;
                     var namaText = nama.text;
                     var nohpText = nohp.text;
                     var emailText = email.text;
                     var passwordText = password.text;

                     if (nikText == '' || namaText == '' || nohpText == '' || emailText == '' || emailText == '' || passwordText == ''){
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

                    var url = Uri.parse('https://simple-ka-api.herokuapp.com/register');
                    var body = {
                      'nik': nikText,
                      'nama': namaText,
                      'noHp': nohpText,
                      'email': emailText,
                      'password': passwordText,
                    };
                    var response = await http.post(url, body: body).then((value){
                      var snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Berhasil!',
                          message:
                              'Selamat, anda sudah bergabung menjadi anggota!',
                          contentType: ContentType.success,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                    // print('Response status: ${response.statusCode}');
                    // print('Response body: ${response.body}');
                    }
                    register();
                  },
                  child: 
                    Text('Daftar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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