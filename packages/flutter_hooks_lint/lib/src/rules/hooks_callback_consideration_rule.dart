import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

class HooksCallbackConsiderationRule extends DartLintRule {
  const HooksCallbackConsiderationRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_callback_consideration',
    problemMessage: 'This seems like a thought to consider using useCallback',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((classNode) {
      classNode.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (node) {
            if ('useMemoized' == node.methodName.name) {
              final firstArgument = node.argumentList.arguments.first;
              if (firstArgument is FunctionExpression) {
                final returnType = firstArgument.declaredElement?.returnType;
                if (returnType is FunctionType) {
                  reporter.reportErrorForNode(code, node);
                }
              }
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
    context.registry.addClassDeclaration((classNode) {
      classNode.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (node) {
            if (!analysisError.sourceRange.intersects(node.sourceRange)) {
              return;
            }
            if ('useMemoized' == node.methodName.name) {
              final arguments = node.argumentList.arguments;
              final firstArgument = arguments.first;
              if (firstArgument is FunctionExpression) {
                final declaredElement = firstArgument.declaredElement;
                final returnType = declaredElement?.returnType;
                if (returnType is FunctionType) {
                  final changeBuilder = reporter.createChangeBuilder(
                    message: 'Convert to useCallback',
                    priority: 30,
                  );

                  final match =
                      RegExp(r'(\(\)\s*\{\s*.*?\s*\}|\(\)\s*\=>\s*(.*))')
                          .firstMatch(firstArgument.body.toSource());
                  final group = match?.group(0);
                  final args = arguments.sublist(1);
                  final sourceCode =
                      args.isNotEmpty ? '$group, ${args.join(', ')}' : group;
                  changeBuilder.addDartFileEdit((builder) {
                    builder.addSimpleReplacement(
                      SourceRange(node.offset, node.length),
                      'useCallback($sourceCode)',
                    );
                  });
                }
              }
            }
          },
        ),
      );
    });
  }
}
