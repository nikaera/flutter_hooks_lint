import 'dart:io';

import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_name_convention_rule.dart';
import 'package:test/test.dart';

import '../golden.dart';

void main() {
  test('Check nested using of flutter_hooks methods', () async {
    final file =
        File('test/hooks_name_convention/hooks_name_convention.dart').absolute;
    final errors = await HooksNameConventionRule().testAnalyzeAndRun(file);

    expect(errors, hasLength(1));
  }, retry: 0);

  testGolden('Check whether the custom hooks function name starts with "use".',
      'hooks_name_convention/hooks_name_convention.diff',
      sourcePath: 'test/hooks_name_convention/hooks_name_convention.dart',
      (result) async {
    final lint = HooksNameConventionRule();
    final errors = await lint.testRun(result);
    expect(errors, hasLength(1));

    final fixes = lint.getFixes().map((e) => e as DartFix);
    final results = await Future.wait(errors
        .map((e) => fixes.map((fix) => fix.testRun(result, e, errors)))
        .expand((e) => e));
    final sources = results.expand((e) => e);

    return sources;
  });
}
