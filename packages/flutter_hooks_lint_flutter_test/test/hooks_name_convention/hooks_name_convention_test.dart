import 'dart:io';

import 'package:flutter_hooks_lint/src/rules/hooks_name_convention_rule.dart';
import 'package:test/test.dart';

void main() {
  test('Check nested using of flutter_hooks methods', () async {
    final file =
        File('test/hooks_name_convention/hooks_name_convention.dart').absolute;
    final errors = await HooksNameConventionRule().testAnalyzeAndRun(file);

    expect(errors, hasLength(1));
  }, retry: 0);
}
