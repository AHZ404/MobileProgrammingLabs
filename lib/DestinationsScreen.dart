import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class Destination {
  final String name;
  final String capital;
  final String region;
  final int population;
  final String flagUrl;

  Destination({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    final String capitalValue =
    json['capital'] != null && (json['capital'] as String).isNotEmpty
        ? json['capital']
        : 'N/A';

    final String alpha2Code = (json['alpha2Code'] as String? ?? '').toLowerCase();

    // Generates a direct URL to the flag PNG image
    final String flagUrl = alpha2Code.isNotEmpty
        ? 'https://flagcdn.com/w80/$alpha2Code.png'
        : '';

    return Destination(
      name: json['name'] ?? '',
      capital: capitalValue,
      region: json['region'] ?? '',
      population: json['population'] ?? 0,
      flagUrl: flagUrl,
    );
  }
}

// Destinations Screen
class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  List<Destination> destinations = [];

  @override
  void initState() {
    super.initState();
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    try {
      final response = await Dio().get(
        'https://countries.dev/countries?fields=name,capital,region,population,alpha2Code',
      );

      final List rawData = response.data as List;
      final List<Destination> loadedDestinations = rawData.map((item) {
        return Destination.fromJson(item as Map<String, dynamic>);
      }).toList();

      setState(() {
        destinations = loadedDestinations;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> openGoogleSearch(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final Uri url = Uri.parse('https://www.google.com/search?q=$encodedQuery');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Explore Destinations'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: destinations.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final destination = destinations[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: destination.flagUrl.isNotEmpty
                      ? Image.network(
                    destination.flagUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                        ),
                  )
                      : Icon(
                    Icons.location_on,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: Text(
                  destination.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Capital: ${destination.capital} | Region: ${destination.region} | Pop: ${destination.population}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  openGoogleSearch(destination.name);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}