import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moto_go/providers/bike_provider.dart';

class BikesScreen extends StatefulWidget {
  const BikesScreen({super.key});

  @override
  State<BikesScreen> createState() => _BikesScreenState();
}

class _BikesScreenState extends State<BikesScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<BikeProvider>(context).fetchBikes().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  void refreshBikes() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<BikeProvider>(context, listen: false).fetchBikes().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bikes = Provider.of<BikeProvider>(context).bikes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Bikes"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: BikeSearchDelegate(
                        Provider.of<BikeProvider>(context, listen: false).bikes),
                  );
                },
              ),
            ),
          ),
          // Removed filter IconButton here
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : bikes.isEmpty
          ? const Center(child: Text("No bikes found."))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bikes.length,
              itemBuilder: (context, index) {
                final bike = bikes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        bike.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('${bike.brand} ${bike.model}'),
                    subtitle:
                    Text('₱${bike.pricePerHour}/day\n${bike.status}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: refreshBikes,
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
            ),
          ),
        ],
      ),
    );
  }
}

// The BikeSearchDelegate class remains unchanged
class BikeSearchDelegate extends SearchDelegate {
  final List<Bike> bikes;

  BikeSearchDelegate(this.bikes);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Please enter a search term.'));
    }

    final searchTerm = query.toLowerCase();
    final results = bikes.where((bike) {
      final fullName = '${bike.brand} ${bike.model}'.toLowerCase();
      return bike.brand.toLowerCase().contains(searchTerm) ||
          bike.model.toLowerCase().contains(searchTerm) ||
          fullName.contains(searchTerm);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No matching bikes found."));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final bike = results[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                bike.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('${bike.brand} ${bike.model}'),
            subtitle: Text('₱${bike.pricePerHour}/day\n${bike.status}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      final suggestions = bikes;
      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final bike = suggestions[index];
          return ListTile(
            title: Text('${bike.brand} ${bike.model}'),
            onTap: () {
              query = '${bike.brand} ${bike.model}';
              showResults(context);
            },
          );
        },
      );
    }

    final searchTerm = query.toLowerCase();

    final suggestions = bikes.where((bike) {
      final fullName = '${bike.brand} ${bike.model}'.toLowerCase();
      return bike.brand.toLowerCase().contains(searchTerm) ||
          bike.model.toLowerCase().contains(searchTerm) ||
          fullName.contains(searchTerm);
    }).toList();

    if (suggestions.isEmpty) {
      return const Center(child: Text("No matching bikes found."));
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final bike = suggestions[index];
        return ListTile(
          title: Text('${bike.brand} ${bike.model}'),
          onTap: () {
            query = '${bike.brand} ${bike.model}';
            showResults(context);
          },
        );
      },
    );
  }
}
