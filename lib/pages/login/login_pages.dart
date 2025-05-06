import 'dart:convert';
import 'dart:developer';
import 'package:bukuflutter/config/config_apps.dart';
import 'package:bukuflutter/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final passwordVisible = false;
  var isLoading = false;
  final _formkey = GlobalKey<FormState>();

  //Future<bool> login() async {
  Future<void> login() async {
    isLoading = true;
    //Variabel URL Backend pada config_apps.dart
    final dynamic apiUrl = Uri.parse(ConfigApps.url + ConfigApps.login);
    //Mengambil nilai dari email dan password
    Map<String, String> postData = {
      "email": emailTextController.text,
      "password": passwordTextController.text
    };
    //try {
    final response = await http.post(apiUrl,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: postData);
    Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['status']) {
      Provider.of<TokenProvider>(context, listen: false)
          .setCurrentToken(responseData['token']);
      //TokenProvider().setCurrentToken(responseData["token"]);
      log(context.read<TokenProvider>().getCurrentToken.toString());
      //log(Provider.of<TokenProvider>(context).getCurrentToken as String);
      //Provider.of<TokenProvider>(context, listen: false).setCurrentToken(responseData['token']);
      //return true;
    } else {
      //return false;
      log("Login Gagal");
    }
    // } catch (error) {
    //return false;
    /// log("login gagal 2");
    //log(responseData['']);
    //log(apiUrl.toString());
    //log(error.toString());
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              heightFactor: 1.4,
              widthFactor: 5.0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 70, 40, 10),
                child: Text(
                  "BukuKu",
                  style: TextStyle(
                      color: Color.fromARGB(201, 8, 160, 112),
                      fontSize: 38,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Center(
              heightFactor: 0.9,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(9),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color.fromARGB(246, 75, 75, 75)),
                  ),
                )
              ]),
            ),
            Opacity(
                opacity: 1,
                child: Form(
                    key: _formkey,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 2.5,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(0, 223, 24, 24),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 10, 2, 5),
                          child: Column(
                            children: [
                              //Username Field
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailTextController,
                                  autofocus: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      fillColor:
                                          const Color.fromARGB(0, 223, 24, 24),
                                      filled: true,
                                      hintText: "Email/ Username",
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      focusColor: Colors.black,
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                              //Password Field
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: passwordTextController,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "password",
                                      suffixIcon: const Icon(Icons.visibility),
                                      prefixIcon: const Icon(
                                        Icons.key,
                                        color: Colors.black,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 10, 9),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Lupa Password? klik disini",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Color.fromARGB(201, 8, 160, 112)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 9),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minWidth: MediaQuery.of(context).size.width,
                                  color: const Color.fromARGB(201, 8, 160, 112),
                                  onPressed: () {
                                    //Validasi form input
                                    if (_formkey.currentState!.validate()) {
                                      //aksi login
                                      login();
                                    }
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              /*
                              const Text(
                                "Lupa Password?, klik disini",
                                style: TextStyle(color: Color.fromARGB(255, 15, 2, 109)),)
                                */
                            ],
                          ),
                        )))),
          ],
        ),
      ),
    );
  }
}