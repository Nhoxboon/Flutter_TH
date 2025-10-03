import 'package:flutter/material.dart';

class GradientButtonsScreen extends StatelessWidget {
  const GradientButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF1976D2,
        ), // Blue color matching the image
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Gradient Buttons",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Button 1 - Green gradient
            _buildGradientButton(
              text: "Click me 1",
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2E7D32), // Dark forest green
                  Color(0xFF4CAF50), // Light teal-green
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () => _showSnackBar(context, "Button 1 clicked!"),
            ),

            const SizedBox(height: 20),

            // Button 2 - Orange-red gradient
            _buildGradientButton(
              text: "Click me 2",
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD84315), // Reddish-orange
                  Color(0xFFFF9800), // Bright orange
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () => _showSnackBar(context, "Button 2 clicked!"),
            ),

            const SizedBox(height: 20),

            // Button 3 - Blue gradient
            _buildGradientButton(
              text: "Click me 3",
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1976D2), // Medium blue
                  Color(0xFF03A9F4), // Sky blue
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () => _showSnackBar(context, "Button 3 clicked!"),
            ),

            const SizedBox(height: 20),

            // Button 4 - Grayscale gradient
            _buildGradientButton(
              text: "Click me 4",
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF424242), // Dark charcoal gray
                  Color(0xFF9E9E9E), // Light gray
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () => _showSnackBar(context, "Button 4 clicked!"),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required LinearGradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30), // Fully rounded ends
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1976D2),
      ),
    );
  }
}
