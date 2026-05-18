# Kien truc Advanced Calculator

## Models

- `CalculationHistory`: luu expression, result va timestamp, co `toJson()` va `fromJson()`.
- `CalculatorMode`, `AngleMode`, `ProgrammerBase`: enum cho che do may tinh, don vi goc va he dem programmer.
- `CalculatorSettings`: gom theme, decimal precision, angle mode, haptic, sound va history size.

## Providers

- `CalculatorProvider`: trung tam xu ly input. Provider giu `expression`, `result`, `mode`, `angleMode`, `memory`, `hasMemory`, `programmerBase` va `settings`.
- `HistoryProvider`: quan ly danh sach lich su, load/save SharedPreferences, trim theo history size.
- `ThemeProvider`: tao light/dark theme va luu `ThemeMode`.

## Screens

- `CalculatorScreen`: man hinh chinh, gom display, mode selector, programmer base panel va button grid.
- `HistoryScreen`: hien thi lich su, cho phep cham vao item de dua expression/result ve Calculator.
- `SettingsScreen`: cau hinh theme, precision, angle, haptic, sound, history size va xoa history.

## Widgets

- `DisplayArea`: hien expression/result nhieu dong, DEG/RAD va memory indicator.
- `ModeSelector`: doi Basic/Scientific/Programmer.
- `ButtonGrid`: render layout nut theo mode.
- `CalculatorButton`: nut co animation scale khi nhan.

## Utils va Services

- `ExpressionParser`: parser de quy tu viet, ho tro uu tien toan tu, ngoac, implicit multiplication, ham scientific va loi ro rang.
- `CalculatorLogic`: API tinh toan cho app va unit test, gom standard expression va programmer expression.
- `StorageService`: doc/ghi SharedPreferences cho history, settings va theme.

## Luong xu ly khi bam nut

1. Nguoi dung bam nut trong `CalculatorButton`.
2. `ButtonGrid` gui label ve `CalculatorScreen`.
3. `CalculatorScreen` goi `CalculatorProvider.addToExpression(label)`.
4. Provider xu ly command nhu C, CE, memory, function scientific, base programmer hoac them token vao expression.
5. Khi label la `=`, provider goi `calculate()`.
6. `CalculatorLogic` tinh ket qua bang `ExpressionParser` hoac logic Programmer.
7. Provider cap nhat `result` va tao `CalculationHistory`.
8. `CalculatorScreen` dua history item sang `HistoryProvider.addHistory()`.
9. `HistoryProvider` luu danh sach moi vao SharedPreferences.
