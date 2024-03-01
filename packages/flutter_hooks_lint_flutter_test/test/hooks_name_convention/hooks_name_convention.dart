import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "custom_hooks.dart";

class CorrectMethodWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffectOnce(() {
      return;
    });
    return Text('');
  }
}

class WrongMethodWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    effectOnce(() {
      return;
    });
    return Text('');
  }
}
