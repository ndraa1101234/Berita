import 'package:flutter/material.dart';
import 'package:listview/widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key}) : super(key: key);

  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}
  


class _AddDataScreenState extends State<AddDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void>addData() async{
  final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final category = _selectedCategory;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul dan konten tidak boleh kosong')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('articles').add({
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'category': category,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artikel berhasil diupload')),
      );

      _titleController.clear();
      _contentController.clear();
      _imageUrlController.clear();
      setState(() {
        _selectedCategory = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload artikel: $e')),
      );
    }
  }
  
  
  String? _selectedCategory;
  bool _isLoading = false;
  
  final List<String> _categories = [
    'Politik',
    'Teknologi',
    'Olahraga',
    'Ekonomi',
    'Hiburan',
    'Kesehatan'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Fungsi untuk validasi URL
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Fungsi untuk menyimpan data
  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi proses penyimpanan
      await Future.delayed(const Duration(seconds: 2));
      
      // Log data yang akan disimpan
      debugPrint('=== Data Berita Baru ===');
      debugPrint('Judul: ${_titleController.text}');
      debugPrint('Isi: ${_contentController.text}');
      debugPrint('Gambar: ${_imageUrlController.text}');
      debugPrint('Kategori: $_selectedCategory');
      debugPrint('========================');

      // Tampilkan pesan sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Berita berhasil disimpan!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Reset form setelah berhasil
        _resetForm();
      }
    } catch (e) {
      // Tampilkan pesan error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Gagal menyimpan berita: $e'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fungsi untuk reset form
  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    _imageUrlController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Berita'),
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
              // Header Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.article, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Form Tambah Berita',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lengkapi semua field untuk menambahkan berita baru',
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

              // Judul Berita
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
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul berita harus diisi';
                  }
                  if (value.trim().length < 10) {
                    return 'Judul berita minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Konten Berita
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Isi Berita',
                  hintText: 'Tuliskan isi berita secara detail dan informatif',
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
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi berita harus diisi';
                  }
                  if (value.trim().length < 50) {
                    return 'Isi berita minimal 50 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // URL Gambar
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
                            // Preview gambar
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
                  if (value == null || value.trim().isEmpty) {
                    return 'URL gambar harus diisi';
                  }
                  if (!_isValidUrl(value.trim())) {
                    return 'Format URL tidak valid';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {}); // Untuk update suffix icon
                },
              ),
              const SizedBox(height: 16),

              // Dropdown Kategori
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.category, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                hint: const Text('Pilih kategori berita'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Tombol Aksi
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: addData,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        _isLoading ? 'Menyimpan...' : 'Simpan Berita',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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

  // Helper function untuk mendapatkan icon kategori
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
}
