import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// 📚 Comics Reader App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comics Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// Comic model
class Comic {
  final String title;
  final String author;

  const Comic({required this.title, required this.author});
}

/// Home Page displaying comics
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Comic> comics = const [
    Comic(title: "Spider-Man: No Way Home", author: "Stan Lee"),
    Comic(title: "Batman: The Dark Knight Returns", author: "Frank Miller"),
    Comic(title: "The Flashpoint Paradox", author: "Geoff Johns"),
    Comic(title: "Avengers: Endgame Saga", author: "Jim Starlin"),
    Comic(title: "X-Men: Days of Future Past", author: "Chris Claremont"),
    Comic(title: "Iron Man: Extremis", author: "Warren Ellis"),
    Comic(title: "Guardians of the Galaxy", author: "Dan Abnett"),
    Comic(title: "Deadpool: Merc with a Mouth", author: "Daniel Way"),
    Comic(title: "Doctor Strange: The Oath", author: "Brian K. Vaughan"),
    Comic(title: "Wonder Woman: Warbringer", author: "Leigh Bardugo"),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comics Reader"),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Trending Comics 📖",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: comics.length,
                itemBuilder: (context, index) {
                  final comic = comics[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.menu_book_rounded,
                          color: Colors.deepPurpleAccent),
                      title: Text(comic.title),
                      subtitle: Text("Author: ${comic.author}"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubscribeForm(comics: comics),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite),
                label: const Text("Subscribe to a Comic"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// StatefulWidget: Subscribe Form
class SubscribeForm extends StatefulWidget {
  final List<Comic> comics;
  const SubscribeForm({super.key, required this.comics});

  @override
  State<SubscribeForm> createState() => _SubscribeFormState();
}

class _SubscribeFormState extends State<SubscribeForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedComic;
  String _confirmationMessage = "";

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _confirmationMessage =
            "📚 Subscription Confirmed!\nThank you, ${_nameController.text}!\nYou’re now subscribed to: '$_selectedComic'\nHappy reading! 🤓";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Subscribed to $_selectedComic")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comic Subscription Form"),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your email";
                  }
                  if (!value.contains("@")) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Comic",
                  border: OutlineInputBorder(),
                ),
                items: widget.comics
                    .map((comic) => DropdownMenuItem(
                          value: comic.title,
                          child: Text(comic.title),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedComic = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Please select a comic" : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitForm,
                child: const Text("Subscribe Now"),
              ),
              const SizedBox(height: 20),
              if (_confirmationMessage.isNotEmpty)
                Center(
                  child: Text(
                    _confirmationMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
