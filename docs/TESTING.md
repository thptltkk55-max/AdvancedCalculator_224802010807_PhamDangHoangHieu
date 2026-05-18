# Testing

## Cach chay test

```bash
flutter test
```

## File test

- `test/calculator_logic_test.dart`: kiem tra cac phep tinh chinh, uu tien toan tu, ngoac, loi chia 0, loi can so am, sin DEG va bitwise programmer.
- `test/expression_parser_test.dart`: kiem tra parser voi ky hieu hien thi, implicit multiplication, exponent, log2 va radians.

## Scenario theo yeu cau lab

- `5 + 3 = 8`
- `10 - 4 = 6`
- `6 * 7 = 42`
- `15 / 3 = 5`
- `2 + 3 * 4 = 14`
- `(2 + 3) * 4 = 20`
- `(5 + 3) * 2 - 4 / 2 = 14`
- `((2 + 3) * (4 - 1)) / 5 = 3`
- Chia cho 0 tra loi ro rang.
- `sqrt` so am tra loi ro rang.
- `sin(30)` o DEG gan bang `0.5`.

## Ghi chu coverage

Project chua cau hinh nguong coverage bat buoc. Cac test tap trung vao logic tinh toan cot loi, la phan co rui ro cao nhat cua lab.
