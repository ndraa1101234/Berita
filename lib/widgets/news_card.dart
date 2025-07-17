import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsCard extends StatelessWidget {
  final DocumentSnapshot article;

  const NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = article.data() as Map<String, dynamic>;
    
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Hero(
                tag: 'news_image_${article.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      data['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(data['category']),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data['category'].toString().toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Title
                    Text(
                      data['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 6),
                    
                    // Description
                    Text(
                      data['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Source and Date
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${data['source']} • ${_formatDate(data['publishedAt'].toDate())}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'politik':
        return Color(0xFFE53935);
      case 'teknologi':
        return Color(0xFF1E88E5);
      case 'olahraga':
        return Color(0xFF43A047);
      case 'ekonomi':
        return Color(0xFFF4511E);
      case 'hiburan':
        return Color(0xFF8E24AA);
      case 'kesehatan':
        return Color(0xFF00897B);
      default:
        return Color(0xFF757575);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}
