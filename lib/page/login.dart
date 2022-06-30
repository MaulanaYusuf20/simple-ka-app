import 'dart:convert';

import 'package:app_ticket_ka/page/admin.dart';
import 'package:app_ticket_ka/page/home.dart';
import 'package:app_ticket_ka/page/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isObscure = true;
  TextEditingController email = TextEditingController();
  TextEditingController password= TextEditingController();

  void _navigatorRegister(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register()));
  }

  void _navigatorHome(BuildContext context, String email) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home(email: email,)));
  }

  void _navigatorAdmin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Admin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                child: Image.asset('assets/images/logo.png'),
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
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Email',
                        hintText: 'example@gmail.com'
                      ),
                      controller: email,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }
                          )
                        ),
                        controller: password,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15), child: Text("Belum punya akun? ")
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child:
                            TextButton(child: Text('Daftar Sekarang!'), 
                            onPressed: (){
                              _navigatorRegister(context);
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
                    void Home() async {

                     var emailText = email.text;
                     var passwordText = password.text;

                     if ( emailText == '' || passwordText == ''){
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

                    var url = Uri.parse('https://simple-ka-api.herokuapp.com/login');
                    var body = {
                      'email': emailText,
                      'password': passwordText,
                    };
                    var response = await http.post(url, body: body).then((value){
                      print(value);
                      if (value.statusCode == 200){
                        final body = jsonDecode(value.body);
                        if(body['data']['role'] == 'admin'){
                          _navigatorAdmin(context);
                        } else{
                          _navigatorHome(context, emailText);
                        }
                      } else{
                        var snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Gagal!',
                            message:
                                'Silahkan isi email dan password dengan benar!',
                            contentType: ContentType.failure,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      }
                      // var snackBar = SnackBar(
                      //   elevation: 0,
                      //   behavior: SnackBarBehavior.floating,
                      //   backgroundColor: Colors.transparent,
                      //   content: AwesomeSnackbarContent(
                      //     title: 'Berhasil!',
                      //     message:
                      //         'Selamat anda berhasil login!',
                      //     contentType: ContentType.success,
                      //   ),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                    // print('Response status: ${response.statusCode}');
                    // print('Response body: ${response.body}');
                    }
                    Home();
                  },
                  child: 
                    Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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