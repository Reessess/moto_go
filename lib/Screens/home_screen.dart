import 'package:flutter/material.dart';
import 'package:moto_go/Transaction/booking_screen.dart';
import 'package:moto_go/Menu/setting_screen.dart';
import 'package:moto_go/Menu/profile_screen.dart';
import 'package:moto_go/Menu/my_bookings.dart';

final List<Map<String, dynamic>> bikeList = [
  {'image': 'assets/bike1.PNG', 'label': 'Yamaha R15', 'price': 280},
  {'image': 'assets/bike2.PNG', 'label': 'KTM Duke 200', 'price': 240},
  {'image': 'assets/bike3.PNG', 'label': 'Suzuki Raider', 'price': 150},
  {'image': 'assets/bike4.PNG', 'label': 'Honda CBR', 'price': 300},
  {'image': 'assets/bike5.PNG', 'label': 'Kawasaki Z400', 'price': 190},
];

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

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
                    Image.asset(
                      'assets/Icon.PNG',  // your image path here
                      height: 60,
                      // optional: width: 60,
                      // optional: fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'MotoGO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'nunito',
                      ),
                    ),
                  ],
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Ride History'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to Ride History screen
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment Methods'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to Payment Methods screen
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text('My Bookings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyBooking()),
                    );
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingScreen()),
                    );
                  },
                ),
              ),
              _buildMenuTile(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.orange),
                  title: const Text('Logout', style: TextStyle(color: Colors.orange)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement logout functionality
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black, size: 28),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black, size: 28),
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
                  physics: const ClampingScrollPhysics(),
                  itemCount: bikeList.length,
                  padding: const EdgeInsets.only(left: 16),
                  itemBuilder: (context, index) {
                    final bike = bikeList[index];
                    return _buildBikeCard(context, bike, key: ValueKey(bike['label']));
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
                  return _buildTopPickCard(context, bike, key: ValueKey('top_${bike['label']}'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBikeCard(BuildContext context, Map<String, dynamic> bike, {Key? key}) {
    return Container(
      key: key,
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4)),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    '₱${bike['price']}/Hour',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookingScreen(bike: bike)),
                      );
                    },
                    child: const Text('Rent Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPickCard(BuildContext context, Map<String, dynamic> bike, {Key? key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              bike['image'],
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bike['label'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'nunito',
                  ),
                ),
                Text(
                  '₱${bike['price']}/Hour',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingScreen(bike: bike)),
              );
            },
            child: const Text('Rent Now'),
          ),
        ],
      ),
    );
  }
}

class BikeSearchDelegate extends SearchDelegate<Map<String, dynamic>> {
  final List<Map<String, dynamic>> bikes;

  BikeSearchDelegate(this.bikes);

  @override
  String get searchFieldLabel => 'Search bikes';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, {});
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = bikes.where((bike) =>
        bike['label'].toString().toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results.map((bike) {
        return ListTile(
          leading: Image.asset(bike['image'], width: 50),
          title: Text(bike['label']),
          subtitle: Text('₱${bike['price']}/Hour'),
          onTap: () {
            close(context, bike);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = bikes.where((bike) =>
        bike['label'].toString().toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: suggestions.map((bike) {
        return ListTile(
          leading: Image.asset(bike['image'], width: 50),
          title: Text(bike['label']),
          subtitle: Text('₱${bike['price']}/Hour'),
          onTap: () {
            query = bike['label'];
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}
