# Advanced Calculator

Advanced Calculator là ứng dụng máy tính nâng cao được xây dựng bằng Flutter. Ứng dụng hỗ trợ 3 chế độ tính toán: **Basic**, **Scientific** và **Programmer**. Project sử dụng **Provider** để quản lý trạng thái, đồng thời lưu lịch sử tính toán, theme và settings bằng **SharedPreferences**.

## Công Nghệ Sử Dụng

- Flutter
- Dart
- Provider
- SharedPreferences
- math_expressions
- intl
- flutter_test

## Chức Năng Chính

- **Basic Calculator**: cộng, trừ, nhân, chia, phần trăm, đổi dấu, số thập phân, C và CE.
- **Scientific Calculator**: sin, cos, tan, ln, log, x², căn, lũy thừa, π, e, DEG/RAD và các hàm khoa học mở rộng.
- **Programmer Calculator**: chuyển đổi DEC, BIN, OCT, HEX; hỗ trợ AND, OR, XOR, NOT, <<, >>.
- **Calculation History**: lưu lịch sử tính toán, xem lại kết quả cũ và chọn lại phép tính từ lịch sử.
- **Settings**: chọn theme, độ chính xác thập phân, DEG/RAD, history size, haptic feedback và sound effects.
- **Memory Functions**: MC, MR, M+, M-.
- **Theme**: hỗ trợ Light, Dark và System theme.
- **Error Handling**: xử lý lỗi chia cho 0, biểu thức sai, căn số âm và các lỗi tính toán thường gặp.

## Screenshots

### Basic Mode - Light Theme

![Basic Mode](screenshots/z7836966432698_d05345ddd900f57c7f18da7f59bbb60a.jpg)

### Scientific Mode - Light Theme

![Scientific Mode](screenshots/z7836968885426_2d8a23468cbf4dd95e361f1e4cd7cdd7.jpg)

### Programmer Mode - Light Theme

![Programmer Mode](screenshots/z7836969707811_6de9a8520faf74170bb3f1c188f994b5.jpg)

### History Screen - Light Theme

![History Screen](screenshots/z7836971414312_f334c18953f4cd4be4d99d3306e87cf4.jpg)

### Settings Screen - Light Theme

![Settings Screen](screenshots/z7837090621527_3fd08857412b2ea6bed990a039deeeb6.jpg)

### Basic Mode - Dark Theme

![Basic Mode Dark Theme](screenshots/z7837162208182_b03fe373c27461682f766a9454ac84c3.jpg)

### Scientific Mode - Dark Theme

![Scientific Mode Dark Theme](screenshots/z7837162208340_29a2d65ab5f5815f6260f09840fa7563.jpg)

### Programmer Mode - Dark Theme

![Programmer Mode Dark Theme](screenshots/z7837162208346_7e7a56e3c51a3d7c3219ff444191f5ba.jpg)

### History Screen - Dark Theme

![History Screen Dark Theme](screenshots/z7837158971240_cfbda9235c2721470c8a7305a1482fc1.jpg)

### Settings Screen - Dark Theme

![Settings Screen Dark Theme](screenshots/z7837157358915_cf73221ae8373cdf3b2655cfafe070c6.jpg)

## Cấu Trúc Thư Mục

```text
lib/
  main.dart
  models/
  providers/
  screens/
  widgets/
  utils/
  services/
test/
docs/
screenshots/
```

- `models/`: chứa các model dữ liệu như lịch sử tính toán, settings, mode.
- `providers/`: quản lý state của calculator, history và theme.
- `screens/`: chứa các màn hình chính như Calculator, History, Settings.
- `widgets/`: chứa các widget tái sử dụng như display, button grid, calculator button.
- `utils/`: chứa logic tính toán, expression parser và constants.
- `services/`: xử lý lưu dữ liệu local bằng SharedPreferences.
- `test/`: chứa unit test và widget test.
- `docs/`: tài liệu kiến trúc và kiểm thử.
- `screenshots/`: thư mục đặt ảnh demo để hiển thị trong README.

## Kiến Trúc App

App sử dụng **Provider** để quản lý trạng thái và tự động cập nhật UI khi dữ liệu thay đổi.

- `CalculatorProvider`: quản lý expression, result, calculator mode, memory, angle mode và programmer base.
- `HistoryProvider`: quản lý danh sách lịch sử tính toán, giới hạn số lượng lịch sử và lưu/xóa history.
- `ThemeProvider`: quản lý Light/Dark/System theme.
- `StorageService`: lưu settings, theme và history bằng SharedPreferences.

Luồng xử lý chính:

```text
User Input
   ↓
Calculator Button
   ↓
CalculatorProvider
   ↓
Calculator Logic / Expression Parser
   ↓
Update Result + Save History
   ↓
UI Rebuild with Provider
```

## Cài Đặt Project

```bash
git clone <repository-url>
cd advanced_calculator
flutter pub get
flutter run
```

Nếu chạy trực tiếp trong thư mục project hiện tại:

```bash
flutter pub get
flutter run
```

## Chạy Test

```bash
flutter test
```

## Kiểm Tra Chất Lượng Code

```bash
flutter analyze
```

## Dữ Liệu Được Lưu Cục Bộ

Ứng dụng sử dụng SharedPreferences để lưu:

- Lịch sử tính toán.
- Lựa chọn theme.
- Cài đặt độ chính xác thập phân.
- DEG/RAD mode.
- History size.
- Haptic feedback và sound effects setting.
