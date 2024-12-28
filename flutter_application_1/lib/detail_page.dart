import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final int suratId;

  const DetailPage({super.key, required this.suratId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> _suratDetail = {};
  List<dynamic> _ayatList = [];
  bool _isLoading = true;

  Future<void> _getSuratDetail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.get(
        Uri.parse('https://equran.id/api/v2/surat/${widget.suratId}'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody != null && responseBody['data'] != null) {
          setState(() {
            _suratDetail = responseBody['data'];
            _ayatList = responseBody['data']['ayat'];
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Gagal mengambil data.');
      }
    } on SocketException {
      setState(() {
        _isLoading = false;
      });
      print('Kesalahan jaringan: Tidak dapat terhubung ke server.');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Terjadi kesalahan: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getSuratDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Al-Quran',
          style: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                // Header with Surat information
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade700, Colors.teal.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_suratDetail['namaLatin'] ?? ''}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${_suratDetail['arti'] ?? ''} | ${_suratDetail['jumlahAyat']} Ayat',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Dynamic description
                        Text(
                          '${_suratDetail['deskripsi'] ?? ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.justify,
                          softWrap:
                              true, // Ensures the text wraps if it's too long
                        ),
                      ],
                    ),
                  ),
                ),
                // List of Ayat
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final ayat = _ayatList[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Teks Arab and Ayat Number
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Teks Arab
                                  Expanded(
                                    child: Text(
                                      ayat['teksArab'] ?? '',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.teal.shade900,
                                        fontFamily: 'NotoNaskhArabic',
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // Nomor Ayat
                                ],
                              ),
                              SizedBox(height: 8),
                              // Teks Latin
                              Text(
                                ayat['teksLatin'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Terjemahan
                              Text(
                                '${ayat['nomorAyat']}. ${ayat['teksIndonesia']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _ayatList.length,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber.shade600,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.teal.shade700,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Daftar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
