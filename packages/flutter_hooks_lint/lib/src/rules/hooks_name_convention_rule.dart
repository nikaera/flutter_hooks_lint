import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

class HooksNameConventionRule extends DartLintRule {
  const HooksNameConventionRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_name_convention',
    problemMessage:
        'DO always prefix your hooks with use, https://pub.dev/packages/flutter_hooks#rules.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((classNode) {
      final regexp = RegExp('^use[A-Z]{1}');

      classNode.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (node) {
            if (!regexp.hasMatch(node.methodName.name)) {
              reporter.reportErrorForNode(code, node);
            }
          },
        ),
      );
    });
  }
}
