import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

final _regexp = RegExp('^use[A-Z]{1}');

class HooksNameConventionRule extends DartLintRule {
  const HooksNameConventionRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_name_convention',
    problemMessage:
        'DO always prefix your hooks with use, https://pub.dev/packages/flutter_hooks#rules.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionDeclaration((node) {
      node.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (_) {
            if (!_regexp.hasMatch(node.name.lexeme)) {
              reporter.reportErrorForNode(code, node);
            }
          },
        ),
      );
    });
  }

  @override
  List<Fix> getFixes() => [_LintFix()];
}

class _LintFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addFunctionDeclaration((node) {
      node.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (_) {
            if (!analysisError.sourceRange.intersects(node.sourceRange)) {
              return;
            }
            if (!_regexp.hasMatch(node.name.lexeme)) {
              final name = node.name.lexeme;
              final newMethodName =
                  'use${name[0].toUpperCase()}${name.substring(1)}';
              final changeBuilder = reporter.createChangeBuilder(
                message: 'Rename to $newMethodName',
                priority: 30,
              );

              changeBuilder.addDartFileEdit((builder) {
                builder.addSimpleReplacement(
                  SourceRange(
                    node.name.offset,
                    node.name.length,
                  ),
                  newMethodName,
                );
              });
            }
          },
        ),
      );
    });
  }
}
