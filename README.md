# flutter_hooks_lint🪝🏴‍☠️

<a href="https://pub.dartlang.org/packages/flutter_hooks_lint">
  <img src="https://img.shields.io/pub/v/flutter_hooks_lint.svg" alt="flutter_hooks_lint package">
</a>
<a href="https://pub.dev/packages/very_good_analysis">
  <img src="https://img.shields.io/badge/style-very__good__analysis-40c4ff.svg" alt="very_good_analysis" />
</a>
<a href="https://github.com/nikaera/flutter_hooks_lint/actions/workflows/project-ci.yaml">
  <img src="https://github.com/nikaera/flutter_hooks_lint/actions/workflows/project-ci.yaml/badge.svg" alt="Build Status">
</a>

A lint package providing guidelines for using [flutter_hooks](https://pub.dev/packages/flutter_hooks) in your Flutter widget! 🦜

* You can keep code that follows the rules outlined in the [official documentation of flutter_hooks](https://pub.dev/packages/flutter_hooks#rules). ⚓
* A lint rules are available to **improve both performance and readability**. ✨
* A lint rules **supporting [`hooks_riverpod`](https://pub.dev/packages/hooks_riverpod) has been prepared**. 🧑‍🤝‍🧑

The currently available lint rules are as follows:

| LintRule  | Description | Quickfix |
| ------------- | ------------- | ------------- |
| [hooks_avoid_nesting](#hooks_avoid_nesting)  | You should use Hooks only inside the build method of a Widget. | |
| [hooks_name_convention](#hooks_name_convention)  | DO always prefix your hooks with use, https://pub.dev/packages/flutter_hooks#rules. | |
| [hooks_extends](#hooks_extends)  | Using Hooks inside a Widget other than HookWidget or HookConsumerWidget will result in an error at runtime. | ✅ |
| [hooks_unuse_widget](#hooks_unuse_widget)  | If you are not using Hooks inside of a Widget, you do not need HookWidget or HookConsumerWidget. | ✅ |
| [hooks_memoized_consideration](#hooks_memoized_consideration)  | Considering performance and functionality, there may be places where it is worth considering the use of useMemoized. | ✅ |
| [hooks_callback_consideration](#hooks_callback_consideration)  | There are cases where you can use useCallback, which is the syntax sugar for useMemoized. | ✅ |

![screencast](https://github.com/nikaera/flutter_hooks_lint/assets/1802476/bbea0791-502e-4091-8941-a94e15097752)

## Installation

Add both `flutter_hooks_lint` and `custom_lint` to your `pubspec.yaml`:
```yaml
dev_dependencies:
  custom_lint:
  flutter_hooks_lint:
```

Enable custom_lint's plugin in your `analysis_options.yaml`:
```yaml
analyzer:
  plugins:
    - custom_lint
```

## Enabling/disabling lints

By default when installing `flutter_hooks_lint`, most of the lints will be enabled.

You may dislike one of the various lint rules offered by `flutter_hooks_lint`. In that event, you can explicitly disable this lint rule for your project by modifying the `analysis_options.yaml`

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Explicitly disable one lint rule
    - hooks_unuse_widget: false
```

## Running flutter_hooks_lint in the terminal/CI 🤖

Custom lint rules created by `flutter_hooks_lint` may not show-up in dart analyze. To fix this, you can run a custom command line: `custom_lint`.

Since your project should already have `custom_lint` installed, then you should be able to run:

```bash
# Install custom_lint for project
dart pub get custom_lint
# run custom_lint's command line in a project
dart run custom_lint
```

Alternatively, you can globally install custom_lint:

```bash
# Install custom_lint for all projects
dart pub global activate custom_lint
# run custom_lint's command line in a project
custom_lint
```

## All the lints

### hooks_avoid_nesting

**You should use Hooks only inside the build method of a Widget.**

* https://pub.dev/packages/flutter_hooks#rules

**Bad**:

```dart
@override
Widget build(BuildContext context) {
  if (isEnable) {
    final state = useState(0); // ❌
    return Text(state.value.toString());
  } else {
    return SizedBox.shrink();
  }
}
```

**Good**:

```dart
@override
Widget build(BuildContext context) {
    final state = useState(0); // ⭕
    return isEnable ?
      Text(state.value.toString()) :
      SizedBox.shrink();
}
```

### hooks_name_convention

**DO always prefix your hooks with use.**

* https://pub.dev/packages/flutter_hooks#rules.

**Bad**:

```dart
class WrongMethodWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    effectOnce(() { // ❌
      return;
    });
    return Text('');
  }
}
```

**Good**:

```dart
class CorrectMethodWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffectOnce(() { // ⭕
      return;
    });
    return Text('');
  }
}
```

### hooks_extends

**Using Hooks inside a Widget other than `HookWidget` or `HookConsumerWidget` will result in an error at runtime.**

**Bad**:

```dart
class RequiresHookWidget extends StatelessWidget { // ❌
  @override
  Widget build(BuildContext context) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}

class RequiresConsumerHookWidget extends ConsumerWidget { // ❌
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}
```

**Good**:

```dart
class RequiresHookWidget extends HookWidget { // ⭕
  @override
  Widget build(BuildContext context) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}

class RequiresConsumerHookWidget extends HookConsumerWidget { // ⭕
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}
```

### hooks_unuse_widget

If you are not using Hooks inside of a Widget, you do not need `HookWidget` or `HookConsumerWidget`.

**Bad**:

```dart
class UnuseHookWidget extends HookWidget { // ❌
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

class UnuseHookConsumerWidget extends HookConsumerWidget { // ❌
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.shrink();
  }
}
```

**Good**:

```dart
class UnuseHookWidget extends StatelessWidget { // ⭕
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

class UnuseHookConsumerWidget extends ConsumerWidget { // ⭕
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.shrink();
  }
}
```

### hooks_memoized_consideration

Considering functionality, there may be places where it is worth considering the use of `useMemoized`.

* https://api.flutter.dev/flutter/widgets/GlobalKey-class.html

**Bad**

```dart
class ConsiderationMemoizedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<TooltipState>(); // ❌
    final objectKey = GlobalObjectKey<TooltipState>("object"); // ❌
    return Column(
        children: [key, objectKey]
            .map((k) => Tooltip(
                  key: key,
                  message: 'Click me!',
                ))
            .toList());
  }
}
```

**Good**

```dart
class ConsiderationMemoizedWidget extends HooksWidget {
  @override
  Widget build(BuildContext context) {
    final key = useMemoized(() => GlobalKey<TooltipState>()); // ⭕
    final objectKey = useMemoized(() => GlobalObjectKey<TooltipState>("object")); // ⭕
    return Column(
        children: [key, objectKey]
            .map((k) => Tooltip(
                  key: key,
                  message: 'Click me!',
                ))
            .toList());
  }
}
```

### hooks_callback_consideration

There are cases where you can use `useCallback`, which is the syntax sugar for `useMemoized`.

* https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useCallback.html

**Bad**

```dart
class ConsiderationMemoizedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useMemoized(() => () => 0); // ❌
    return Text(state.call().toString());
  }
}
```

**Good**

```dart
class ConsiderationMemoizedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useCallback(() => 0); // ⭕
    return Text(state.call().toString());
  }
}
```

## Contribution 🎁

Thanks for your interest! PR are welcomed! 🙌
I would be delighted if you could translate the documentation into natural English or add new lint rules!

The project setup procedures for development are as follows:

1. Fork it ( https://github.com/nikaera/flutter_hooks_lint/fork )
2. Create your fix/feature branch (git checkout -b my-new-feature)
3. Install Melos ( `dart pub global activate melos` )
4. Set up the project and run the test ( `melos bs` )
5. Add a test each time you modify
6. `4.` it is possible to check the operation by executing the command ( `melos bs` )
7. Commit your changes (git commit -am 'Add some feature')
8. Push to the branch (git push origin my-new-feature)
9. Create new Pull Request! 🎉
