import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_management/data/mock_vehicles.dart';
import 'package:vehicle_management/main.dart';
import 'package:vehicle_management/screens/login_screen.dart';
import 'package:vehicle_management/screens/vehicle_list_screen.dart';
import 'package:vehicle_management/widgets/delete_confirmation_dialog.dart';
import 'package:vehicle_management/widgets/vehicle_details_dialog.dart';
import 'package:vehicle_management/widgets/vehicle_form_dialog.dart';

void main() {
  testWidgets('App renders LoginScreen without error', (WidgetTester tester) async {
    await tester.pumpWidget(const VehicleManagementApp());
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('VehicleListScreen renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VehicleListScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VehicleListScreen), findsOneWidget);
  });

  testWidgets('VehicleFormDialog renders without error', (WidgetTester tester) async {
    final vehicles = MockVehicleData.getInitialVehicles();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleFormDialog(
            existingVehicles: vehicles,
            onSave: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VehicleFormDialog), findsOneWidget);
  });

  testWidgets('VehicleDetailsDialog renders without error', (WidgetTester tester) async {
    final vehicle = MockVehicleData.getInitialVehicles().first;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleDetailsDialog(
            vehicle: vehicle,
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VehicleDetailsDialog), findsOneWidget);
  });

  testWidgets('DeleteConfirmationDialog renders without error', (WidgetTester tester) async {
    final vehicle = MockVehicleData.getInitialVehicles().first;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeleteConfirmationDialog(
            vehicle: vehicle,
            onConfirm: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DeleteConfirmationDialog), findsOneWidget);
  });
}
