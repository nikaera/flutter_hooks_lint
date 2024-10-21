import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

class HooksExtendsRule extends DartLintRule {
  const HooksExtendsRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_extends',
    problemMessage:
        'The class using the flutter_hooks function is not appropriate',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((declaration) {
      declaration.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (node) {
            final instanceCreation =
                node.thisOrAncestorOfType<InstanceCreationExpression>();
            final element = instanceCreation?.constructorName.staticElement;
            final isIncludedHooksBuilder =
                element != null && HooksHelper.isHooksElement(element);

            final extendsElement =
                declaration.extendsClause?.superclass.element;
            final isExtendsHooksBuilder = extendsElement != null &&
                HooksHelper.isHooksElement(extendsElement);

            if (!isIncludedHooksBuilder && !isExtendsHooksBuilder) {
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
    context.registry.addClassDeclaration((classNode) {
      classNode.visitChildren(
        HooksMethodVisitor(
          onVisitMethodInvocation: (node) {
            if (!analysisError.sourceRange.intersects(node.sourceRange)) {
              return;
            }

            final extendsClause = classNode.extendsClause;
            if (extendsClause == null) {
              return;
            }
            final extendsElement = extendsClause.superclass.element;
            if (extendsElement == null) {
              return;
            }

            if (!HooksHelper.isHooksElement(extendsElement)) {
              final String convertedClassName;
              switch (extendsClause.superclass.toString()) {
                case 'StatelessWidget':
                  convertedClassName = 'HookWidget';
                case 'ConsumerWidget':
                  convertedClassName = 'HookConsumerWidget';
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
            }
          },
        ),
      );
    });
  }
}
