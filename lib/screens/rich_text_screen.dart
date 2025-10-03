import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RichTextScreen extends StatelessWidget {
  const RichTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RichText', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // First "Hello World" with different colors
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello ',
                    style: TextStyle(
                      color: Color(0xFF20B2AA), // Teal color
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'World',
                    style: TextStyle(
                      color: Color(0xFF8A2BE2), // Purple color
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Second "Hello World" with emoji
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello World ',
                    style: TextStyle(
                      color: Color(0xFF20B2AA), // Teal color
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '👋', style: TextStyle(fontSize: 28)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Contact me section
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Contact me via: ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const TextSpan(text: '✉️ ', style: TextStyle(fontSize: 16)),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _launchEmail(),
                      child: const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Call me section
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Call Me: ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _launchPhone(),
                      child: const Text(
                        '+1234987654321',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Blog section
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Read My Blog ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _launchBlog(),
                      child: const Text(
                        'HERE',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: 'contact@example.com');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+1234987654321');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchBlog() async {
    final Uri blogUri = Uri.parse('https://example.com/blog');
    if (await canLaunchUrl(blogUri)) {
      await launchUrl(blogUri);
    }
  }
}
