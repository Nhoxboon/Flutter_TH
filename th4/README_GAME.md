# Game Lăn Bi - Balance Ball Game 🎯

Một mini-game sử dụng cảm biến điện thoại để điều khiển quả bi lăn đến đích.

## Tổng quan

Game này được phát triển bằng Flutter và sử dụng các cảm biến của điện thoại (gia tốc kế và con quay hồi chuyển) để tạo ra trải nghiệm chơi game độc đáo thông qua chuyển động vật lý.

## Tính năng

### 🎯 Chế độ Cơ bản
- Điều khiển quả bi bằng gia tốc kế
- Giao diện đơn giản, dễ chơi
- Hệ thống điểm số cơ bản
- Vị trí đích ngẫu nhiên sau mỗi lần thắng

### 🏆 Chế độ Nâng cao
- Hỗ trợ cả gia tốc kế và con quay hồi chuyển
- Vật cản (tường đen) tạo độ khó
- Hệ thống đếm thời gian chính xác
- Phát hiện va chạm với vật cản
- Có thể chuyển đổi phương thức điều khiển trong game

## Cách chơi

1. **Khởi động game**: Chọn chế độ chơi từ menu chính
2. **Điều khiển**: 
   - Nghiêng điện thoại để di chuyển quả bi xanh
   - Mục tiêu: đưa quả bi đến vùng đích màu xám
3. **Thắng**: Khi quả bi chạm vào đích, bạn sẽ thấy thông báo chiến thắng
4. **Tiếp tục**: Chọn "Tiếp tục" để chơi level mới với đích ở vị trí khác

## Cài đặt và Chạy

### Yêu cầu hệ thống
- Flutter SDK (phiên bản 3.9.2 trở lên)
- Dart SDK
- Android Studio / VS Code với Flutter plugin
- Thiết bị có cảm biến gia tốc kế (điện thoại thông minh)

### Các bước cài đặt

1. **Clone dự án**:
   ```bash
   git clone [repository-url]
   cd th4
   ```

2. **Cài đặt dependencies**:
   ```bash
   flutter pub get
   ```

3. **Chạy trên thiết bị**:
   ```bash
   # Chạy trên điện thoại Android/iOS (khuyến nghị)
   flutter run
   
   # Chạy trên web (cảm biến có thể không hoạt động)
   flutter run -d chrome
   ```

### Lưu ý quan trọng
- **Cảm biến**: Game cần thiết bị có cảm biến gia tốc kế và con quay hồi chuyển để hoạt động tối ưu
- **Nền tảng**: Hoạt động tốt nhất trên điện thoại thật, có thể không hoạt động trên emulator
- **Web**: Trên web browser, cảm biến có thể không có sẵn

## Cấu trúc dự án

```
lib/
├── main.dart                          # Entry point
└── screens/
    ├── game_menu_screen.dart          # Menu chính
    ├── balance_game_screen.dart       # Game cơ bản
    └── advanced_balance_game_screen.dart  # Game nâng cao
```

## Công nghệ sử dụng

- **Flutter**: Framework chính
- **sensors_plus**: Package để truy cập cảm biến
- **Dart**: Ngôn ngữ lập trình

### Dependencies chính
```yaml
dependencies:
  flutter:
    sdk: flutter
  sensors_plus: ^5.0.1
```

## Tính năng kỹ thuật

### Xử lý cảm biến
- **Gia tốc kế**: Sử dụng `accelerometerEventStream()` để lắng nghe thay đổi nghiêng
- **Con quay hồi chuyển**: Sử dụng `gyroscopeEventStream()` để đo tốc độ góc
- **Làm mượt chuyển động**: Áp dụng hệ số ma sát và velocity để tạo chuyển động tự nhiên

### Phát hiện va chạm
- **Giới hạn biên**: Ngăn quả bi lăn ra ngoài màn hình
- **Va chạm với đích**: Tính khoảng cách Euclidean giữa tâm quả bi và đích
- **Va chạm với tường**: Phát hiện overlap và phản hồi theo hướng va chạm

### Hệ thống game
- **Điểm số**: Tăng sau mỗi lần hoàn thành thử thách
- **Thời gian**: Đo thời gian hoàn thành chính xác đến phần mười giây
- **Tự động tạo level**: Vị trí đích ngẫu nhiên mới sau mỗi lần thắng

## Tính năng nâng cao đã triển khai

### ✅ Vật cản
- Các tường đen cản đường
- Phát hiện va chạm và phản hồi vật lý
- Giảm tốc độ khi va chạm

### ✅ Hệ thống thời gian
- Đo thời gian hoàn thành chính xác
- Hiển thị thời gian trong game
- Dừng đếm khi hoàn thành

### ✅ Điều khiển con quay hồi chuyển
- Chuyển đổi giữa gia tốc kế và con quay hồi chuyển
- So sánh trải nghiệm điều khiển khác nhau
- Tích hợp cộng dồn giá trị cho gyroscope

## Hướng phát triển

- **Nhiều level**: Tạo các level có độ khó tăng dần
- **Leaderboard**: Bảng xếp hạng thời gian tốt nhất
- **Sound effects**: Âm thanh khi va chạm và hoàn thành
- **Particle effects**: Hiệu ứng hạt khi thắng
- **Multi-ball**: Nhiều quả bi cùng lúc

## Troubleshooting

### Cảm biến không hoạt động
- Đảm bảo chạy trên thiết bị thật, không phải emulator
- Kiểm tra quyền truy cập cảm biến trong settings
- Thử restart ứng dụng

### Game lag hoặc không mượt
- Điều chỉnh hệ số `sensitivity` và `friction`
- Kiểm tra performance của thiết bị
- Đóng các ứng dụng khác

## Tác giả

Dự án được phát triển như một bài tập thực hành Flutter, tập trung vào:
- Sử dụng cảm biến thiết bị
- Xử lý va chạm và vật lý cơ bản
- Quản lý trạng thái game
- UI/UX responsive

---

🎮 **Chúc bạn chơi game vui vẻ!**