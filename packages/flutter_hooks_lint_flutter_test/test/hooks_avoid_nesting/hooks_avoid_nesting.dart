import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
