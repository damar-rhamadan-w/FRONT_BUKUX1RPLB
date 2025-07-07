import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/buku_model.dart';

class BukuProvider with ChangeNotifier {
  List<DataBuku> _daftarBuku = [];

  List<DataBuku> get daftarBuku => _daftarBuku;

  Future<void> fetchBuku() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/buku'));
    if (response.statusCode == 200) {
      _daftarBuku = dataBukuFromJson(response.body);
      notifyListeners();
    }
  }

  Future<void> tambahBuku(DataBuku buku) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/api/buku'),
    );
    request.fields['judul_buku'] = buku.judulBuku;
    request.fields['pengarang'] = buku.pengarang;
    request.fields['penerbit'] = buku.penerbit;

    if (buku.cover.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('cover', buku.cover));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      fetchBuku(); // update otomatis setelah tambah
    }
  }
}
