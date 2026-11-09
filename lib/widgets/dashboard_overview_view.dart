import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/vehicle.dart';
import 'registration_plate_badge.dart';
import 'stat_card.dart';
import 'status_badge.dart';

/// Content view for the "Dashboard" tab in the Left Navigation
class DashboardOverviewView extends StatelessWidget {
  final List<Vehicle> vehicles;
  final VoidCallback onViewAllVehicles;
  final VoidCallback onRegisterVehicle;
  final void Function(Vehicle vehicle) onViewDetails;

  const DashboardOverviewView({
    super.key,
    required this.vehicles,
    required this.onViewAllVehicles,
    required this.onRegisterVehicle,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final activeCount = vehicles.where((v) => v.status == 'Active').length;
    final maintenanceCount = vehicles.where((v) => v.status == 'Under Maintenance').length;
    final inactiveCount = vehicles.where((v) => v.status == 'Inactive').length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stat Metrics Row
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              StatCard(
                label: 'Total Fleet',
                value: '${vehicles.length}',
                icon: Icons.directions_car_filled,
                color: AppColors.deepBlue,
              ),
              StatCard(
                label: 'Active Vehicles',
                value: '$activeCount',
                icon: Icons.check_circle_outline,
                color: AppColors.green,
              ),
              StatCard(
                label: 'Under Maintenance',
                value: '$maintenanceCount',
                icon: Icons.build_circle_outlined,
                color: AppColors.maintenance,
              ),
              StatCard(
                label: 'Inactive / Stored',
                value: '$inactiveCount',
                icon: Icons.pause_circle_outline,
                color: AppColors.red,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Two-Column Section: Fleet Breakdown + Quick Registration Callout
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;

              final typeBreakdownCard = Card(
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.xs,
                        children: [
                          const Text('Fleet by Vehicle Type', style: AppTypography.cardHeading),
                          TextButton(
                            onPressed: onViewAllVehicles,
                            child: const Text('View All in Table →'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTypeRow('Car', vehicles.where((v) => v.vehicleType == 'Car').length, vehicles.length),
                      _buildTypeRow('SUV', vehicles.where((v) => v.vehicleType == 'SUV').length, vehicles.length),
                      _buildTypeRow('Truck', vehicles.where((v) => v.vehicleType == 'Truck').length, vehicles.length),
                      _buildTypeRow('Motorcycle', vehicles.where((v) => v.vehicleType == 'Motorcycle').length, vehicles.length),
                      _buildTypeRow('Van', vehicles.where((v) => v.vehicleType == 'Van').length, vehicles.length),
                      _buildTypeRow('Bus', vehicles.where((v) => v.vehicleType == 'Bus').length, vehicles.length),
                    ],
                  ),
                ),
              );

              final quickActionCard = Card(
                color: AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  side: BorderSide(color: AppColors.corporateBlue.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                        ),
                        child: const Icon(Icons.add_circle, color: AppColors.corporateBlue, size: 28),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'Register Vehicle',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepBlue,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Quickly add a new car, truck, or commercial vehicle with registration plate verification and duplicate check.',
                        style: AppTypography.caption.copyWith(fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.corporateBlue,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('New Vehicle Registration'),
                        onPressed: onRegisterVehicle,
                      ),
                    ],
                  ),
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: typeBreakdownCard),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 2, child: quickActionCard),
                  ],
                );
              } else {
                return Column(
                  children: [
                    typeBreakdownCard,
                    const SizedBox(height: AppSpacing.lg),
                    quickActionCard,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Recent Vehicles Table Card
          Card(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    children: [
                      const Text('Recently Registered Vehicles', style: AppTypography.cardHeading),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.table_chart_outlined, size: 16),
                        label: const Text('Open Full Fleet Table'),
                        onPressed: onViewAllVehicles,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vehicles.take(4).length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final v = vehicles[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Row(
                          children: [
                            RegistrationPlateBadge(plateNumber: v.vehicleNumber),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${v.brand} ${v.model} (${v.year})', style: AppTypography.bodyMedium),
                                  Text('${v.company} • ${v.vehicleType}', style: AppTypography.caption),
                                ],
                              ),
                            ),
                            StatusBadge(status: v.status),
                            const SizedBox(width: AppSpacing.md),
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.actionView),
                              tooltip: 'View Overview',
                              onPressed: () => onViewDetails(v),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeRow(String type, int count, int total) {
    final double fraction = total > 0 ? (count / total) : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(type, style: AppTypography.body),
              Text('$count vehicles', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.corporateBlue),
            ),
          ),
        ],
      ),
    );
  }
}
