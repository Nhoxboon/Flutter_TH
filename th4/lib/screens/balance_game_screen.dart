import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BalanceGameScreen extends StatefulWidget {
  const BalanceGameScreen({super.key});

  @override
  State<BalanceGameScreen> createState() => _BalanceGameScreenState();
}

class _BalanceGameScreenState extends State<BalanceGameScreen> {
  // Biến để lưu vị trí của quả bi
  double ballX = 100.0;
  double ballY = 100.0;

  // Biến để lưu vị trí của đích
  double targetX = 200.0;
  double targetY = 400.0;

  // Kích thước của quả bi và đích
  static const double ballSize = 50.0;
  static const double targetSize = 60.0;

  // Tốc độ và độ mượt của chuyển động
  static const double sensitivity = 8.0;
  static const double friction = 0.95;

  // Velocity để làm mượt chuyển động
  double velocityX = 0.0;
  double velocityY = 0.0;

  // Kích thước màn hình
  late double screenWidth;
  late double screenHeight;

  // Biến để theo dõi trạng thái game
  bool isGameWon = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _startListeningToAccelerometer();
  }

  void _startListeningToAccelerometer() {
    accelerometerEventStream().listen((AccelerometerEvent event) {
      if (mounted && !isGameWon) {
        setState(() {
          // Cập nhật velocity dựa trên dữ liệu gia tốc kế
          velocityX += event.x * sensitivity;
          velocityY -=
              event.y * sensitivity; // Đảo ngược trục Y để tự nhiên hơn

          // Áp dụng friction để làm mượt
          velocityX *= friction;
          velocityY *= friction;

          // Cập nhật vị trí quả bi
          ballX += velocityX;
          ballY += velocityY;

          // Giới hạn quả bi không ra khỏi màn hình
          _constrainBallPosition();

          // Kiểm tra điều kiện thắng
          _checkWinCondition();
        });
      }
    });
  }

  void _constrainBallPosition() {
    if (ballX < 0) {
      ballX = 0;
      velocityX = 0;
    }
    if (ballX > screenWidth - ballSize) {
      ballX = screenWidth - ballSize;
      velocityX = 0;
    }
    if (ballY < 0) {
      ballY = 0;
      velocityY = 0;
    }
    if (ballY > screenHeight - ballSize) {
      ballY = screenHeight - ballSize;
      velocityY = 0;
    }
  }

  void _checkWinCondition() {
    // Tính khoảng cách giữa tâm quả bi và tâm đích
    double ballCenterX = ballX + ballSize / 2;
    double ballCenterY = ballY + ballSize / 2;
    double targetCenterX = targetX + targetSize / 2;
    double targetCenterY = targetY + targetSize / 2;

    double distance = sqrt(
      pow(ballCenterX - targetCenterX, 2) + pow(ballCenterY - targetCenterY, 2),
    );

    // Kiểm tra va chạm (tổng bán kính)
    double collisionDistance = (ballSize + targetSize) / 2;

    if (distance < collisionDistance) {
      _onWin();
    }
  }

  void _onWin() {
    setState(() {
      isGameWon = true;
      score++;
    });

    // Hiển thị thông báo chiến thắng
    _showWinDialog();
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Chúc mừng!'),
          content: Text('Bạn đã hoàn thành thử thách!\nĐiểm số: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextLevel();
              },
              child: const Text('Chơi tiếp'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Chơi lại'),
            ),
          ],
        );
      },
    );
  }

  void _nextLevel() {
    setState(() {
      isGameWon = false;
      velocityX = 0;
      velocityY = 0;

      // Tạo vị trí ngẫu nhiên cho đích mới
      final random = Random();
      targetX = random.nextDouble() * (screenWidth - targetSize);
      targetY = random.nextDouble() * (screenHeight - targetSize);

      // Đặt lại vị trí quả bi ở giữa màn hình
      ballX = screenWidth / 2 - ballSize / 2;
      ballY = screenHeight / 2 - ballSize / 2;
    });
  }

  void _resetGame() {
    setState(() {
      isGameWon = false;
      score = 0;
      velocityX = 0;
      velocityY = 0;

      // Đặt lại vị trí ban đầu
      ballX = 100.0;
      ballY = 100.0;
      targetX = 200.0;
      targetY = 400.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('🎯 Game Lăn Bi'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Điểm: $score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Game instructions (chỉ hiện khi bắt đầu game)
          if (score == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '📱 Nghiêng điện thoại để điều khiển quả bi xanh đến vùng đích xám!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),

          // Game area
          Expanded(
            child: Stack(
              children: [
                // Background pattern
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue[50]!, Colors.blue[100]!],
                    ),
                  ),
                ),

                // Đích (Target)
                Positioned(
                  left: targetX,
                  top: targetY,
                  child: Container(
                    width: targetSize,
                    height: targetSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[600]!, width: 4),
                      color: Colors.grey[300],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),

                // Quả bi (Ball)
                Positioned(
                  left: ballX,
                  top: ballY,
                  child: Container(
                    width: ballSize,
                    height: ballSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.lightBlue[300]!, Colors.blue[700]!],
                        stops: const [0.3, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reset button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: _resetGame,
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
