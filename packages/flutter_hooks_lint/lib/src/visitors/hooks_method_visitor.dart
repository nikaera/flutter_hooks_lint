import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';

class HooksMethodVisitor extends RecursiveAstVisitor<void> {
  const HooksMethodVisitor({
    required this.onVisitMethodInvocation,
  });
  final void Function(MethodInvocation node) onVisitMethodInvocation;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final element = node.methodName.staticElement;
    if (element == null) {
      return;
    }

    final methodName = node.methodName.name;

    if (HooksHelper.isHooksElement(element)) {
      onVisitMethodInvocation(node);
    } else if (methodName.startsWith('use')) {
      final filePath = element.librarySource?.uri.toFilePath();
      if (filePath != null) {
        final collection = AnalysisContextCollection(
          includedPaths: [filePath],
          resourceProvider: PhysicalResourceProvider.INSTANCE,
        );

        final context = collection.contextFor(filePath);
        final result = context.currentSession.getParsedUnit(filePath);

        if (result is ParsedUnitResult) {
          final AstNode rootNode = result.unit;
          rootNode.visitChildren(
            _SpecificFunctionDeclarationVisitor(
              functionName: methodName,
              onVisitFunctionDeclaration: (node) {
                node.visitChildren(this);
              },
            ),
          );
        }
        onVisitMethodInvocation(node);
      }
    }

    super.visitMethodInvocation(node);
  }
}

class _SpecificFunctionDeclarationVisitor extends RecursiveAstVisitor<void> {
  const _SpecificFunctionDeclarationVisitor({
    required this.functionName,
    required this.onVisitFunctionDeclaration,
  });
  final String functionName;
  final void Function(FunctionDeclaration node) onVisitFunctionDeclaration;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (functionName == node.name.toString()) {
      onVisitFunctionDeclaration(node);
    }
    super.visitFunctionDeclaration(node);
  }
}
