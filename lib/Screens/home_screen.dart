import 'package:flutter/material.dart';
import 'package:moto_go/Menu/setting_screen.dart';
import 'package:moto_go/Menu/profile_screen.dart';
import 'package:moto_go/Transaction/booking_transaction.dart';
import 'package:moto_go/Transaction/my_bookings_screen.dart';
import 'package:moto_go/Menu/bike_screen.dart'; // <-- Make sure this exists

final List<Map<String, dynamic>> bikeList = [
  {'image': 'assets/bike1.PNG', 'label': 'Yamaha R15', 'price': 280},
  {'image': 'assets/bike2.PNG', 'label': 'KTM Duke 200', 'price': 240},
  {'image': 'assets/bike3.PNG', 'label': 'Suzuki Raider', 'price': 150},
  {'image': 'assets/bike4.PNG', 'label': 'Honda CBR', 'price': 300},
  {'image': 'assets/bike5.PNG', 'label': 'Kawasaki Z400', 'price': 190},
];

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

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
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                              delegate: BikeSearchDelegate(bikeList),
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
                      itemCount: bikeList.length,
                      padding: const EdgeInsets.only(left: 16),
                      itemBuilder: (context, index) {
                        final bike = bikeList[index];
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
                    itemCount: bikeList.length,
                    itemBuilder: (context, index) {
                      final bike = bikeList[index];
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

  Widget _buildBikeCard(BuildContext context, Map<String, dynamic> bike) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              bike['image'],
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bike['label'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'nunito',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${bike['price']} / Hour',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'nunito',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                BookingTransactionScreen(bike: bike)),
                      );
                    },
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPickCard(BuildContext context, Map<String, dynamic> bike) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: ListTile(
          leading: Image.asset(
            bike['image'],
            width: 80,
            fit: BoxFit.cover,
          ),
          title: Text(
            bike['label'],
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'nunito'),
          ),
          subtitle: Text('${bike['price']} / Hour',
              style: const TextStyle(color: Colors.orange)),
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BookingTransactionScreen(bike: bike)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Book'),
          ),
        ),
      ),
    );
  }
}

class BikeSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> bikeList;

  BikeSearchDelegate(this.bikeList);

  @override
  List<Widget>? buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final results = bikeList
        .where((bike) =>
        bike['label'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final bike = results[index];
        return ListTile(
          leading: Image.asset(bike['image'], width: 60),
          title: Text(bike['label']),
          subtitle: Text('${bike['price']} / Hour'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BookingTransactionScreen(bike: bike)),
            );
          },
        );
      },
    );
  }
}
