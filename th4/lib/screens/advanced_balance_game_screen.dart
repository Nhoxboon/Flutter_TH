import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AdvancedBalanceGameScreen extends StatefulWidget {
  const AdvancedBalanceGameScreen({super.key});

  @override
  State<AdvancedBalanceGameScreen> createState() =>
      _AdvancedBalanceGameScreenState();
}

class _AdvancedBalanceGameScreenState extends State<AdvancedBalanceGameScreen> {
  // Biến để lưu vị trí của quả bi
  double ballX = 50.0;
  double ballY = 50.0;

  // Biến để lưu vị trí của đích
  double targetX = 200.0;
  double targetY = 400.0;

  // Kích thước của quả bi và đích
  static const double ballSize = 40.0;
  static const double targetSize = 60.0;

  // Tốc độ và độ mượt của chuyển động
  static const double sensitivity = 6.0;
  static const double friction = 0.92;

  // Velocity để làm mượt chuyển động
  double velocityX = 0.0;
  double velocityY = 0.0;

  // Kích thước màn hình
  late double screenWidth;
  late double screenHeight;

  // Biến để theo dõi trạng thái game
  bool isGameWon = false;
  int score = 0;

  // Hệ thống thời gian
  late Stopwatch stopwatch;
  Timer? timer;
  Duration elapsedTime = Duration.zero;

  // Vật cản (walls)
  List<Rect> walls = [];

  // Điều khiển bằng con quay hồi chuyển
  bool useGyroscope = false;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    _initializeWalls();
    _startListeningToSensors();
    _startTimer();
  }

  void _initializeWalls() {
    walls = [
      // Tường ngang ở giữa
      const Rect.fromLTWH(100, 250, 200, 20),
      // Tường dọc bên trái
      const Rect.fromLTWH(50, 350, 20, 150),
      // Tường dọc bên phải
      const Rect.fromLTWH(280, 150, 20, 120),
      // Tường ngang trên
      const Rect.fromLTWH(150, 100, 150, 20),
    ];
  }

  void _startListeningToSensors() {
    if (useGyroscope) {
      gyroscopeEventStream().listen((GyroscopeEvent event) {
        if (mounted && !isGameWon) {
          setState(() {
            // Với gyroscope, chúng ta cộng dồn các giá trị
            velocityX += event.y * sensitivity; // Đảo trục cho tự nhiên
            velocityY += event.x * sensitivity;

            _updateBallPosition();
          });
        }
      });
    } else {
      accelerometerEventStream().listen((AccelerometerEvent event) {
        if (mounted && !isGameWon) {
          setState(() {
            // Cập nhật velocity dựa trên dữ liệu gia tốc kế
            velocityX += event.x * sensitivity;
            velocityY -= event.y * sensitivity; // Đảo ngược trục Y

            _updateBallPosition();
          });
        }
      });
    }
  }

  void _updateBallPosition() {
    // Áp dụng friction để làm mượt
    velocityX *= friction;
    velocityY *= friction;

    // Tính vị trí mới
    double newX = ballX + velocityX;
    double newY = ballY + velocityY;

    // Kiểm tra va chạm với tường
    Rect ballRect = Rect.fromLTWH(newX, newY, ballSize, ballSize);

    bool hitWall = false;
    for (Rect wall in walls) {
      if (ballRect.overlaps(wall)) {
        hitWall = true;

        // Xác định hướng va chạm và phản hồi
        double overlapLeft = ballRect.right - wall.left;
        double overlapRight = wall.right - ballRect.left;
        double overlapTop = ballRect.bottom - wall.top;
        double overlapBottom = wall.bottom - ballRect.top;

        // Tìm overlap nhỏ nhất để xác định hướng va chạm chính
        double minOverlap = [
          overlapLeft,
          overlapRight,
          overlapTop,
          overlapBottom,
        ].reduce(min);

        if (minOverlap == overlapLeft || minOverlap == overlapRight) {
          // Va chạm ngang
          velocityX = -velocityX * 0.7; // Giảm tốc độ khi va chạm
          newX = ballX; // Không di chuyển theo trục X
        } else {
          // Va chạm dọc
          velocityY = -velocityY * 0.7; // Giảm tốc độ khi va chạm
          newY = ballY; // Không di chuyển theo trục Y
        }
        break;
      }
    }

    if (!hitWall) {
      ballX = newX;
      ballY = newY;
    }

    // Giới hạn quả bi không ra khỏi màn hình
    _constrainBallPosition();

    // Kiểm tra điều kiện thắng
    _checkWinCondition();
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
    if (ballY > screenHeight - ballSize - 100) {
      // Trừ AppBar
      ballY = screenHeight - ballSize - 100;
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
    stopwatch.stop();
    setState(() {
      isGameWon = true;
      score++;
    });

    // Hiển thị thông báo chiến thắng
    _showWinDialog();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && !isGameWon) {
        setState(() {
          elapsedTime = stopwatch.elapsed;
        });
      }
    });
  }

  void _showWinDialog() {
    String timeString = _formatDuration(elapsedTime);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🏆 Xuất sắc!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hoàn thành trong: $timeString'),
              Text('Điểm số: $score'),
              const SizedBox(height: 10),
              Text(
                useGyroscope
                    ? '🔄 Đang dùng Con quay hồi chuyển'
                    : '📱 Đang dùng Gia tốc kế',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextLevel();
              },
              child: const Text('Tiếp tục'),
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

      // Tạo vị trí ngẫu nhiên cho đích mới (tránh vật cản)
      _generateNewTarget();

      // Đặt lại vị trí quả bi
      ballX = 50.0;
      ballY = 50.0;

      // Reset và bắt đầu đếm thời gian mới
      stopwatch.reset();
      stopwatch.start();
    });
  }

  void _generateNewTarget() {
    final random = Random();
    bool validPosition = false;

    while (!validPosition) {
      targetX = random.nextDouble() * (screenWidth - targetSize);
      targetY = random.nextDouble() * (screenHeight - targetSize - 100);

      Rect targetRect = Rect.fromLTWH(targetX, targetY, targetSize, targetSize);

      // Kiểm tra xem đích có va chạm với tường không
      validPosition = !walls.any((wall) => targetRect.overlaps(wall));

      // Đảm bảo đích không quá gần quả bi
      double distance = sqrt(pow(targetX - ballX, 2) + pow(targetY - ballY, 2));
      if (distance < 100) {
        validPosition = false;
      }
    }
  }

  void _resetGame() {
    setState(() {
      isGameWon = false;
      score = 0;
      velocityX = 0;
      velocityY = 0;

      // Đặt lại vị trí ban đầu
      ballX = 50.0;
      ballY = 50.0;
      targetX = 200.0;
      targetY = 400.0;

      // Reset thời gian
      stopwatch.reset();
      stopwatch.start();
      elapsedTime = Duration.zero;
    });
  }

  void _toggleControlMethod() {
    setState(() {
      useGyroscope = !useGyroscope;
      velocityX = 0;
      velocityY = 0;
    });

    // Restart listening với phương thức mới
    _startListeningToSensors();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          useGyroscope
              ? 'Chuyển sang điều khiển bằng Con quay hồi chuyển'
              : 'Chuyển sang điều khiển bằng Gia tốc kế',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 100)
        .toString();
    return "$minutes:$seconds.$milliseconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('🎯 Game Lăn Bi Nâng Cao'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _toggleControlMethod,
            icon: Icon(useGyroscope ? Icons.sync : Icons.phone_android),
            tooltip: 'Đổi điều khiển',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Điểm: $score',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDuration(elapsedTime),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Game instructions
          if (score == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        useGyroscope
                            ? '🔄 Xoay điện thoại'
                            : '📱 Nghiêng điện thoại',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' | Tránh tường đen!',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Game area
          Expanded(
            child: Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.purple[50]!, Colors.purple[100]!],
                    ),
                  ),
                ),

                // Vẽ các bức tường
                ...walls.map(
                  (wall) => Positioned(
                    left: wall.left,
                    top: wall.top,
                    child: Container(
                      width: wall.width,
                      height: wall.height,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
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
                      border: Border.all(color: Colors.grey[600]!, width: 3),
                      color: Colors.grey[300],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.3),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 20)),
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
                        colors: [Colors.lightBlue[300]!, Colors.blue[800]!],
                        stops: const [0.2, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(3, 5),
                        ),
                      ],
                    ),
                  ),
                ),

                // Control buttons
                Positioned(
                  bottom: 10,
                  left: 20,
                  right: 20,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton.small(
                          heroTag: "reset",
                          onPressed: _resetGame,
                          backgroundColor: Colors.orange,
                          child: const Icon(Icons.refresh, color: Colors.white),
                        ),
                        FloatingActionButton.small(
                          heroTag: "control",
                          onPressed: _toggleControlMethod,
                          backgroundColor: Colors.teal,
                          child: Icon(
                            useGyroscope ? Icons.sync : Icons.phone_android,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
