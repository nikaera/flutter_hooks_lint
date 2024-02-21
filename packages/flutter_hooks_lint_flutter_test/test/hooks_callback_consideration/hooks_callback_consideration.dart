import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConsiderationMemoizedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useMemoized(() => () => 0, const []);
    return Text(state.call().toString());
  }
}

class ConsiderationMemoizedWidget2 extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useMemoized(
      () => () {
        return 0;
      },
    );
    return Text(state.call().toString());
  }
}

class ConsiderationMemoizedWidget3 extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useMemoized(() {
      return () {
        return 0;
      };
    });
    return Text(state.call().toString());
  }
}

class HookConsiderationMemoizedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useMemoized(() => 0);
    return Text(state.toString());
  }
}
