import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

class HooksAvoidWithinClassRule extends DartLintRule {
  const HooksAvoidWithinClassRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_avoid_within_class',
    problemMessage: 'Hooks must not be defined within the class',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((declaration) {
      declaration.visitChildren(
        _MethodCollector(
          onVisitMethodDeclaration: (methodDeclaration) {
            if ('build' == methodDeclaration.name.lexeme) return;

            methodDeclaration.visitChildren(
              HooksMethodVisitor(
                onVisitMethodInvocation: (node) {
                  final instanceCreation =
                      node.thisOrAncestorOfType<InstanceCreationExpression>();
                  final element =
                      instanceCreation?.constructorName.staticElement;
                  final isIncludedHooksBuilder =
                      element != null && HooksHelper.isHooksElement(element);

                  if (!isIncludedHooksBuilder) {
                    reporter.reportErrorForNode(code, methodDeclaration);
                  }
                },
              ),
            );
          },
        ),
      );
    });
  }
}

class _MethodCollector extends GeneralizingAstVisitor<void> {
  const _MethodCollector({required this.onVisitMethodDeclaration});
  final void Function(MethodDeclaration node) onVisitMethodDeclaration;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    onVisitMethodDeclaration(node);
    super.visitMethodDeclaration(node);
  }
}
