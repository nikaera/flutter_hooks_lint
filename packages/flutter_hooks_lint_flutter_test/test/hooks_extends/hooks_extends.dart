import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequiresHookWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}

class RequiresConsumerHookWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useState(0);
    return Text(state.value.toString());
  }
}
