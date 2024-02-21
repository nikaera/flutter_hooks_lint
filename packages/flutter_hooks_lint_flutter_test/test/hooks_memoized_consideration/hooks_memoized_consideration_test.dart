import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_memoized_consideration_rule.dart';
import 'package:test/test.dart';

import '../golden.dart';

void main() {
  testGolden('Check nested using of flutter_hooks methods',
      'hooks_memoized_consideration/hooks_memoized_consideration.diff',
      sourcePath:
          'test/hooks_memoized_consideration/hooks_memoized_consideration.dart',
      (result) async {
    final lint = HooksMemoizedConsiderationRule();
    final errors = await lint.testRun(result);
    expect(errors, hasLength(3));

    final fixes = lint.getFixes().map((e) => e as DartFix);
    final results = await Future.wait(errors
        .map((e) => fixes.map((fix) => fix.testRun(result, e, errors)))
        .expand((e) => e));
    final sources = results.expand((e) => e);

    return sources;
  });
}
