import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConsiderationMemoizedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<TooltipState>();
    final objectKey = GlobalObjectKey<TooltipState>("object");
    final _ = useMemoized(GlobalKey.new);
    final __ = useMemoized(() => GlobalObjectKey("object_memo"));
    return Column(
        children: [key, objectKey]
            .map((k) => Tooltip(
                  key: key,
                  message: 'Click me!',
                ))
            .toList());
  }
}

class FutureGlobalKeyMemoizedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useState(0);
    final snapshot =
        useFuture(Future.delayed(Duration(seconds: 5), () => GlobalKey()));
    useEffect(() {
      if (snapshot.hasData && snapshot.data != null) {
        state.value = 5;
      }
      return;
    }, [snapshot.hasData]);
    return Text(state.value.toString());
  }
}

final _globalKeyProvider = Provider((ref) => GlobalKey());

class GlobalKeyMemoizedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = ref.watch(_globalKeyProvider);
    return Text(globalKey.toString());
  }
}
