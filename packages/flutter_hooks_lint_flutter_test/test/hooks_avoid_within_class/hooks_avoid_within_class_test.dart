import 'dart:io';

import 'package:flutter_hooks_lint/src/rules/hooks_avoid_within_class_rule.dart';
import 'package:test/test.dart';

void main() {
  test('Check nested using of flutter_hooks methods', () async {
    final file =
        File('test/hooks_avoid_within_class/hooks_avoid_within_class.dart')
            .absolute;
    final errors = await HooksAvoidWithinClassRule().testAnalyzeAndRun(file);

    expect(errors, hasLength(1));
  }, retry: 0);
}
