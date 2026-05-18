enum CalculatorMode {
  basic,
  scientific,
  programmer,
}

enum AngleMode {
  degrees,
  radians,
}

enum ProgrammerBase {
  decimal,
  binary,
  octal,
  hexadecimal,
}

extension CalculatorModeLabel on CalculatorMode {
  String get label {
    switch (this) {
      case CalculatorMode.basic:
        return 'Basic';
      case CalculatorMode.scientific:
        return 'Scientific';
      case CalculatorMode.programmer:
        return 'Programmer';
    }
  }
}

extension AngleModeLabel on AngleMode {
  String get label => this == AngleMode.degrees ? 'DEG' : 'RAD';
}

extension ProgrammerBaseLabel on ProgrammerBase {
  String get label {
    switch (this) {
      case ProgrammerBase.decimal:
        return 'DEC';
      case ProgrammerBase.binary:
        return 'BIN';
      case ProgrammerBase.octal:
        return 'OCT';
      case ProgrammerBase.hexadecimal:
        return 'HEX';
    }
  }

  int get radix {
    switch (this) {
      case ProgrammerBase.decimal:
        return 10;
      case ProgrammerBase.binary:
        return 2;
      case ProgrammerBase.octal:
        return 8;
      case ProgrammerBase.hexadecimal:
        return 16;
    }
  }
}
