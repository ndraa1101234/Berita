import '../models/news_model.dart';

class NewsService {
  // Simulasi data berita
  Future<List<NewsArticle>> getNews() async {
    // Simulasi delay network
    await Future.delayed(Duration(seconds: 1));
    
    return [
      NewsArticle(
        id: '1',
        title: 'Perkembangan Teknologi AI di Indonesia Semakin Pesat',
        description: 'Industri teknologi artificial intelligence di Indonesia mengalami pertumbuhan yang signifikan dalam beberapa tahun terakhir.',
        imageUrl: 'https://picsum.photos/400/300?random=1',
        source: 'TechNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 2)),
        category: 'Teknologi',
        author: 'Ahmad Rizki',
      ),
      NewsArticle(
        id: '2',
        title: 'Timnas Indonesia Lolos ke Babak Final Piala AFF',
        description: 'Tim nasional sepak bola Indonesia berhasil mengalahkan Thailand dengan skor 2-1 dan melaju ke babak final.',
        imageUrl: 'https://picsum.photos/400/300?random=2',
        source: 'SportNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 4)),
        category: 'Olahraga',
        author: 'Sari Dewi',
      ),
      NewsArticle(
        id: '3',
        title: 'Ekonomi Indonesia Tumbuh 5.2% di Kuartal Ketiga',
        description: 'Badan Pusat Statistik melaporkan pertumbuhan ekonomi Indonesia mencapai 5.2% pada kuartal ketiga tahun ini.',
        imageUrl: 'https://picsum.photos/400/300?random=3',
        source: 'EkonomiToday',
        publishedAt: DateTime.now().subtract(Duration(hours: 6)),
        category: 'Ekonomi',
        author: 'Budi Santoso',
      ),
      NewsArticle(
        id: '4',
        title: 'Kebijakan Baru Pemerintah Tentang Subsidi BBM',
        description: 'Pemerintah mengumumkan kebijakan baru terkait subsidi bahan bakar minyak yang akan berlaku mulai bulan depan.',
        imageUrl: 'https://picsum.photos/400/300?random=4',
        source: 'PolitikNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 8)),
        category: 'Politik',
        author: 'Maya Sari',
      ),
      NewsArticle(
        id: '5',
        title: 'Film Indonesia Raih Penghargaan di Festival Cannes',
        description: 'Sutradara muda Indonesia berhasil meraih penghargaan bergengsi di Festival Film Cannes untuk kategori film pendek.',
        imageUrl: 'https://picsum.photos/400/300?random=5',
        source: 'EntertainmentNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 10)),
        category: 'Hiburan',
        author: 'Rina Putri',
      ),
      NewsArticle(
        id: '6',
        title: 'Tips Menjaga Kesehatan Mental di Era Digital',
        description: 'Para ahli kesehatan memberikan tips praktis untuk menjaga kesehatan mental di tengah pesatnya perkembangan teknologi digital.',
        imageUrl: 'https://picsum.photos/400/300?random=6',
        source: 'HealthNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 12)),
        category: 'Kesehatan',
        author: 'Dr. Indra Wijaya',
      ),
      NewsArticle(
        id: '7',
        title: 'Startup Indonesia Raih Pendanaan 50 Juta Dollar',
        description: 'Sebuah startup teknologi finansial asal Indonesia berhasil meraih pendanaan seri B sebesar 50 juta dollar Amerika.',
        imageUrl: 'https://picsum.photos/400/300?random=7',
        source: 'StartupNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 14)),
        category: 'Teknologi',
        author: 'Andi Pratama',
      ),
      NewsArticle(
        id: '8',
        title: 'Inflasi Indonesia Turun ke Level 2.8% di Bulan Oktober',
        description: 'Bank Indonesia melaporkan tingkat inflasi nasional turun menjadi 2.8% pada bulan Oktober, lebih rendah dari perkiraan.',
        imageUrl: 'https://picsum.photos/400/300?random=8',
        source: 'EkonomiToday',
        publishedAt: DateTime.now().subtract(Duration(hours: 16)),
        category: 'Ekonomi',
        author: 'Lestari Ningrum',
      ),
      NewsArticle(
        id: '9',
        title: 'Pemilu 2024: Kandidat Presiden dan Wakil Presiden Ditetapkan',
        description: 'Kementerian Dalam Negeri mengumumkan nama calon presiden dan wakil presiden yang akan bertanding dalam pemilu 2024.',
        imageUrl: 'https://picsum.photos/400/300?random=9',
        source: 'PolitikNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 7)),
        category: 'Politik',
        author: 'Rudi Santoso',
      ),
    ];
  }

  Future<List<NewsArticle>> getFeaturedNews() async {
    // Simulasi delay network
    await Future.delayed(Duration(milliseconds: 800));
    
    return [
      NewsArticle(
        id: 'f1',
        title: 'Breaking: Gempa Bumi 6.2 SR Guncang Jawa Barat',
        description: 'Gempa bumi berkekuatan 6.2 skala richter mengguncang wilayah Jawa Barat pada pagi hari ini. BMKG meminta masyarakat tetap waspada.',
        imageUrl: 'https://picsum.photos/600/400?random=10',
        source: 'BeritaUtama',
        publishedAt: DateTime.now().subtract(Duration(minutes: 30)),
        category: 'Breaking News',
        author: 'Tim Redaksi',
      ),
      NewsArticle(
        id: 'f2',
        title: 'Presiden Jokowi Resmikan Ibu Kota Nusantara',
        description: 'Presiden Joko Widodo secara resmi meresmikan pembangunan tahap pertama Ibu Kota Nusantara di Kalimantan Timur.',
        imageUrl: 'https://picsum.photos/600/400?random=11',
        source: 'NasionalNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 1)),
        category: 'Politik',
        author: 'Joko Susilo',
      ),
      NewsArticle(
        id: 'f3',
        title: 'Indonesia Juara Umum SEA Games 2023',
        description: 'Tim Indonesia berhasil meraih posisi juara umum di ajang SEA Games 2023 dengan total 150 medali emas.',
        imageUrl: 'https://picsum.photos/600/400?random=12',
        source: 'SportNews',
        publishedAt: DateTime.now().subtract(Duration(hours: 3)),
        category: 'Olahraga',
        author: 'Fitri Handayani',
      ),
    ];
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final allNews = await getNews();
    return allNews.where((article) => 
      article.title.toLowerCase().contains(query.toLowerCase()) ||
      article.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
