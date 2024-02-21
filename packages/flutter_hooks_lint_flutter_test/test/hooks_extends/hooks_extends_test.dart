import 'package:test/test.dart';

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_extends_rule.dart';

import '../golden.dart';

void main() {
  testGolden('Checks the functionality of the HooksExtendsAssist',
      'hooks_extends/hooks_extends.diff',
      sourcePath: 'test/hooks_extends/hooks_extends.dart', (result) async {
    final lint = HooksExtendsRule();
    final errors = await lint.testRun(result);
    expect(errors, hasLength(2));

    final fixes = lint.getFixes().map((e) => e as DartFix);
    final results = await Future.wait(errors
        .map((e) => fixes.map((fix) => fix.testRun(result, e, errors)))
        .expand((e) => e));
    final sources = results.expand((e) => e);

    return sources;
  });
}
