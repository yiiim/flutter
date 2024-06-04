// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const DragCancelExampleApp());
}

class DragCancelExampleApp extends StatefulWidget {
  const DragCancelExampleApp({super.key});

  @override
  State<StatefulWidget> createState() => DragCancelExampleAppState();
}

class DragCancelExampleAppState extends State<DragCancelExampleApp> {
  String text = '';
  bool visiblity = false;
  final GestureController _controller = GestureController();
  bool _stopCheck = true;
  RenderBox? _target;
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(
      const Duration(seconds: 5),
      () {
        if (!mounted) {
          return;
        }
        visiblity = true;
        setState(() {});
      },
    );
  }

  void _check() {
    if (_stopCheck || !mounted || _target == null || !_target!.hasSize) {
      return;
    }
    final BoxHitTestResult result = BoxHitTestResult();
    WidgetsBinding.instance.hitTestInView(result, _target!.localToGlobal(Offset.zero), View.of(context).viewId);
    if (!result.path.any((HitTestEntry<HitTestTarget> e) => e.target == _target)) {
      _controller.dispatch(GestureControlCancelEvent());
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _check();
    });
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
                    controller: _controller,
                    onPanStart: (DragStartDetails details) {
                      _stopCheck = false;
                      _check();
                      text = 'PanStart';
                      setState(() {});
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      text = 'PanUpdate';
                      setState(() {});
                    },
                    onPanEnd: (DragEndDetails details) {
                      _stopCheck = true;
                      text = 'PanEnd';
                      setState(() {});
                    },
                    onPanCancel: () {
                      _stopCheck = true;
                      text = 'PanCancel';
                      setState(() {});
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _target = context.findRenderObject() as RenderBox?;
                        });
                        return Container(
                          color: Colors.blueAccent,
                          width: 150.0,
                          height: 150.0,
                        );
                      },
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
