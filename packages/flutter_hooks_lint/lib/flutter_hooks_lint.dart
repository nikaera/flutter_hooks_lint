/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_avoid_nesting_rule.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_callback_consideration_rule.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_extends_rule.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_memoized_consideration_rule.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_name_convention_rule.dart';
import 'package:flutter_hooks_lint/src/rules/hooks_unuse_widget_rule.dart';

PluginBase createPlugin() => _FlutterHooksLinter();

class _FlutterHooksLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      const HooksExtendsRule(),
      const HooksUnuseWidgetRule(),
      const HooksAvoidNestingRule(),
      const HooksNameConventionRule(),
      const HooksMemoizedConsiderationRule(),
      const HooksCallbackConsiderationRule(),
    ];
  }
}
