import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Zawodnik {
  String imie;
  int wiek;
  int staz;
  bool badania;
  bool licencja;

  Zawodnik(this.imie, this.wiek, this.staz, this.badania, this.licencja);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klub Sportowy',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Zawodnik> zawodnicy = [];

  void dodajZawodnika() {
    showDialog(
      context: context,
      builder: (context) {
        final imieController = TextEditingController();
        final wiekController = TextEditingController();
        final stazController = TextEditingController();
        bool badania = false;
        bool licencja = false;

        return AlertDialog(
          title: Text("Nowy zawodnik"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: imieController,
                  decoration: InputDecoration(labelText: "Imię"),
                ),
                TextField(
                  controller: wiekController,
                  decoration: InputDecoration(labelText: "Wiek"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stazController,
                  decoration: InputDecoration(labelText: "Staż"),
                  keyboardType: TextInputType.number,
                ),
                CheckboxListTile(
                  title: Text("Badania aktualne"),
                  value: badania,
                  onChanged: (val) {
                    setState(() {
                      badania = val ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Licencja opłacona"),
                  value: licencja,
                  onChanged: (val) {
                    setState(() {
                      licencja = val ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Anuluj"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Dodaj"),
              onPressed: () {
                setState(() {
                  zawodnicy.add(
                    Zawodnik(
                      imieController.text,
                      int.tryParse(wiekController.text) ?? 0,
                      int.tryParse(stazController.text) ?? 0,
                      badania,
                      licencja,
                    ),
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Zawodnicy")),
      body: ListView.builder(
        itemCount: zawodnicy.length,
        itemBuilder: (context, index) {
          final z = zawodnicy[index];
          return ListTile(
            title: Text(z.imie),
            subtitle: Text("Wiek: ${z.wiek}, Staż: ${z.staz} lat"),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(z.badania ? "Badania ✅" : "Badania ❌"),
                Text(z.licencja ? "Licencja ✅" : "Licencja ❌"),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dodajZawodnika,
        child: Icon(Icons.add),
      ),
    );
  }
}
