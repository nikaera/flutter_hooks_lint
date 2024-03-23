import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:flutter_hooks_lint/src/helpers/hooks_helper.dart';

final _regexp = RegExp('^use[A-Z]{1}');

class HooksMethodVisitor extends RecursiveAstVisitor<void> {
  const HooksMethodVisitor({
    required this.onVisitMethodInvocation,
    this.caller,
  });

  final void Function(MethodInvocation node) onVisitMethodInvocation;
  final MethodInvocation? caller;

  /*
    TODO(nikaera):
    I would like to recursively verify whether a function accurately utilizes
the hooks package using getResolvedUnit. However, the execution time becomes
excessively long. Hence, I am simplifying the process by examining if the
function, which I aim to explore using getParsedUnit, employs the hooks
package from the AST of a single file where the function is defined.
  */
  @override
  void visitMethodInvocation(MethodInvocation node) {
    final element = node.methodName.staticElement;
    if (element == null) {
      if (caller != null && _regexp.hasMatch(node.methodName.name)) {
        onVisitMethodInvocation(caller!);
      }
      return super.visitMethodInvocation(node);
    }

    final methodName = node.methodName.name;

    final isDartCoreMethod = element.library?.isDartCore ?? false;
    final isInSdkMethod = element.library?.isInSdk ?? false;

    if (HooksHelper.isHooksElement(element)) {
      onVisitMethodInvocation(node);
    } else if (!isDartCoreMethod && !isInSdkMethod) {
      final filePath = element.librarySource?.fullName;
      if (filePath != null) {
        final collection = AnalysisContextCollection(
          includedPaths: [filePath],
          resourceProvider: PhysicalResourceProvider.INSTANCE,
        );

        final context = collection.contextFor(filePath);
        final result = context.currentSession.getParsedUnit(filePath);
        result as ParsedUnitResult;

        result.unit.visitChildren(
          _SpecificFunctionDeclarationVisitor(
            functionName: methodName,
            onVisitFunctionDeclaration: (childNode) {
              childNode.visitChildren(
                HooksMethodVisitor(
                  caller: caller ?? node,
                  onVisitMethodInvocation: onVisitMethodInvocation,
                ),
              );
            },
          ),
        );
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
