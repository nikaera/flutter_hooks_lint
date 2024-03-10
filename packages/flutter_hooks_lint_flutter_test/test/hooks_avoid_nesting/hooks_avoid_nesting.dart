import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NeedsAvoidNestingHookWidget extends HookWidget {
  const NeedsAvoidNestingHookWidget({required this.isEnable});

  final bool isEnable;
  @override
  Widget build(BuildContext context) {
    if (isEnable) {
      final state = useState(0);
      return Text(state.value.toString());
    } else {
      return SizedBox.shrink();
    }
  }
}

class HookBuilderWidget extends StatelessWidget {
  const HookBuilderWidget({required this.isEnable});

  final bool isEnable;
  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      if (isEnable) {
        final state = useState(0);
        return Text(state.value.toString());
      } else {
        return SizedBox.shrink();
      }
    });
  }
}

class HookConsumerBuilderWidget extends StatelessWidget {
  const HookConsumerBuilderWidget({required this.isEnable});

  final bool isEnable;
  @override
  Widget build(BuildContext context) {
    return HookConsumer(builder: (context, ref, _) {
      if (isEnable) {
        final state = useState(0);
        return Text(state.value.toString());
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
