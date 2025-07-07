import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/config_apps.dart';
import '../../provider/auth_provider.dart';
import '../widgets/image_picker_widget.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _pengarangController = TextEditingController();
  final TextEditingController _penerbitController = TextEditingController();

  Uint8List? _imageBytes;
  bool _isLoading = false;

  void simpanData() async {
    String judul = _judulController.text.trim();
    String pengarang = _pengarangController.text.trim();
    String penerbit = _penerbitController.text.trim();

    if (judul.isEmpty || pengarang.isEmpty || penerbit.isEmpty || _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Semua field wajib diisi dan cover wajib diunggah"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = context.read<AuthProvider>().token;
      final uri = Uri.parse(ConfigApps.url + ConfigApps.tambahbuku);


      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['judul_buku'] = judul;
      request.fields['pengarang'] = pengarang;
      request.fields['penerbit'] = penerbit;

      // Tambah file cover (field name sesuai backend)
      request.files.add(http.MultipartFile.fromBytes(
        'cover',
        _imageBytes!,
        filename: 'cover.jpg',
      ));

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Buku berhasil disimpan"),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context, true); // Kirim sinyal refresh ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal menyimpan buku, status: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pengarangController.dispose();
    _penerbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku'),
        backgroundColor: const Color.fromARGB(201, 8, 160, 112),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Buku',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pengarangController,
              decoration: const InputDecoration(
                labelText: 'Pengarang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _penerbitController,
              decoration: const InputDecoration(
                labelText: 'Penerbit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ImagePickerWidget(
              imageBytes: _imageBytes,
              onImageSelected: (bytes) {
                setState(() {
                  _imageBytes = bytes;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Menyimpan...' : 'Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(201, 8, 160, 112),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading ? null : simpanData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
