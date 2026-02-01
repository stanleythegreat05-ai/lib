import 'package:flutter/material.dart';
import 'package:remote_demo/repository/user_repository.dart';
import 'model/user.dart';

void main() => runApp(const DirectoryApp());

class DirectoryApp extends StatelessWidget {
  const DirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
      ),
      home: const UserDirectoryScreen(),
    );
  }
}

class UserDirectoryScreen extends StatefulWidget {
  const UserDirectoryScreen({super.key});

  @override
  UserDirectoryState createState() => UserDirectoryState();
}

class UserDirectoryState extends State<UserDirectoryScreen> {
  final UserRepository _repo = UserRepository();
  late Future<List<User>> _userList;

  @override
  void initState() {
    super.initState();
    _userList = _repo.fetchUsers();
  }

  void _handleDelete(int id, String name) async {
    bool success = await _repo.removeUser(id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account for $name removed from cloud")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Directory"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<User>>(
        future: _userList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Connection Error: ${snapshot.error}"));
          }

          final users = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              return Dismissible(
                key: Key(user.id.toString()),
                background: Container(color: Colors.red, alignment: Alignment.centerRight, child: const Icon(Icons.delete)),
                onDismissed: (direction) => _handleDelete(user.id, user.name),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(child: Text(user.name[0])),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.email.toLowerCase()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () { /* Navigate to details */ },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() { _userList = _repo.fetchUsers(); }),
        label: const Text("Sync Data"),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}