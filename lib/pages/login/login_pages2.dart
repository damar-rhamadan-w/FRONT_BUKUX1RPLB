import 'package:bukuflutter/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordHidden = true;
  bool isLoading = false;
  String? errorMessage;
  //Routine login

  void _submitLogin() async {
    if (_formkey.currentState!.validate()) {
      //State loading true
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool checkLogin = await authProvider.login(
          _emailController.text, _passwordController.text);

      //mengembalikan state loading
      setState(() {
        isLoading = false;
      });
      if (checkLogin) {
        //Arahkan ke halaman buku
        Navigator.pushReplacementNamed(context, '/buku');
      } else {
        setState(() {
          errorMessage = "Email atau Password salah";
        });
      }
    } else {
      setState(() {
        errorMessage = "Terjadi kesalahan";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    Future.microtask(() {
      //final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final statusAuth = context.read<AuthProvider>().isAuthenticated;
      //log(statusAuth.toString());
      if (statusAuth) {
        //redirect ke daftar buku
        Navigator.pushReplacementNamed(context, '/buku');
      }
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                          height: MediaQuery.of(context).size.height / 1.5,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    autofocus: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          !value.contains('@') ||
                                          !value.contains('.')) {
                                        return "Email tidak boleh kosong/ Sesuaikan format Email";
                                      }
                                      return null;
                                    },
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        fillColor: const Color.fromARGB(
                                            0, 223, 24, 24),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                  ),
                                ),
                                //Password Field
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: TextFormField(
                                    obscureText: passwordHidden,
                                    controller: _passwordController,
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
                                        suffixIcon: IconButton(
                                            onPressed: () => {
                                                  setState(() {
                                                    passwordHidden =
                                                        !passwordHidden;
                                                  })
                                                },
                                            icon: Icon(passwordHidden
                                                ? Icons.visibility
                                                : Icons.visibility_off)),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 9),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    minWidth: MediaQuery.of(context).size.width,
                                    color:
                                        const Color.fromARGB(201, 8, 160, 112),
                                    onPressed: () {
                                      //Validasi form input
                                      if (_formkey.currentState!.validate()) {
                                        isLoading = true;
                                        //aksi login
                                        _submitLogin();
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
          )),
    );
  }
}