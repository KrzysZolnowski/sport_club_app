import 'package:flutter/material.dart';
import '../models/player.dart';
import '../screens/add_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Player> players = [];

  void _addPlayer(Player player) {
    setState(() {
      players.add(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zawodnicy klubu')),
      body: players.isEmpty
          ? const Center(child: Text('Brak zawodników.'))
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  title: Text(player.name),
                  subtitle: Text(
                    'Wiek: ${player.age}, Staż: ${player.yearsInClub} lat',
                  ),
                  trailing: Icon(
                    player.hasValidLicense ? Icons.check_circle : Icons.cancel,
                    color: player.hasValidLicense ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPlayer = await Navigator.pushNamed(context, '/addPlayer');
          if (newPlayer is Player) {
            _addPlayer(newPlayer);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
