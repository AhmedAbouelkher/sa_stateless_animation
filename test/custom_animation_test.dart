import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:supercharged/supercharged.dart';
import './widget_tester_extension.dart';

void main() {
  testWidgets("CustomAnimation case1", (WidgetTester tester) async {
    final animation = MaterialApp(
        home: CustomAnimation(
      duration: 100.days,
      tween: 0.tweenTo(100),
      builder: (context, child, value) => Text("$value"),
    ));

    await tester.addAnimationWidget(animation);

    // start of animation
    expect(find.text("0"), findsOneWidget);

    // half time
    await tester.wait(50.days);
    expect(find.text("50"), findsOneWidget);

    // end of animation
    await tester.wait(50.days);
    expect(find.text("100"), findsOneWidget);

    // after animation
    await tester.wait(50.days);
    expect(find.text("100"), findsOneWidget); // still 100
  });

  testWidgets("CustomAnimation child test", (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimation(
      duration: 100.days,
      tween: IntTween(begin: 0, end: 100),
      child: Text("static child"),
      builder: (context, child, value) =>
          Row(children: [Text("$value"), child]),
    ));

    await tester.addAnimationWidget(animation);

    expect(find.text("static child"), findsOneWidget);

    // start of animation
    expect(find.text('0'), findsOneWidget);

    // half time
    await tester.wait(50.days);
    expect(find.text("static child"), findsOneWidget);
    expect(find.text('50'), findsOneWidget);

    // end of animation
    await tester.wait(50.days);
    expect(find.text("static child"), findsOneWidget);
    expect(find.text('100'), findsOneWidget);

    // after animation
    await tester.wait(10.days);
    expect(find.text("static child"), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
  });

  testWidgets("CustomAnimation delay", (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimation(
      delay: 10.days,
      duration: 100.days,
      tween: IntTween(begin: 0, end: 100),
      builder: (context, child, value) => Text("$value"),
    ));

    await tester.addAnimationWidget(animation);

    // delaying
    expect(find.text('0'), findsOneWidget);

    // start of animation / after delay
    await tester.wait(10.days);
    expect(find.text('0'), findsOneWidget);

    // half time
    await tester.wait(50.days);
    expect(find.text('50'), findsOneWidget);

    // end of animation
    await tester.wait(50.days);
    expect(find.text('100'), findsOneWidget);
  });

  testWidgets("CustomAnimation reverse", (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimation(
      control: CustomAnimationControl.PLAY_REVERSE,
      duration: 100.days,
      tween: IntTween(begin: 0, end: 100),
      builder: (context, child, value) => Text("$value"),
    ));

    await tester.addAnimationWidget(animation);

    // start of animation
    expect(find.text('0'), findsOneWidget); // animation is already at start

    // more time
    await tester.wait(10.days);
    expect(find.text('0'), findsOneWidget); // same result
  });

  testWidgets("CustomAnimation startPosition end & reverse",
      (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimation(
      control: CustomAnimationControl.PLAY_REVERSE,
      duration: 100.days,
      tween: IntTween(begin: 0, end: 100),
      startPosition: 1.0,
      builder: (context, child, value) => Text("$value"),
    ));

    await tester.addAnimationWidget(animation);

    // start of animation
    expect(find.text('100'), findsOneWidget);

    // half time
    await tester.wait(50.days);
    expect(find.text('50'), findsOneWidget);

    // end of animation
    await tester.wait(50.days);
    expect(find.text('0'), findsOneWidget);

    // after animation
    await tester.wait(10.days);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets("startPosition middle & stopped", (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimation(
      control: CustomAnimationControl.STOP,
      duration: 100.days,
      tween: IntTween(begin: 0, end: 100),
      startPosition: 0.5,
      builder: (context, child, value) => Text("$value"),
    ));

    await tester.addAnimationWidget(animation);

    // start of animation
    expect(find.text('50'), findsOneWidget);

    await tester.wait(50.days);
    expect(find.text('50'), findsOneWidget);
  });

  testWidgets("CustomAnimation throw assertion error when no tween specified",
      (WidgetTester tester) async {
    expect(
        () => CustomAnimation(
            duration: 1.days, builder: (context, child, value) => Container()),
        throwsAssertionError);
  });

  testWidgets("throw assertion error when no builder or builder specified",
      (WidgetTester tester) async {
    expect(
        () => CustomAnimation(
            duration: 1.days, tween: IntTween(begin: 0, end: 100)),
        throwsAssertionError);
  });
}
