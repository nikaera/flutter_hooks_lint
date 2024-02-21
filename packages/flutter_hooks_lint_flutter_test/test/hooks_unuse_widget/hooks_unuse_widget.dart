import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'custom_hooks.dart';

class UnuseHookWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

class UseHookWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}

class UseCustomHookWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffectOnce(() {
      return;
    });
    return Text('');
  }
}

class UnuseHookConsumerWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.shrink();
  }
}

class UseHookConsumerWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}
