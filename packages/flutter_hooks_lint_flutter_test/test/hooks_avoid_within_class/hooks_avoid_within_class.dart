import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void useEffectOnce(Dispose? Function() effect) {
  useEffect(effect, const []);
}

class TestHelper {
  const TestHelper._();

  static void useEffectOnce(Dispose? Function() effect) {
    useEffect(effect, const []);
  }

  void showTestModalBottomSheet({
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
          final state = useState(0);
          return Text(state.value.toString());
        });
      },
    );
  }
}
