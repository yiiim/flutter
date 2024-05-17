// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_samples/widgets/gesture_detector/gesture_detector.4.dart' as example;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('The gesture is cancelled when the yellow box covers the green box.', (WidgetTester tester) async {
    await tester.pumpWidget(
      const example.DragCancelExampleApp(),
    );
    final Finder greenFinder = find.byType(Container).first;
    final TestGesture drag = await tester.startGesture(tester.getCenter(greenFinder));
    await tester.pump(kLongPressTimeout);
    await drag.moveBy(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('PanUpdate'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await drag.moveBy(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('PanCancel'), findsOneWidget);
    await drag.up();
    await tester.pumpAndSettle();
  });
}
