import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

void useEffectOnce(Dispose? Function() effect) {
  useEffect(effect, const []);
}

void effectOnce(Dispose? Function() effect) {
  useEffect(effect, const []);
}

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
