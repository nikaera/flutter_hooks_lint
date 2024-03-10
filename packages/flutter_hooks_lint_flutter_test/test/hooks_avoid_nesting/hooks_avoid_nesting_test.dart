import 'dart:io';

import 'package:flutter_hooks_lint/src/rules/hooks_avoid_nesting_rule.dart';
import 'package:test/test.dart';

void main() {
  test('Check nested using of flutter_hooks methods', () async {
    final file =
        File('test/hooks_avoid_nesting/hooks_avoid_nesting.dart').absolute;
    final errors = await HooksAvoidNestingRule().testAnalyzeAndRun(file);

    expect(errors, hasLength(3));
  }, retry: 0);
}
