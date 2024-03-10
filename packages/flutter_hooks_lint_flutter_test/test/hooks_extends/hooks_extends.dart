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

final _textProvider = Provider((ref) => "");

class RiverpodWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(_textProvider);
    return Text(text);
  }
}

class HookBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      final state = useState(0);
      return Text(state.value.toString());
    });
  }
}

class HookConsumerBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HookConsumer(builder: (context, ref, _) {
      final state = useState(0);
      return Text(state.value.toString());
    });
  }
}
