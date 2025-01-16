import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input data
  final TextEditingController _namaKosController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tipeKosController = TextEditingController();
  final TextEditingController _jumlahKamarController = TextEditingController();
  final TextEditingController _fasilitasKamarController =
      TextEditingController();
  final TextEditingController _fasilitasUmumController =
      TextEditingController();
  final TextEditingController _hargaSewaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  List<File> _fotoKamar = [];
  List<File> _fotoUmum = [];
  List<File> _fotoEksterior = [];

  Future<void> _pickFiles(List<File> fileList, String label) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      final files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        if (label == 'kamar') {
          _fotoKamar.addAll(files);
        } else if (label == 'umum') {
          _fotoUmum.addAll(files);
        } else if (label == 'eksterior') {
          _fotoEksterior.addAll(files);
        }
      });
    }
  }

  Future<List<String>> _uploadFiles(List<File> files, String folder) async {
    final urls = <String>[];

    for (final file in files) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      try {
        await Supabase.instance.client.storage
            .from(folder)
            .upload(fileName, file);
        final publicUrl = Supabase.instance.client.storage
            .from(folder)
            .getPublicUrl(fileName);
        urls.add(publicUrl);
      } catch (e) {
        debugPrint('Error uploading file: $e');
      }
    }

    return urls;
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Upload files
        final fotoKamarUrls = await _uploadFiles(_fotoKamar, 'foto_kamar');
        final fotoUmumUrls = await _uploadFiles(_fotoUmum, 'foto_umum');
        final fotoEksteriorUrls =
            await _uploadFiles(_fotoEksterior, 'foto_eksterior');

        // Simpan data ke Supabase
        try {
          final response =
              await Supabase.instance.client.from('tambahkos').insert({
            'nama_kos': _namaKosController.text,
            'alamat': _alamatController.text,
            'tipe_kos': _tipeKosController.text,
            'jumlah_kamar': int.parse(_jumlahKamarController.text),
            'fasilitas_kamar': _fasilitasKamarController.text,
            'fasilitas_umum': _fasilitasUmumController.text,
            'harga_sewa': _hargaSewaController.text,
            'deskripsi': _deskripsiController.text,
            'kontak': _kontakController.text,
            'lokasi': _lokasiController.text,
            'foto_kamar': fotoKamarUrls,
            'foto_umum': fotoUmumUrls,
            'foto_eksterior': fotoEksteriorUrls,
          }).select();

          if (response != null && response is List && response.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil disimpan!')),
            );
            Navigator.pop(context);
          } else {
            throw Exception('Respons tidak valid atau kosong');
          }
        } catch (e) {
          debugPrint('Error saving data: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data: $e')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Properti Kos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form fields
                ...[
                  {'controller': _namaKosController, 'label': 'Nama Kos'},
                  {'controller': _alamatController, 'label': 'Alamat Lengkap'},
                  {
                    'controller': _tipeKosController,
                    'label': 'Tipe Kos (Pria/Wanita/Campur)'
                  },
                  {
                    'controller': _jumlahKamarController,
                    'label': 'Jumlah Kamar'
                  },
                  {
                    'controller': _fasilitasKamarController,
                    'label': 'Fasilitas Kamar'
                  },
                  {
                    'controller': _fasilitasUmumController,
                    'label': 'Fasilitas Umum'
                  },
                  {'controller': _hargaSewaController, 'label': 'Harga Sewa'},
                  {
                    'controller': _deskripsiController,
                    'label': 'Deskripsi Kos'
                  },
                  {'controller': _kontakController, 'label': 'Kontak Pemilik'},
                  {
                    'controller': _lokasiController,
                    'label': 'Lokasi di Peta (URL Google Maps)'
                  },
                ].map((field) {
                  return TextFormField(
                    controller: field['controller'] as TextEditingController,
                    decoration:
                        InputDecoration(labelText: field['label'] as String),
                    validator: (value) => value == null || value.isEmpty
                        ? '${field['label']} wajib diisi'
                        : null,
                  );
                }),
                const SizedBox(height: 16.0),
                // Upload photo buttons
                ...[
                  {
                    'label': 'Unggah Foto Kamar',
                    'files': _fotoKamar,
                    'key': 'kamar'
                  },
                  {
                    'label': 'Unggah Foto Umum',
                    'files': _fotoUmum,
                    'key': 'umum'
                  },
                  {
                    'label': 'Unggah Foto Eksterior',
                    'files': _fotoEksterior,
                    'key': 'eksterior'
                  },
                ].map((field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickFiles(
                            field['files'] as List<File>,
                            field['key'] as String),
                        child: Text(field['label'] as String),
                      ),
                      Wrap(
                        children: (field['files'] as List<File>)
                            .map((file) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(file.path.split('/').last,
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16.0),
                // Save button
                ElevatedButton(
                  onPressed: _simpanData,
                  child: const Text('Simpan Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
