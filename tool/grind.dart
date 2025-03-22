import 'package:grinder/grinder.dart';
import 'dart:io';

main(args) => grind(args);

@DefaultTask()
@Task('Run flutter_hooks_lint_flutter_test package tests')
test() {
  run('dart',
      arguments: ['test', '--no-retry'],
      workingDirectory: 'packages/flutter_hooks_lint_flutter_test');
}

@Task('Apply dart fix or dry run to all packages')
fix() {
  TaskArgs args = context.invocation.arguments;
  bool isDryRun = args.getFlag('dry-run');
  Directory('packages').listSync()
    .where((entity) => entity is Directory)
    .forEach((dir) {
      run('dart',
          arguments: ['fix', isDryRun ? '--dry-run' : '--apply', '.'],
          workingDirectory: dir.path);
  });
}

@Task('Analyze all packages')
analyze() {
  Directory('packages').listSync()
    .where((entity) => entity is Directory)
    .forEach((dir) {
      run('flutter',
          arguments: ['analyze'],
          workingDirectory: dir.path);
  });
}

@Task()
clean() => defaultClean();
