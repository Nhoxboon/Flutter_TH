import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomRichTextScreen extends StatelessWidget {
  const CustomRichTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Custom Rich Text Example',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Flutter ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // First paragraph about Flutter
                  const TextSpan(
                    text:
                        'is an open-source UI software development kit created by Google. It is used to develop cross platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. First described in 2015, ',
                  ),
                  const TextSpan(
                    text: 'Flutter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const TextSpan(text: ' was released in May 2017.\n\n'),

                  // Contact information
                  const TextSpan(text: 'Contact on '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _launchPhone(),
                      child: const Text(
                        '+910000210056',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '. Our email address is '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _launchEmail(),
                      child: const Text(
                        'test@exampleemail.org',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '.\n\n'),

                  // More details link
                  const TextSpan(text: 'For more details check '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _launchWebsite(),
                      child: const Text(
                        'https://www.google.com',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '\n\n'),

                  // Read less action
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        // Handle read less action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Read less clicked')),
                        );
                      },
                      child: const Text(
                        'Read less',
                        style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: 'test@exampleemail.org');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+910000210056');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchWebsite() async {
    final Uri websiteUri = Uri.parse('https://www.google.com');
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri);
    }
  }
}
