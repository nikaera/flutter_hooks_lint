import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

final _regexp = RegExp('^use[A-Z]{1}');

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
    context.registry.addMethodDeclaration((node) {
      final classDeclaration = node.thisOrAncestorOfType<ClassDeclaration>();
      final extendsClause = classDeclaration?.extendsClause;
      if (extendsClause == null) {
        return;
      }
      final extendsElement = extendsClause.superclass.element;
      if (extendsElement == null) {
        return;
      }
      if (!HooksHelper.isHooksElement(extendsElement)) {
        return;
      }

      node.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (node) {
            if (!_regexp.hasMatch(node.methodName.name)) {
              reporter.reportErrorForNode(code, node);
            }
          },
        ),
      );
    });
  }
}
