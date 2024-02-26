import 'package:flutter_hooks_lint/src/rules/hooks_unuse_widget_rule.dart';
import 'package:test/test.dart';

import 'package:custom_lint_builder/custom_lint_builder.dart';
import '../golden.dart';

void main() {
  testGolden('Should identify and suggest fixes for unused widget hooks',
      'hooks_unuse_widget/hooks_unuse_widget.diff',
      sourcePath: 'test/hooks_unuse_widget/hooks_unuse_widget.dart',
      (result) async {
    final lint = HooksUnuseWidgetRule();
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
