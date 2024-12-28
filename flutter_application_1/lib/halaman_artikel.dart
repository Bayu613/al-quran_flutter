import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_application_1/detail_page.dart';
import 'package:http/http.dart' as http;

class Halamanartikel extends StatefulWidget {
  const Halamanartikel({super.key});

  @override
  State<Halamanartikel> createState() => _HalamanartikelState();
}

class _HalamanartikelState extends State<Halamanartikel> {
  List _listData = [];
  int _selectedIndex = 0;

  Future<void> _getData() async {
    try {
      final response =
          await http.get(Uri.parse('https://equran.id/api/v2/surat'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        setState(() {
          _listData = data;
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      print(e);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Halaman Daftar Surat', style: TextStyle(fontSize: 30))),
    Center(child: Text('Halaman Kedua', style: TextStyle(fontSize: 30))),
    Center(child: Text('Halaman Ketiga', style: TextStyle(fontSize: 30))),
  ];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.book,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Al-Quran',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.teal.shade700),
        ),
      ),
      body: _selectedIndex == 0
          ? _listData.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  itemCount: _listData.length,
                  itemBuilder: (context, index) {
                    final item = _listData[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => DetailPage(
                              suratId: item['nomor'],
                            ),
                            transitionsBuilder: (_, animation, __, child) =>
                                FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Color(0xFFE9F7EF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal.shade700,
                            child: Text(
                              item['nomor'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            item['namaLatin'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Colors.teal.shade900,
                            ),
                          ),
                          subtitle: Text(
                            '${item['tempatTurun']} | ${item['jumlahAyat']} Ayat',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.teal.shade300,
                          ),
                        ),
                      ),
                    );
                  },
                )
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.teal.shade700,
        elevation: 15,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Daftar Surat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
