import 'dart:convert'; // for json decode
import 'package:flutter/material.dart';
import 'package:moto_go/Menu/setting_screen.dart';
import 'package:moto_go/Menu/profile_screen.dart';
import 'package:moto_go/Transaction/booking_transaction.dart';
import 'package:moto_go/Transaction/my_bookings_screen.dart';
import 'package:moto_go/Menu/bike_screen.dart';
import 'package:http/http.dart' as http; // add http for fetching
// Import your Bikes class (make sure path is correct)
import 'package:moto_go/Model/bike.dart'; // adjust path as needed

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  // List of Bikes instead of Map
  List<Bikes> _bikes = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    fetchBikes();
  }

  Future<void> fetchBikes() async {
    try {
      // Replace the below URL with your actual API endpoint
      final response = await http.get(Uri.parse('http://192.168.5.129:3000/api/bikes'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _bikes = data.map((json) => Bikes.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load bikes';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching bikes: $e';
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ride History'),
          content: const Text('Ride History feature coming soon!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMenuTile({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/Icon.PNG', height: 60),
                    const SizedBox(height: 10),
                    const Text('Welcome to',
                        style: TextStyle(color: Colors.white70, fontSize: 18)),
                    const Text('MotoGO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'nunito',
                        )),
                  ],
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.motorcycle),
                  title: const Text('Bikes'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const BikesScreen()));
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SettingScreen()));
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.book_online),
                  title: const Text('My Bookings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MyBookingsScreen()));
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.orange),
                  title: const Text('Logout',
                      style: TextStyle(color: Colors.orange)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Logout
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: MapShapePainter(),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                ? Center(child: Text(_error))
                : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.menu,
                                    size: 28, color: Colors.black),
                                onPressed: () => Scaffold.of(context).openDrawer(),
                              ),
                              const SizedBox(width: 10),
                              Image.asset('assets/Icon.PNG', height: 40),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search,
                              size: 28, color: Colors.black),
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: BikeSearchDelegate(_bikes),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Pick Your Bike',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'nunito',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: height * 0.5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _bikes.length,
                      padding: const EdgeInsets.only(left: 16),
                      itemBuilder: (context, index) {
                        final bike = _bikes[index];
                        return _buildBikeCard(context, bike);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Top Picks ⭐',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'nunito',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _bikes.length,
                    itemBuilder: (context, index) {
                      final bike = _bikes[index];
                      return _buildTopPickCard(context, bike);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Ride History',
          ),
        ],
      ),
    );
  }

  Widget _buildBikeCard(BuildContext context, Bikes bike) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bike.brand,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'nunito',
                color: Colors.black87,
              ),
            ),
            Text(
              bike.model,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'nunito',
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bike.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image));
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '₱${bike.pricePerHour.toStringAsFixed(2)} / hour',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                'Rent Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingTransactionScreen(bike: bike.toJson()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPickCard(BuildContext context, Bikes bike) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            bike.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image);
            },
          ),
        ),
        title: Text(
          bike.brand,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          bike.model,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: Text(
          '₱${bike.pricePerHour.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.orange,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingTransactionScreen(bike: bike.toJson()),
            ),
          );
        },
      ),
    );
  }
}

class BikeSearchDelegate extends SearchDelegate {
  final List<Bikes> bikes;

  BikeSearchDelegate(this.bikes);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = bikes.where((bike) =>
    bike.brand.toLowerCase().contains(query.toLowerCase()) ||
        bike.model.toLowerCase().contains(query.toLowerCase())).toList();

    return _buildResultList(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = bikes.where((bike) =>
    bike.brand.toLowerCase().contains(query.toLowerCase()) ||
        bike.model.toLowerCase().contains(query.toLowerCase())).toList();

    return _buildResultList(context, suggestions);
  }

  Widget _buildResultList(BuildContext context, List<Bikes> results) {
    if (results.isEmpty) {
      return const Center(child: Text('No bikes found'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final bike = results[index];
        return ListTile(
          title: Text('${bike.brand} ${bike.model}'),
          subtitle: Text('₱${bike.pricePerHour.toStringAsFixed(2)} / hour'),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingTransactionScreen(bike: bike.toJson()),
              ),
            );
          },
        );
      },
    );
  }
}

// Your existing MapShapePainter stays unchanged
class MapShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.4,
        size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.05,
        size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
