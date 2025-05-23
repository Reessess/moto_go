import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moto_go/Model/bike.dart';
import 'package:moto_go/Screens/bike_details_screen.dart';

class BikeSearchScreen extends StatefulWidget {
  const BikeSearchScreen({Key? key}) : super(key: key);

  @override
  _BikeSearchScreenState createState() => _BikeSearchScreenState();
}

class _BikeSearchScreenState extends State<BikeSearchScreen> {
  List<Bikes> _allBikes = [];
  List<Bikes> _filteredBikes = [];
  bool _isLoading = true;
  String _error = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBikes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchBikes() async {
    try {
      final response =
      await http.get(Uri.parse('http://192.168.5.129:3000/api/bikes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allBikes = data.map((json) => Bikes.fromJson(json)).toList();
          _filteredBikes = _allBikes;
          _isLoading = false;
          _error = '';
        });
      } else {
        setState(() {
          _error = 'Failed to load bikes: ${response.statusCode}';
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

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBikes = _allBikes.where((bike) {
        final brandLower = bike.brand.toLowerCase();
        final modelLower = bike.model.toLowerCase();
        return brandLower.contains(query) || modelLower.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Bikes'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by brand or model',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredBikes.isEmpty
                ? const Center(child: Text('No bikes found'))
                : ListView.builder(
              itemCount: _filteredBikes.length,
              itemBuilder: (context, index) {
                final bike = _filteredBikes[index];
                return ListTile(
                  leading: Image.network(
                    bike.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey),
                  ),
                  title: Text(bike.brand),
                  subtitle: Text(bike.model),
                  trailing: Text(
                    '\$${bike.pricePerHour.toStringAsFixed(2)}/hr',
                    style: const TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BikeDetailsScreen(bike: bike),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
