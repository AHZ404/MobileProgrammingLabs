import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  final String name;

  const WelcomeScreen({
    super.key,
    required this.name,
  });

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final List<Map<String, String>> travelStyles = const [
    {'label': 'Backpacking', 'emoji': '🎒'},
    {'label': 'Luxury Travel', 'emoji': '🏨'},
    {'label': 'Cultural & History', 'emoji': '🏛️'},
    {'label': 'Nature & Adventure', 'emoji': '🏕️'},
    {'label': 'Beach Getaway', 'emoji': '🏖️'},
    {'label': 'Culinary Tours', 'emoji': '🍕'},
    {'label': 'Road Trips', 'emoji': '🚗'},
    {'label': 'Solo Travel', 'emoji': '🧳'},
  ];

  final Set<String> selectedStyles = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, ${widget.name}!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'What are your travel styles? Select from below.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),

            Wrap(
              spacing: 10.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center,
              children: travelStyles.map((style) {
                final label = style['label']!;
                final emoji = style['emoji']!;
                final isSelected = selectedStyles.contains(label);

                return FilterChip(
                  label: Text('$emoji  $label'),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedStyles.add(label);
                      } else {
                        selectedStyles.remove(label);
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  selectedColor: theme.colorScheme.primaryContainer,
                  checkmarkColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.go('/destinations');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Explore Destinations'),
            ),
          ],
        ),
      ),
    );
  }
}