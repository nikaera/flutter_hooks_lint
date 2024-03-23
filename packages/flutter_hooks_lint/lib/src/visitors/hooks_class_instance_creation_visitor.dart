import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';

class HooksClassInstanceCreationVisitor extends RecursiveAstVisitor<void> {
  const HooksClassInstanceCreationVisitor({
    required this.onVisitInstanceCreationExpression,
  });

  final void Function(InstanceCreationExpression node)
      onVisitInstanceCreationExpression;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final element = node.constructorName.staticElement;
    if (element != null && HooksHelper.isHooksElement(element)) {
      onVisitInstanceCreationExpression(node);
    }
    super.visitInstanceCreationExpression(node);
  }
}
