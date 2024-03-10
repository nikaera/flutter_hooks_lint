import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'src/custom_hooks.dart';

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

class ClassCustomHookWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    TestHelper.useEffectOnce(() {
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

class UnuseHookBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      return Text('');
    });
  }
}

class UnuseHookConsumerBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HookConsumer(builder: (context, ref, _) {
      return Text('');
    });
  }
}

void useShowLanguageSelectSheet({
  required BuildContext context,
}) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return HookConsumer(builder: (context, ref, child) {
        return Text("");
      });
    },
  );
}
