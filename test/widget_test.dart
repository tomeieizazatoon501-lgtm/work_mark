import 'package:flame/game.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/runner_demo.dart';

void main() {
  testWidgets('home presents the minigame and puzzle in separate channels', (
    tester,
  ) async {
    await tester.pumpWidget(const EscapeApp());

    expect(find.text('CHANNEL 01 · MINI GAME'), findsOneWidget);
    expect(find.text('CHANNEL 02 · PUZZLE'), findsOneWidget);
    expect(find.text('มินิเกมหนีออกจากอาคาร'), findsOneWidget);
    expect(find.text('พัซเซิลตอบคำถาม'), findsOneWidget);
    expect(find.byKey(const Key('runner-card-button')), findsOneWidget);
    expect(find.byKey(const Key('fire-demo-button')), findsOneWidget);
  });

  testWidgets('fire decision demo scores correct choices', (tester) async {
    await tester.pumpWidget(const EscapeApp());
    await tester.pumpAndSettle();
    final fireDemoButton = find.byKey(const Key('fire-demo-button'));
    await tester.ensureVisible(fireDemoButton);
    await tester.pumpAndSettle();
    await tester.tap(fireDemoButton);
    await tester.pumpAndSettle();

    expect(find.text('สถานการณ์ 1 / 3'), findsOneWidget);
    await _answerAndContinue(tester, answerIndex: 0);
    expect(find.text('สถานการณ์ 2 / 3'), findsOneWidget);

    await _answerAndContinue(tester, answerIndex: 1);
    expect(find.text('สถานการณ์ 3 / 3'), findsOneWidget);

    await _answerAndContinue(tester, answerIndex: 2);
    expect(find.text('คุณตอบถูก 3 จาก 3 สถานการณ์'), findsOneWidget);
    expect(find.byKey(const Key('quiz-retry-button')), findsOneWidget);
  });

  testWidgets('fire level reaches the debris runner through the exit', (
    tester,
  ) async {
    await tester.pumpWidget(const EscapeApp());
    await tester.pumpAndSettle();

    final runnerButton = find.byKey(const Key('runner-card-button'));
    await tester.ensureVisible(runnerButton);
    await tester.pumpAndSettle();
    await tester.tap(runnerButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    expect(
      find.text('เหตุการณ์จำลอง: ไฟไหม้ในอาคาร เดินตามลูกศรไปยังประตู'),
      findsOneWidget,
    );

    final joystick = find.byKey(const Key('room-virtual-joystick'));
    await tester.ensureVisible(joystick);
    await tester.pump();
    final gesture = await tester.startGesture(tester.getCenter(joystick));
    await gesture.moveBy(const Offset(0, -80));
    await tester.pump();

    for (var frame = 0; frame < 180; frame++) {
      if (find.text('วิ่งฝ่าซากไปจุดปลอดภัย').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 16));
    }

    await gesture.up();
    await tester.pump();

    expect(find.text('วิ่งฝ่าซากไปจุดปลอดภัย'), findsOneWidget);
    expect(find.byKey(const Key('runner-jump-button')), findsOneWidget);

    final gameWidget = tester.widget<GameWidget<EarthquakeEscapeGame>>(
      find.byType(GameWidget<EarthquakeEscapeGame>),
    );
    final game = gameWidget.game!;
    final jumpedObstacles = <DebrisObstacle>{};
    final obstacleHeights = <double>{};
    var sawEscapeDoor = false;

    for (var frame = 0; frame < 1400; frame++) {
      for (final obstacle in game.children.whereType<DebrisObstacle>()) {
        obstacleHeights.add(obstacle.height);
        if (!jumpedObstacles.contains(obstacle) &&
            obstacle.x <= 170 &&
            obstacle.x > 80) {
          if (game.jump()) {
            jumpedObstacles.add(obstacle);
          }
        }
      }

      if (find.text('YOU ESCAPED DAY 1').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 16));
      sawEscapeDoor |= game.children.whereType<EscapeDoor>().isNotEmpty;
      if (game.isFinished) break;
    }

    expect(obstacleHeights, containsAll([48.0, 64.0, 80.0]));
    expect(
      game.score,
      6,
      reason: 'finished=${game.isFinished}, jumped=${jumpedObstacles.length}',
    );
    expect(game.isFinished, isTrue);
    expect(
      sawEscapeDoor,
      isTrue,
      reason: 'score=${game.score}, jumped=${jumpedObstacles.length}',
    );
    expect(find.text('YOU ESCAPED DAY 1'), findsOneWidget);
  });
}

Future<void> _answerAndContinue(
  WidgetTester tester, {
  required int answerIndex,
}) async {
  final answer = find.byKey(Key('answer-$answerIndex'));
  await tester.ensureVisible(answer);
  await tester.tap(answer);
  await tester.pumpAndSettle();

  final nextButton = find.byKey(const Key('scenario-next-button'));
  await tester.ensureVisible(nextButton);
  await tester.tap(nextButton);
  await tester.pumpAndSettle();
}
