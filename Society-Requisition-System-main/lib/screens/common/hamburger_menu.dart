import 'package:flutter/material.dart';
import '/models/user.dart';
import '../../services/auth_service.dart';
import 'package:flutter/services.dart';

class HamburgerMenu extends StatelessWidget {
  final User user;

  const HamburgerMenu({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isNetworkImage = user.profilePictureUrl.startsWith('http');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF00D09E)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Aligns avatar and text vertically
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: isNetworkImage
                      ? NetworkImage(user.profilePictureUrl)
                      : AssetImage(user.profilePictureUrl) as ImageProvider,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min, // Prevents extra vertical space
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.designation,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () => showDeveloperContactDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => AuthService.logoutUser(context),
          ),
        ],
      ),
    );
  }
}

void showDeveloperContactDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Developer Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Email: support@societysync.com')),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy Email',
                onPressed: () {
                  Clipboard.setData(
                    const ClipboardData(text: 'talhaimran207@gmail.com'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email copied!')),
                  );
                },
              ),
            ],
          ),

          Row(
            children: [
              const Expanded(child: Text('Phone: 0300-DEVNEXA')),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy Phone',
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: '+923003386392'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phone number copied!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
