# dynamic_view_sizing

## Stolen from [goderbauer/scratchpad](https://github.com/goderbauer/scratchpad/tree/main/dynamic_view_sizing)!

Prototype that demonstrates dynamic view sizing, i.e. the FlutterView is sized
by its content.

In the current implementation, the only existing view is given the following
constraints:

```js
viewConstraints: {
  minHeight: 0,
  maxHeight: Infinity,
}
```

Which are interpreted as follows:

* Width: tight to available space (default behavior)
* Height: minimum size: 0 (allowed to shrink)
* Height: maximum size: Infinity (unconstrained)

Currently the Web needs this engine branch to work:

* https://github.com/flutter/engine/pull/50271
