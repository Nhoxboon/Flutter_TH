import 'package:flutter/material.dart';
import 'balance_game_screen.dart';
import 'advanced_balance_game_screen.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[400]!, Colors.purple[600]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Title
              const Text(
                '🎯 Game Lăn Bi',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              const Text(
                'Điều khiển quả bi bằng cảm biến điện thoại!',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 80),

              // Game mode buttons
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Chọn chế độ chơi',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Basic Game Button
                          _buildGameModeCard(
                            context,
                            title: '🎯 Chế độ Cơ bản',
                            description:
                                'Game đơn giản với điều khiển gia tốc kế\nPhù hợp cho người mới bắt đầu',
                            color: Colors.blue,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BalanceGameScreen(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Advanced Game Button
                          _buildGameModeCard(
                            context,
                            title: '🏆 Chế độ Nâng cao',
                            description:
                                'Game có vật cản, đếm thời gian\nHỗ trợ cả gia tốc kế và con quay hồi chuyển',
                            color: Colors.purple,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdvancedBalanceGameScreen(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Instructions
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  '📖 Hướng dẫn chơi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Nghiêng điện thoại để điều khiển quả bi xanh\n'
                                  '• Đưa quả bi đến vùng đích màu xám\n'
                                  '• Tránh va chạm với các vật cản (chế độ nâng cao)\n'
                                  '• Hoàn thành càng nhanh càng tốt!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: color.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.lerp(color, Colors.black, 0.3),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color.lerp(color, Colors.black, 0.2),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
