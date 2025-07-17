import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listview/widgets/sidebar.dart';

class HapusBerita extends StatefulWidget {
  const HapusBerita({Key? key}) : super(key: key);

  @override
  _HapusBeritaState createState() => _HapusBeritaState();
}

class _HapusBeritaState extends State<HapusBerita> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _articles = [];
  String? _selectedDocId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('articles').get();
      setState(() {
        _articles = snapshot.docs.map((doc) => {
              'title': doc['title'],
              'docId': doc.id,
            }).toList();
      });
    } catch (e) {
      debugPrint('Gagal mengambil artikel: $e');
    }
  }

  Future<void> _deleteNews() async {
    if (_selectedDocId == null) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(_selectedDocId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berita berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
      _fetchArticles(); // refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus berita: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _selectedDocId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hapus Berita'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.delete_forever, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Form Hapus Berita',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Pilih berita dari daftar untuk menghapus',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Dropdown
              DropdownButtonFormField<String>(
                value: _selectedDocId,
                decoration: InputDecoration(
                  labelText: 'Pilih Berita Yang Akan Dihapus',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.article, color: Colors.red),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                hint: const Text('Pilih berita'),
                items: _articles.map((article) {
                  return DropdownMenuItem<String>(
                    value: article['docId'],
                    child: Text(article['title']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDocId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih berita yang ingin dihapus';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Tombol Hapus
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () {
                        if (_formKey.currentState!.validate()) {
                          _deleteNews();
                        }
                      },
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.delete),
                      label: Text(
                        _isLoading ? 'Menghapus...' : 'Hapus Berita',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      drawer: const Sidebar(),
    );
  }
}
