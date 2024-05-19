import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:estate_ease/data/property.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:estate_ease/Screens/selling_screen.dart';

final FirebaseAuth _firebase = FirebaseAuth.instance;

class PropertyListScreen extends StatefulWidget {
  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  late Future<List<Property>> futureProperties;
  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureProperties = fetchProperties();
  }

  Future<List<Property>> fetchProperties() async {
    final response = await http.get(
      Uri.parse(
          'https://realestate-project-6mri.onrender.com/api/v1/selling/property/all?page=1&size=12'),
    );

    if (response.statusCode == 200) {
      return parseProperties(response.body);
    } else {
      throw Exception('Failed to load properties');
    }
  }

  void _signOut() async {
    await _firebase.signOut();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) => PropertyListScreen()),
        ),
      );
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: ((context) => SellingScreen()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Property>>(
        future: futureProperties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load properties'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No properties available'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PropertyCard(property: snapshot.data![index]);
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Buy'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({required this.property, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(property.imagesUrl.isNotEmpty
              ? property.imagesUrl[0]
              : 'https://via.placeholder.com/150'),
          Row(
            children: [
              ListTile(
                title: Text(property.title),
                subtitle: Text('${property.price} Rs'),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Buy',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              property.description,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
