import 'package:bukuflutter/config/config_apps.dart';
import 'package:bukuflutter/model/buku_model.dart';
import 'package:bukuflutter/provider/auth_provider.dart';
import 'package:bukuflutter/template/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;

class BukuIndex extends StatefulWidget {
  const BukuIndex({super.key});

  @override
  State<BukuIndex> createState() => _BukuIndexState();
}

class _BukuIndexState extends State<BukuIndex> {
  final TextEditingController textPencarian = TextEditingController();

  List<DataBuku> pencarianBuku = [];

  Widget listBuku = const Center(
    child: CircularProgressIndicator(),
  );

  void cariData(String query) async {
    final token = context.read<AuthProvider>().token;
    if (query.isEmpty) {
      ambilData();
    } else {
      setState(() {
        listBuku = const Center(
          child: CircularProgressIndicator(),
        );
      });
      try {
        final response =
            //await http.get(Uri.parse(ConfigApps.url + ConfigApps.listBuku));
            await http.post(Uri.parse(ConfigApps.url + ConfigApps.caribuku),
                headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
                body: {
              'item': query
            });
        if (response.statusCode == 200) {
          final databuku = dataBukuFromJson(response.body);
          if (mounted) {
            setState(() {
              pencarianBuku = databuku;
              if (databuku.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Tidak Ada Data"),
                  backgroundColor: Colors.red,
                ));
                /*
                Get.snackbar("Kosong", "tidak ada data",
                    backgroundColor: Colors.red);
                */
              } else {
                listBuku = ListView.builder(
                  itemCount: databuku.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        //Aksi klik pindah ke halaman edit
                      },
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        color: const Color.fromARGB(201, 8, 160, 112),
                        shadowColor: const Color(0x4d939393),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Color(0x4d9e9e9e), width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    height:
                                        MediaQuery.sizeOf(context).width * 0.3,
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: const Text('untuk Foto'),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    children: [
                                      Text(
                                        pencarianBuku[index]
                                            .judulBuku
                                            .toUpperCase(),
                                        //textAlign: TextAlign.start,
                                        textDirection: TextDirection.ltr,
                                        //overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      Text(
                                        pencarianBuku[index].pengarang,
                                        //textAlign: TextAlign.start,
                                        //overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12,
                                          color: Color(0xffffffff),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              /*
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  pencarianBuku[index].judulBuku,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xffffffff),
                                  size: 24,
                                ),
                              ],
                            ),
                            */
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Gagal mencari Data"),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Gagal mencari Data"),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        if (e
            .toString()
            .contains("Connection closed before full header was received")) {
          // Handle the specific error condition here
          // You can add custom handling logic for this case
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Gagal memuat Data"),
            backgroundColor: Colors.red,
          ));
        }
        rethrow;
      }
    }
  }

  void ambilData() async {
    final token = context.read<AuthProvider>().token;
    setState(() {
      listBuku = const Center(
        child: CircularProgressIndicator(),
      );
    });
    try {
      final response = await http
          .get(Uri.parse(ConfigApps.url + ConfigApps.listbuku), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        final databuku = dataBukuFromJson(response.body);
        if (mounted) {
          setState(() {
            pencarianBuku = databuku;
            if (databuku.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Tidak ada data buku"),
                backgroundColor: Colors.red,
              ));
            } else {
              listBuku = ListView.builder(
                itemCount: databuku.length,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      //Aksi klik pindah ke halaman edit
                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      color: const Color.fromARGB(201, 8, 160, 112),
                      shadowColor: const Color(0x4d939393),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                  height:
                                      MediaQuery.sizeOf(context).width * 0.3,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: const Text('untuk Foto'),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  children: [
                                    Text(
                                      pencarianBuku[index]
                                          .judulBuku
                                          .toUpperCase(),
                                      //textAlign: TextAlign.start,
                                      textDirection: TextDirection.ltr,
                                      //overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      pencarianBuku[index].pengarang,
                                      //textAlign: TextAlign.start,
                                      //overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            /*
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  pencarianBuku[index].judulBuku,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xffffffff),
                                  size: 24,
                                ),
                              ],
                            ),
                            */
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Gagal mencari Data"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal mencari Data"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        // Handle the specific error condition here
        // You can add custom handling logic for this case
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal mencari Data"),
          backgroundColor: Colors.red,
        ));
      }
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    //checkLoginState();

    Future.microtask(() {
      final statusAuth = context.read<AuthProvider>().isAuthenticated;
      if (!statusAuth) {
        //redirect ke daftar login
        Navigator.pushReplacementNamed(context, '/login');
      }
      ambilData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(201, 8, 160, 112),
        title: const Text(
          "Daftar Buku",
          style: TextStyle(color: Color(0xffffffff)),
        ),
        actions: const [
          Icon(
            Icons.add,
            color: Color(0xffffffff),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 20),
                child: TextField(
                  controller: textPencarian,
                  scrollPadding: const EdgeInsets.all(10),
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  onSubmitted: (String value) {
                    String query = textPencarian.text;
                    cariData(query);
                  },
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    hintText: "Pencarian",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xffabb0c4),
                    ),
                    filled: true,
                    fillColor: const Color(0xfff2f4f7),
                    isDense: false,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 24,
                      ),
                      onPressed: () {
                        //Aksi saat icon search di klik'
                        String query = textPencarian.text;
                        cariData(query);
                      },
                      color: const Color(0xffa9aec2),
                    ),
                  ),
                ),
              ),
              listBuku
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBarApps(),
    );
  }
}