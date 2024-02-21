import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConsiderationMemoizedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<TooltipState>();
    final objectKey = GlobalObjectKey<TooltipState>("object");
    return Column(
        children: [key, objectKey]
            .map((k) => Tooltip(
                  key: key,
                  message: 'Click me!',
                ))
            .toList());
  }
}

class HookConsiderationMemoizedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useState(0);
    final snapshot =
        useFuture(Future.delayed(Duration(seconds: 5), () => "Hi!"));
    useEffect(() {
      if (snapshot.hasData && snapshot.data != null) {
        state.value = 5;
      }
      return;
    }, [snapshot.hasData]);
    return Text(state.value.toString());
  }
}
