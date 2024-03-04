import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
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
      final collector = _MethodCollector();
      declaration.visitChildren(collector);

      for (final methodDeclaration in collector.methods) {
        // TODO(nikaera): should only detect when the build function name is inherited from the Widget class.
        if ('build' == methodDeclaration.name.lexeme) continue;

        methodDeclaration.visitChildren(
          HooksMethodVisitor(
            onVisitMethodInvocation: (node) {
              reporter.reportErrorForNode(code, methodDeclaration);
            },
          ),
        );
      }
    });
  }
}

class _MethodCollector extends GeneralizingAstVisitor<void> {
  final List<MethodDeclaration> methods = [];

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    methods.add(node);
    super.visitMethodDeclaration(node);
  }
}
