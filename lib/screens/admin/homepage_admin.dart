import 'package:flutter/material.dart';
import 'package:listview/screens/admin/fitur/add_data_screen.dart';
import 'package:listview/screens/admin/fitur/edit_data.dart';
import 'package:listview/screens/admin/fitur/hapus_berita.dart';
import 'package:listview/widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomepageAdmin extends StatefulWidget {
  @override
  State<HomepageAdmin> createState() => _HomepageAdminState();
}

class _HomepageAdminState extends State<HomepageAdmin> {
  //method untuk pindah ke halaman add berita
  void _pindahAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDataScreen()),
    );
  }

  //method untuk pindah ke halaman delete berita
  void _pindahDelete() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HapusBerita()),
    );
  }

  //method untuk pindah ke halaman edit berita dengan parameter
  void _pindahEdit(String docId, String currentTitle, String currentContent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBerita(
          docId: docId,
          currentTitle: currentTitle,
          currentContent: currentContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage Admin'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Welcome Section - Diperbagus
            Container(
              margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.blue.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '👋 Selamat Datang, Admin!',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Buttons Section - 3 Button dalam 1 Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Tambah Button
                  Expanded(
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: _pindahAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.blue.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Tambah\nBerita',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Edit Button
                  Expanded(
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => _pindahEdit("", "", ""),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.orange.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_outlined, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Edit\nBerita',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Delete Button
                  Expanded(
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        onPressed: _pindahDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.red.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Hapus\nBerita',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer Info
            Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
            ),
          ],
        ),
      ),
      drawer: const Sidebar(),
    );
  }
}
