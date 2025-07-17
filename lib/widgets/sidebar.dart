import 'package:flutter/material.dart';
import 'package:listview/screens/admin/fitur/add_data_screen.dart';
import 'package:listview/screens/admin/fitur/article_list_page.dart';
import 'package:listview/screens/admin/fitur/hapus_berita.dart';
import 'package:listview/screens/admin/homepage_admin.dart';
import 'package:listview/screens/user/homepage_screen.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Simple Header
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.cancel_rounded,
                    size: 30,
                      color: Colors.white,
                    )),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@gmail.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Simple Menu Items
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomepageAdmin()),
              );
            },
          ),
          
          ListTile(
            leading: Icon(Icons.person, color: Colors.green),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur Profile akan segera hadir')),
              );
            },
          ),
          
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur Pengaturan akan segera hadir')),
              );
            },
          ),
          
          Divider(),
          
          ListTile(
            leading: Icon(Icons.add, color: Colors.blue),
            title: Text('Tambah Berita'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDataScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit_outlined, color: const Color.fromARGB(255, 255, 170, 59),),
            title: Text('Edit Berita'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticleListPage()),
            );
            },
          ),
          ListTile(
            leading:  Icon(Icons.delete, color: Colors.red),
            title: Text('Hapus Berita'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HapusBerita()),
                );
            },
          ),
          
          Divider(),
          
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Keluar'),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
