import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moto_go/providers/bike_provider.dart';

class BikesScreen extends StatefulWidget {
  const BikesScreen({super.key});

  @override
  State<BikesScreen> createState() => _BikesScreenState();
}

class _BikesScreenState extends State<BikesScreen> {
  String selectedBrand = '';
  double? maxPrice;

  @override
  void initState() {
    super.initState();
    Provider.of<BikeProvider>(context, listen: false).fetchBikes();
  }

  void applyFilters() {
    Provider.of<BikeProvider>(context, listen: false).fetchBikes(
      brand: selectedBrand,
      maxPrice: maxPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bikes = Provider.of<BikeProvider>(context).bikes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Bikes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => filterSheet(),
              );
            },
          )
        ],
      ),
      body: bikes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: bikes.length,
        itemBuilder: (context, index) {
          final bike = bikes[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(bike.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              title: Text('${bike.brand} ${bike.model}'),
              subtitle: Text('₱${bike.pricePerDay}/day\n${bike.status}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  Widget filterSheet() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Brand'),
            onChanged: (value) {
              selectedBrand = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Max Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              maxPrice = double.tryParse(value);
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              applyFilters();
            },
            child: const Text('Apply Filters'),
          )
        ],
      ),
    );
  }
}
