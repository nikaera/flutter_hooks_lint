import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_hooks_lint/src/visitors/hooks_method_visitor.dart';

class HooksAvoidNestingRule extends DartLintRule {
  const HooksAvoidNestingRule() : super(code: _code);

  static const _code = LintCode(
    name: 'hooks_avoid_nesting',
    problemMessage:
        'Hooks must be used in top-level scope of the build function',
    errorSeverity: ErrorSeverity.ERROR,
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
            if (_findControlFlow(node)) {
              reporter.reportErrorForNode(code, node);
            }
          },
        ),
      );
    });
  }

  // https://github.com/mj-hd/flutter_hooks_lint_plugin/blob/c875409a400c6b05a2143de204000a971f0d8eb8/lib/src/lint/rules_of_hooks.dart#L72-L93
  bool _findControlFlow(AstNode? node) {
    if (node == null) return false;
    if (node is MethodDeclaration && node.name.lexeme == 'build') {
      return false;
    }

    if (node is IfStatement) return true;
    if (node is ForStatement) return true;
    if (node is SwitchStatement) return true;
    if (node is WhileStatement) return true;
    if (node is DoStatement) return true;
    if (node is FunctionDeclarationStatement) return true;
    if (node is MethodInvocation &&
        (node.staticType?.isDartCoreIterable ?? false)) return true;
    if (node is MethodInvocation && node.methodName.name == 'assert') {
      return true;
    }

    return _findControlFlow(node.parent);
  }
}
