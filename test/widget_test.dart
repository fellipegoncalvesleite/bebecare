import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bebecare/main.dart';
import 'package:bebecare/services/app_state.dart';

void main() {
  testWidgets('App boots and shows the home greeting', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('pt_BR', null);

    final appState = AppState();
    await appState.load();

    await tester.pumpWidget(BebeCareApp(appState: appState));
    await tester.pump(const Duration(seconds: 1));

    expect(find.textContaining('Olá'), findsOneWidget);
    expect(find.text('Crescimento'), findsWidgets);
  });
}
