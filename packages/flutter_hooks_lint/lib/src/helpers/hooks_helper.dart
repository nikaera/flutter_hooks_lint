import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

abstract class HooksHelper {
  static bool isHooksElement(Element element) =>
      ['flutter_hooks', 'hooks_riverpod', 'flutter_use']
          .map(
            (package) => TypeChecker.fromPackage(
              package,
            ).isExactly(element),
          )
          .contains(true);

  static bool isConsiderUseMemoized(DartType type) => [
        ('GlobalKey', 'flutter'),
        ('GlobalObjectKey', 'flutter'),
      ]
          .map(
            (e) => TypeChecker.fromName(
              e.$1,
              packageName: e.$2,
            ).isExactlyType(type),
          )
          .contains(true);
}
