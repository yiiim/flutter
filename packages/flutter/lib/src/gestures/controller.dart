// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'recognizer.dart';

/// The base class for events used to control gestures.
///
/// {@template flutter.gestures.GestureControlEvent}
/// Not all events will be responded to by gestures. In fact, by default,
/// gestures ignore any events. The handling of specific events depends on
/// the type of gesture. For instance:
///
/// * For [GestureControlCancelEvent], [DragGestureRecognizer] and [MultiDragGestureRecognizer]
/// will respond to this event to cancel the current drag.
/// {@endtemplate}
abstract class GestureControlEvent { }

/// An event that instructs the current gesture to be cancelled.
///
/// Gesture recognizers such as [DragGestureRecognizer] and [MultiDragGestureRecognizer]
/// will respond to this event by cancelling the current drag operation.
class GestureControlCancelEvent extends GestureControlEvent {
  /// Creates a [GestureControlCancelEvent].
  ///
  /// The [pointer] parameter specifies the pointer that should be cancelled.
  /// If it is null, all ongoing drags will be cancelled.
  GestureControlCancelEvent({this.pointer});

  /// Specifies the pointer whose drag should be cancelled in [MultiDragGestureRecognizer].
  /// If it is null, all ongoing drags will be cancelled.
  final int? pointer;
}

/// A controller for dispatching control events to gestures.
///
/// This controller can be used to send [GestureControlEvent]
/// control events to gestures.
class GestureController {
  /// The gestures that are listening to the control events.
  ///
  /// This should not be mutated directly. [GestureRecognizer] objects can be added
  /// and removed using [attach] and [detach].
  Iterable<GestureRecognizer> get gestureRecognizer => _gestureRecognizer;
  final List<GestureRecognizer> _gestureRecognizer = <GestureRecognizer>[];

  /// Register the given recognizer with this controller.
  ///
  /// After this function returns, The [dispatch] method on this
  /// controller will dispatch control events to the given gesture.
  void attach(GestureRecognizer recognizer) {
    assert(!_gestureRecognizer.contains(recognizer));
    _gestureRecognizer.add(recognizer);
  }

  /// Unregister the given recognizer with this controller.
  ///
  /// After this function returns, the [dispatch] method on this
  /// controller will no longer dispatch control events to the given gesture.
  void detach(GestureRecognizer recognizer) {
    assert(_gestureRecognizer.contains(recognizer));
    _gestureRecognizer.remove(recognizer);
  }

  /// Dispatch the given control event to all the registered gestures.
  ///
  /// The [gestureRecognizer] parameter can be used to specify a specific
  /// gesture to dispatch the event to. If it is null, the event will be
  /// dispatched to all the registered gestures.
  void dispatch(GestureControlEvent event, {GestureRecognizer? gestureRecognizer}) {
    if (gestureRecognizer != null) {
      assert(_gestureRecognizer.contains(gestureRecognizer));
      gestureRecognizer.handleControlEvent(event);
      return;
    }
    for (final GestureRecognizer gesture in _gestureRecognizer) {
      gesture.handleControlEvent(event);
    }
  }
}
