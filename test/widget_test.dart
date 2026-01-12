// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:proxmox_companion_app/ui/home_page.dart';

import 'mocks/mock_proxmox_api.dart';

void main() {
  testWidgets('HomePage displays nodes, VMs, and LXCs', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(api: MockProxmoxApi('')), // inject the mock
      ),
    );

    // simulate login
    await tester.enterText(find.byKey(Key('usernameField')), 'user');
    await tester.enterText(find.byKey(Key('passwordField')), 'pass');
    await tester.tap(find.byKey(Key('loginButton')));

    // Wait for async widgets to load
    await tester.pumpAndSettle();

    // Verify HomePage title or key exists
    expect(find.text('Proxmox Companion'), findsOneWidget);

    // Example: check that at least one node tile is displayed
    expect(find.byType(ExpansionTile), findsWidgets);

    // expand first node to show VMs and LXCs
    await tester.tap(find.text('Node: node1'));
    await tester.pumpAndSettle();

    // Example: check that a VM ListTile exists
    expect(find.byIcon(Icons.computer), findsWidgets);

    // Example: check that an LXC ListTile exists
    expect(find.byIcon(Icons.storage), findsWidgets);

    // Optional: tap on first node to expand
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();

    // Check that VMs and LXCs appear under the node
    expect(find.byType(ListTile), findsWidgets);
  });
}
