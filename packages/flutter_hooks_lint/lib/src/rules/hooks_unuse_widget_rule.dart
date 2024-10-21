import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_class_instance_creation_visitor.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

class HooksUnuseWidgetRule extends DartLintRule {
  const HooksUnuseWidgetRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_unuse_widget',
    problemMessage: 'No need to use flutter_hooks Widget',
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
        HooksClassInstanceCreationVisitor(
          onVisitInstanceCreationExpression: (node) {
            final element = node.constructorName.staticElement;
            final isIncludedHooksBuilder =
                element != null && HooksHelper.isHooksElement(element);

            if (isIncludedHooksBuilder) {
              var isNeedsHookWidget = false;
              node.visitChildren(
                HooksMethodVisitor(
                  onVisitMethodInvocation: (_) {
                    isNeedsHookWidget = true;
                  },
                ),
              );

              if (!isNeedsHookWidget) {
                reporter.reportErrorForNode(code, node);
              }
            }
          },
        ),
      );
    });

    context.registry.addMethodDeclaration((node) {
      node.visitChildren(
        HooksClassInstanceCreationVisitor(
          onVisitInstanceCreationExpression: (node) {
            final element = node.constructorName.staticElement;
            final isIncludedHooksBuilder =
                element != null && HooksHelper.isHooksElement(element);

            if (isIncludedHooksBuilder) {
              var isNeedsHookWidget = false;
              node.visitChildren(
                HooksMethodVisitor(
                  onVisitMethodInvocation: (_) {
                    isNeedsHookWidget = true;
                  },
                ),
              );

              if (!isNeedsHookWidget) {
                reporter.reportErrorForNode(code, node);
              }
            }
          },
        ),
      );
    });

    context.registry.addClassDeclaration((declaration) {
      final extendsClause = declaration.extendsClause;
      if (extendsClause == null) {
        return;
      }

      final element = extendsClause.superclass.element;
      if (element == null) {
        return;
      }

      if (!HooksHelper.isHooksElement(element)) {
        return;
      }

      var isNeedsHookWidget = false;
      declaration.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (_) {
            isNeedsHookWidget = true;
          },
        ),
      );

      if (!isNeedsHookWidget) {
        reporter.reportErrorForNode(code, extendsClause.superclass);
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
    context.registry.addClassDeclaration((declaration) {
      final extendsClause = declaration.extendsClause;
      if (extendsClause == null) {
        return;
      }

      final superclass = extendsClause.superclass;
      if (superclass.element == null ||
          !analysisError.sourceRange.intersects(superclass.sourceRange)) {
        return;
      }

      if (!HooksHelper.isHooksElement(superclass.element!)) {
        return;
      }

      var isNeedsHookWidget = false;
      declaration.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (_) {
            isNeedsHookWidget = true;
          },
        ),
      );

      if (isNeedsHookWidget) return;

      final String convertedClassName;
      switch (extendsClause.superclass.toString()) {
        case 'HookWidget':
          convertedClassName = 'StatelessWidget';
        case 'HookConsumerWidget':
          convertedClassName = 'ConsumerWidget';
        default:
          return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Convert to $convertedClassName',
        priority: 30,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          SourceRange(
            extendsClause.superclass.offset,
            extendsClause.superclass.length,
          ),
          convertedClassName,
        );
      });
    });
  }
}
