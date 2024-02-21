
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

class HooksMemoizedConsiderationRule extends DartLintRule {
  const HooksMemoizedConsiderationRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_memoized_consideration',
    problemMessage: 'This seems like a thought to consider using useMemoized',
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
            if (['useFuture', 'useStream'].contains(node.methodName.name)) {
              reporter.reportErrorForNode(code, node);
            }
          },
        ),
      );
    });

    context.registry.addVariableDeclaration((node) {
      final type = node.declaredElement?.type;
      if (type == null) {
        return;
      }
      if (HooksHelper.isConsiderUseMemoized(type)) {
        reporter.reportErrorForNode(code, node);
      }
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
            if (['useFuture', 'useStream'].contains(node.methodName.name)) {
              final changeBuilder = reporter.createChangeBuilder(
                message: 'Wrap with useMemoized',
                priority: 30,
              );

              changeBuilder.addDartFileEdit((builder) {
                builder.addSimpleReplacement(
                  SourceRange(node.offset, node.length),
                  'useMemoized(() => ${node.toSource()})',
                );
              });
            }
          },
        ),
      );
    });

    context.registry.addVariableDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }

      final declaredElement = node.declaredElement;
      if (declaredElement == null) {
        return;
      }
      final changeBuilder = reporter.createChangeBuilder(
        message: 'Wrap with useMemoized',
        priority: 30,
      );
      final initializer = node.initializer;
      if (initializer == null) {
        return;
      }
      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          SourceRange(
            initializer.offset,
            initializer.length,
          ),
          'useMemoized(() => $initializer)',
        );
      });
    });
  }
}
