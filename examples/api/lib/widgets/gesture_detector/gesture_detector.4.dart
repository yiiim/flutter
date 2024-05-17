// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const DragCancelExampleApp());
}

class CustomDragBoundaryProvider implements GestureDragBoundaryProvider {
  @override
  DragBoundary getDragBoundary(BuildContext context, Offset initialPosition) {
    return CustomDragBoundary(context);
  }
}

class CustomDragBoundary extends DragBoundary {
  CustomDragBoundary(this.context);
  final BuildContext context;
  @override
  Offset getNearestPositionWithinBoundary(Offset globalLocation) {
    return globalLocation;
  }

  @override
  bool isWithinBoundary(Offset globalLocation) {
    final RenderBox? target = context.findRenderObject() as RenderBox?;
    if (target == null || !target.hasSize) {
      return false;
    }
    final BoxHitTestResult result = BoxHitTestResult();
    WidgetsBinding.instance.hitTestInView(result, target.localToGlobal(Offset.zero), View.of(context).viewId);
    if (result.path.any((HitTestEntry<HitTestTarget> e) => e.target == target)) {
      return true;
    }
    return false;
  }
}

class DragCancelExampleApp extends StatefulWidget {
  const DragCancelExampleApp({super.key});

  @override
  State<StatefulWidget> createState() => DragCancelExampleAppState();
}

class DragCancelExampleAppState extends State<DragCancelExampleApp> {
  String text = '';
  bool visiblity = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 5), () {
      visiblity = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Text(
                      text,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (DragStartDetails details) {
                      text = 'PanStart';
                      setState(() {});
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      text = 'PanUpdate';
                      setState(() {});
                    },
                    onPanEnd: (DragEndDetails details) {
                      text = 'PanEnd';
                      setState(() {});
                    },
                    onPanCancel: () {
                      text = 'PanCancel';
                      setState(() {});
                    },
                    dragBoundaryProviderBuilder: (BuildContext context) {
                      return CustomDragBoundaryProvider();
                    },
                    cancelWhenOutsideBoundary: true,
                    child: Container(
                      color: Colors.green,
                      width: 150.0,
                      height: 150.0,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: visiblity,
                child: Positioned(
                  child: Container(
                    color: Colors.yellow.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
