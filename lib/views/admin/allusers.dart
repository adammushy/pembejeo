import 'package:flutter/material.dart';
import 'package:pembejeo/providers/user_management_provider.dart';
import 'package:provider/provider.dart';
// import 'package:your_project/providers/user_management_provider.dart';

class AllUsersScreen extends StatefulWidget {
  AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserManagementProvider>(context, listen: false).fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: Consumer<UserManagementProvider>(
        builder: (context, userManagementProvider, child) {
          if (userManagementProvider.allUsers.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: userManagementProvider.allUsers.map((user) {
                  String roleName = '';
                  switch (user['usertype']) {
                    case 'NORMAL':
                      roleName = 'User';
                      break;
                    case 'ADMIN':
                      roleName = 'Admin';
                      break;
                    // Add other roles if needed
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(user['firstname'] ?? '')),
                      DataCell(Text(user['email'] ?? '')),
                      DataCell(Text(user['phone'] ?? '')),
                      DataCell(Text(roleName)),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Add your delete functionality here
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
