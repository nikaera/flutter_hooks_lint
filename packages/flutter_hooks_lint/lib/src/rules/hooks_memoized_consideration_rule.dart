import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';

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
    context.registry.addVariableDeclaration((node) {
      if (node.childEntities.last.toString().startsWith('useMemoized')) {
        return;
      }

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

      final declaredElement = node.declaredElement;
      final type = declaredElement?.type;
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
