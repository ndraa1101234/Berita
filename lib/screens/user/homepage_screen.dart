import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listview/screens/admin/login_admin.dart';
import 'package:listview/screens/user/news_detail_screen.dart';
import '../../models/news_model.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/featured_news_card.dart';
import '../../services/news_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _featuredArticles = [];
  String _selectedCategory = 'Semua';
  bool _isLoading = true;

  final List<String> _categories = [
    'Semua',
    'Politik',
    'Teknologi',
    'Olahraga',
    'Ekonomi',
    'Hiburan',
    'Kesehatan'
  ];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }
  

  void _loadNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final featured = await _newsService.getFeaturedNews();
      
      setState(() {
        _featuredArticles = featured;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat berita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        title: Text(
          'Berita Hari Ini',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginAdmin()),
            );
            },
            tooltip: 'Admin Panel',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadNews();
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_featuredArticles.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Berita Utama',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        child: PageView.builder(
                          itemCount: _featuredArticles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: FeaturedNewsCard(
                                article: _featuredArticles[index],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CategoryChip(
                              label: _categories[index],
                              isSelected: _selectedCategory == _categories[index],
                              onTap: () {
                                setState(() {
                                  _selectedCategory = _categories[index];
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Berita Terbaru',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('articles')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return Center(child: Text('Terjadi kesalahan'));
                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                        final articles = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final doc = articles[index];
                            final data = doc.data() as Map<String, dynamic>;
                        
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                        article: NewsArticle(
                                          id: doc.id,
                                          title: data['title'],
                                          description: data['content'],
                                          imageUrl: data['imageUrl'] ?? '',
                                          category: data['category'] ?? '',
                                          publishedAt: (data['createdAt'] as Timestamp).toDate(),
                                          source: data['source'] ?? '',
                                          author: data['author'] ?? '',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.white, Colors.blue[50]!],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              data['imageUrl'],
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  height: 200,
                                                  color: Colors.grey[300],
                                                  child: Icon(Icons.error),
                                                );
                                              },
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                        Text(
                                          data['title'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          data['content'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            height: 1.5,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.arrow_forward, 
                                              size: 18, 
                                              color: Colors.blue[700]
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
