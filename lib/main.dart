import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookworm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const BookwormHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BookwormHomePage extends StatelessWidget {
  const BookwormHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _BookwormAppBar(),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(),
            SizedBox(height: 16),
            _CategoryChips(),
            SizedBox(height: 24),
            _SectionHeader(title: 'New Releases'),
            SizedBox(height: 8),
            _HorizontalBookList(section: 'new'),
            SizedBox(height: 8),
            _SectionHeader(title: 'Best Sellers'),
            SizedBox(height: 8),
            _HorizontalBookList(section: 'bestseller'),
            SizedBox(height: 12),
            _SectionHeader(title: 'Recommended for You'),
            SizedBox(height: 8),
            _RecommendedList(),
          ],
        ),
      ),
    );
  }
}

class _BookwormAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Bookworm',
        style: TextStyle(
          color: Color(0xFF303F9F),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: Color(0xFF303F9F),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: Color(0xFF303F9F),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F6),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFFB0B0C3)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for books, authors or genres...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xFFB0B0C3), fontSize: 16),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatefulWidget {
  const _CategoryChips();
  @override
  State<_CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<_CategoryChips> {
  final List<String> categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Mystery',
    'Romance',
    'Sci-Fi',
  ];
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => setState(() => selected = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF303F9F)
                    : const Color(0xFFF1F1F6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F1F6)),
              ),
              child: Text(
                categories[i],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              color: Color(0xFF303F9F),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _HorizontalBookList extends StatelessWidget {
  final String section; // 'new' or 'bestseller'
  const _HorizontalBookList({required this.section});

  @override
  Widget build(BuildContext context) {
    final books = section == 'new'
        ? _BookData.newReleases
        : _BookData.bestSellers;
    return SizedBox(
      height: 290,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) =>
            _BookCard(book: books[i], showBadge: section == 'bestseller'),
        physics: const ClampingScrollPhysics(),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final _Book book;
  final bool showBadge;
  const _BookCard({required this.book, this.showBadge = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  book.imageUrl,
                  height: 184,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              if (showBadge)
                Positioned(
                  top: 14,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA726),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                      ),
                    ),
                    child: const Text(
                      'BESTSELLER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF222B45),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            style: const TextStyle(color: Color(0xFF8F9BB3), fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
              const SizedBox(width: 4),
              Text(
                book.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF222B45),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '\$${book.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF3D5CFF),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedList extends StatelessWidget {
  const _RecommendedList();
  @override
  Widget build(BuildContext context) {
    final books = _BookData.recommended;
    return Column(
      children: books
          .map(
            (book) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _RecommendedCard(book: book),
            ),
          )
          .toList(),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final _Book book;
  const _RecommendedCard({required this.book});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book.imageUrl,
                height: 100,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF222B45),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    style: const TextStyle(
                      color: Color(0xFF8F9BB3),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (book.genre != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        book.genre!,
                        style: const TextStyle(
                          color: Color(0xFF8F9BB3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFC107),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        book.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${book.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF3D5CFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Book {
  final String title;
  final String author;
  final String imageUrl;
  final double rating;
  final double price;
  final String? genre;
  const _Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.genre,
  });
}

class _BookData {
  static const newReleases = [
    _Book(
      title: 'The Silent Echo',
      author: 'Emily Winters',
      imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
      rating: 4.8,
      price: 21.99,
    ),
    _Book(
      title: 'Lost in Tomorrow',
      author: 'James Richardson',
      imageUrl: 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e',
      rating: 4.5,
      price: 19.99,
    ),
    _Book(
      title: "Horizon'S Edge",
      author: 'Michael Torres',
      imageUrl: 'https://images.unsplash.com/photo-1541963463532-d68292c34b19',
      rating: 4.6,
      price: 23.50,
    ),
    _Book(
      title: 'The Last Memory',
      author: 'Sophie Chen',
      imageUrl: 'https://images.unsplash.com/photo-1521123845560-14093637aa7d',
      rating: 4.9,
      price: 24.99,
    ),
  ];
  static const bestSellers = [
    _Book(
      title: 'Midnight Dreams',
      author: 'Robert Carter',
      imageUrl: 'https://images.unsplash.com/photo-1589998059171-988d887df646',
      rating: 4.9,
      price: 18.99,
    ),
    _Book(
      title: 'Beyond the Stars',
      author: 'Lisa Johnson',
      imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
      rating: 4.7,
      price: 22.50,
    ),
    _Book(
      title: 'The Hidden Path',
      author: 'Alex Morgan',
      imageUrl: 'https://images.unsplash.com/photo-1531072901881-d644216d4bf9',
      rating: 4.8,
      price: 20.99,
    ),
    _Book(
      title: 'Whispering Shadows',
      author: 'Anna Lee',
      imageUrl: 'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
      rating: 4.6,
      price: 19.99,
    ),
  ];
  static const recommended = [
    _Book(
      title: 'The Art of Thinking Clearly',
      author: 'Rolf Dobelli',
      imageUrl: 'https://images.unsplash.com/photo-1535398089889-dd807df1dfaa',
      rating: 4.5,
      price: 17.99,
      genre: 'Psychology',
    ),
    _Book(
      title: "Summer's End",
      author: 'Jennifer Lee',
      imageUrl: 'https://images.unsplash.com/photo-1592496431122-2349e0fbc666',
      rating: 4.3,
      price: 15.50,
      genre: 'Contemporary Fiction',
    ),
    _Book(
      title: 'The Mountain Between Us',
      author: 'Charles Martin',
      imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
      rating: 4.7,
      price: 18.99,
      genre: 'Adventure',
    ),
  ];
}
