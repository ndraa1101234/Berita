import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listview/widgets/sidebar.dart';

class EditBerita extends StatefulWidget {
  final String docId;
  final String currentTitle;
  final String currentContent;

  EditBerita({
    required this.docId,
    required this.currentTitle,
    required this.currentContent,
  });

  @override
  _EditBeritaState createState() => _EditBeritaState();
}

class _EditBeritaState extends State<EditBerita> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;

  String? _selectedCategory;
  bool _isLoading = false;

  final List<String> _categories = [
    'Politik', 'Teknologi', 'Olahraga', 'Ekonomi', 'Hiburan', 'Kesehatan'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _contentController = TextEditingController(text: widget.currentContent);
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.docId)
          .update({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'category': _selectedCategory ?? '',
        'updatedAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berita berhasil diperbarui!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan berita: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    _imageUrlController.clear();
    setState(() => _selectedCategory = null);
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    Color color;

    switch (category) {
      case 'Politik':
        iconData = Icons.account_balance;
        color = Colors.red;
        break;
      case 'Teknologi':
        iconData = Icons.computer;
        color = Colors.blue;
        break;
      case 'Olahraga':
        iconData = Icons.sports_soccer;
        color = Colors.green;
        break;
      case 'Ekonomi':
        iconData = Icons.trending_up;
        color = Colors.orange;
        break;
      case 'Hiburan':
        iconData = Icons.movie;
        color = Colors.purple;
        break;
      case 'Kesehatan':
        iconData = Icons.local_hospital;
        color = Colors.teal;
        break;
      default:
        iconData = Icons.article;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Berita'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Form Edit Berita',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lengkapi semua field untuk mengedit',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Pilih Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.category, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        _getCategoryIcon(category),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Kategori harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Berita',
                  hintText: 'Masukkan judul berita yang menarik',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.title, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Judul berita harus diisi';
                  if (value.trim().length < 10) return 'Minimal 10 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Isi Berita',
                  hintText: 'Tuliskan isi berita secara lengkap',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: Icon(Icons.description, color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Isi berita harus diisi';
                  if (value.trim().length < 50) return 'Minimal 50 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL Gambar',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.image, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[50],
                  suffixIcon: _imageUrlController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.preview),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Preview Gambar'),
                                content: Image.network(
                                  _imageUrlController.text,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('Gagal memuat gambar'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : null,
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'URL gambar harus diisi';
                  if (!_isValidUrl(value.trim())) return 'Format URL tidak valid';
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _saveNews,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        _isLoading ? 'Menyimpan...' : 'Simpan Berita',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
    );
  }
}
