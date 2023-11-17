import 'package:flutter_test/flutter_test.dart';

import 'package:file_logger/file_logger.dart';

void main() {
  test('adds one to input values', () async {
    final calculator = await FileLogger.writeToFile("test");
    expect(calculator, true);
    final files = await FileLogger.getLogsFiles();
    expect(files.isNotEmpty, true);
  });
}
