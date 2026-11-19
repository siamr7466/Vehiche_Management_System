import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../models/vehicle.dart';
import '../services/vehicle_repository.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/dashboard_overview_view.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/page_header.dart';
import '../widgets/registration_plate_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/vehicle_details_dialog.dart';
import '../widgets/vehicle_form_dialog.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleRepository _repository = VehicleRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  NavPage _currentPage = NavPage.vehicles; // Default to Vehicles list
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedTypeFilter = 'All';
  String _selectedStatusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _repository.getVehicles();
      setState(() {
        _vehicles = List.from(data);
        _isLoading = false;
      });
    } catch (e) {
      final err = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _errorMessage = err;
        _isLoading = false;
      });
      _showSnackBar(err, AppColors.inactive);
    }
  }

  // Register / Add a new vehicle
  Future<void> _addVehicle(Vehicle vehicle) async {
    try {
      final created = await _repository.addVehicle(vehicle);
      setState(() => _vehicles.add(created));
      _showSnackBar(
        'Vehicle "${vehicle.vehicleNumber}" registered successfully!',
        AppColors.active,
      );
    } catch (e) {
      final err = e.toString().replaceFirst('Exception: ', '');
      _showSnackBar(err, AppColors.inactive);
      rethrow;
    }
  }

  // Edit / Update an existing vehicle
  Future<void> _updateVehicle(Vehicle vehicle) async {
    if (vehicle.id == null) return;

    try {
      final updated = await _repository.updateVehicle(vehicle);
      setState(() {
        final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
        if (index != -1) _vehicles[index] = updated;
      });
      _showSnackBar(
        'Vehicle "${vehicle.vehicleNumber}" updated successfully!',
        AppColors.active,
      );
    } catch (e) {
      final err = e.toString().replaceFirst('Exception: ', '');
      _showSnackBar(err, AppColors.inactive);
      rethrow;
    }
  }

  // Delete a vehicle
  Future<void> _deleteVehicle(Vehicle vehicle) async {
    if (vehicle.id == null) return;

    try {
      await _repository.deleteVehicle(vehicle.id!);
      setState(() => _vehicles.removeWhere((v) => v.id == vehicle.id));
      _showSnackBar(
        'Vehicle "${vehicle.vehicleNumber}" deleted successfully!',
        AppColors.maintenance,
      );
    } catch (e) {
      final err = e.toString().replaceFirst('Exception: ', '');
      _showSnackBar(err, AppColors.inactive);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusBadge + 2),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _openViewDetailsDialog(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (ctx) => VehicleDetailsDialog(
        vehicle: vehicle,
        onEdit: () => _openVehicleFormDialog(vehicle),
        onDelete: () => _openDeleteConfirmDialog(vehicle),
      ),
    );
  }

  void _openVehicleFormDialog([Vehicle? vehicle]) {
    showDialog(
      context: context,
      builder: (ctx) => VehicleFormDialog(
        vehicle: vehicle,
        existingVehicles: _vehicles,
        onSave: (v) async {
          if (vehicle == null) {
            await _addVehicle(v);
          } else {
            await _updateVehicle(v);
          }
        },
      ),
    );
  }

  void _openDeleteConfirmDialog(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteConfirmationDialog(
        vehicle: vehicle,
        onConfirm: () => _deleteVehicle(vehicle),
      ),
    );
  }

  List<Vehicle> get _filteredVehicles {
    return _vehicles.where((v) {
      final matchesSearch = _searchQuery.isEmpty ||
          v.vehicleNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.company.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.model.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.ownerName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesType = _selectedTypeFilter == 'All' ||
          v.vehicleType.toLowerCase() == _selectedTypeFilter.toLowerCase();

      final matchesStatus = _selectedStatusFilter == 'All' ||
          v.status.toLowerCase() == _selectedStatusFilter.toLowerCase();

      return matchesSearch && matchesType && matchesStatus;
    }).toList();
  }

  IconData _getVehicleTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'suv':
        return Icons.airport_shuttle_rounded;
      case 'truck':
        return Icons.local_shipping_rounded;
      case 'motorcycle':
        return Icons.two_wheeler_rounded;
      case 'van':
        return Icons.directions_bus_filled_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 850;
        final currentPageName = _currentPage == NavPage.dashboard ? 'Dashboard' : 'Vehicles';

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF8FAFC), // Modern Soft Slate Background
          drawer: isDesktop
              ? null
              : Drawer(
                  child: AppSidebar(
                    selectedPage: _currentPage,
                    onPageSelected: (page) => setState(() => _currentPage = page),
                    onRegisterVehiclePressed: () => _openVehicleFormDialog(),
                    isDrawer: true,
                    vehicleCount: _vehicles.length,
                  ),
                ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. LEFT SIDEBAR NAVIGATION (Desktop)
              if (isDesktop)
                AppSidebar(
                  selectedPage: _currentPage,
                  onPageSelected: (page) => setState(() => _currentPage = page),
                  onRegisterVehiclePressed: () => _openVehicleFormDialog(),
                  vehicleCount: _vehicles.length,
                ),

              // 2. MAIN WORKSPACE AREA (Right)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar (Breadcrumbs, System Status, Notifications, Profile)
                    AppTopBar(
                      currentPageName: currentPageName,
                      showMenuButton: !isDesktop,
                      onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      onRefresh: _loadVehicles,
                    ),

                    // Main Content Workspace
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(isDesktop ? 28.0 : 16.0),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFF2563EB),
                                ),
                              )
                            : _errorMessage != null && _vehicles.isEmpty
                                ? _buildErrorState()
                                : _buildCurrentPageContent(isDesktop: isDesktop),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentPageContent({bool isDesktop = true}) {
    if (_currentPage == NavPage.dashboard) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Page Header for Dashboard
          PageHeader(
            title: 'Fleet Dashboard',
            subtitle: 'Real-time overview of fleet statistics, distribution, and recent updates',
            actionLabel: 'Register Vehicle',
            onAction: () => _openVehicleFormDialog(),
          ),
          Expanded(
            child: DashboardOverviewView(
              vehicles: _vehicles,
              onViewAllVehicles: () => setState(() => _currentPage = NavPage.vehicles),
              onRegisterVehicle: () => _openVehicleFormDialog(),
              onViewDetails: (v) => _openViewDetailsDialog(v),
            ),
          ),
        ],
      );
    }

    // Default: Vehicles Fleet List Tab
    final filtered = _filteredVehicles;
    final totalCount = _vehicles.length;
    final activeCount = _vehicles.where((v) => v.status == 'Active').length;
    final maintCount = _vehicles.where((v) => v.status == 'Under Maintenance').length;
    final inactiveCount = _vehicles.where((v) => v.status == 'Inactive').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page Header for Vehicles List
        PageHeader(
          title: 'Vehicle Fleet',
          subtitle: 'Search, filter, inspect details, update records, and manage all registered fleet assets',
          actionLabel: 'Register Vehicle',
          onAction: () => _openVehicleFormDialog(),
        ),

        // 1. Modern Responsive Metrics Cards (Spans full width)
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final cardTotal = StatCard(
              label: 'Total Fleet',
              value: '$totalCount',
              icon: Icons.directions_car_filled_rounded,
              color: const Color(0xFF2563EB),
              subtitle: '100% telemetry synced',
            );
            final cardActive = StatCard(
              label: 'Active Vehicles',
              value: '$activeCount',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF10B981),
              subtitle: totalCount > 0
                  ? '${((activeCount / totalCount) * 100).toInt()}% operational'
                  : '0% operational',
            );
            final cardMaint = StatCard(
              label: 'In Maintenance',
              value: '$maintCount',
              icon: Icons.build_circle_rounded,
              color: const Color(0xFFF59E0B),
              subtitle: 'Scheduled servicing',
            );
            final cardInactive = StatCard(
              label: 'Inactive / Idle',
              value: '$inactiveCount',
              icon: Icons.pause_circle_rounded,
              color: const Color(0xFF64748B),
              subtitle: 'Standby capacity',
            );

            if (isWide) {
              return Row(
                children: [
                  Expanded(child: cardTotal),
                  const SizedBox(width: 14),
                  Expanded(child: cardActive),
                  const SizedBox(width: 14),
                  Expanded(child: cardMaint),
                  const SizedBox(width: 14),
                  Expanded(child: cardInactive),
                ],
              );
            } else {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [cardTotal, cardActive, cardMaint, cardInactive],
              );
            }
          },
        ),
        const SizedBox(height: 20),

        // 2. Modern Search & Filter Bar
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x04000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;
              final searchField = TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Search by registration number, make, model, owner...',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF64748B)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                  ),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val.trim());
                },
              );

              final typeDropdown = _buildFilterDropdown(
                label: 'Type',
                value: _selectedTypeFilter,
                items: ['All', ...AppConstants.vehicleTypes],
                icon: Icons.directions_car_outlined,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTypeFilter = val);
                },
              );

              final statusDropdown = _buildFilterDropdown(
                label: 'Status',
                value: _selectedStatusFilter,
                items: ['All', ...AppConstants.vehicleStatuses],
                icon: Icons.traffic_rounded,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStatusFilter = val);
                },
              );

              final countBadge = Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  '${filtered.length} found',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 12),
                    typeDropdown,
                    const SizedBox(width: 12),
                    statusDropdown,
                    const SizedBox(width: 12),
                    countBadge,
                    if (_searchQuery.isNotEmpty ||
                        _selectedTypeFilter != 'All' ||
                        _selectedStatusFilter != 'All') ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_off_rounded, size: 20, color: Color(0xFFEF4444)),
                        tooltip: 'Reset all filters',
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _selectedTypeFilter = 'All';
                            _selectedStatusFilter = 'All';
                          });
                        },
                      ),
                    ],
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: typeDropdown),
                        const SizedBox(width: 10),
                        Expanded(child: statusDropdown),
                        const SizedBox(width: 10),
                        countBadge,
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
        const SizedBox(height: 20),

        // 3. Main Modern Fleet Table Area
        Expanded(
          child: _buildTableView(filtered),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 19),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w500,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 15, color: const Color(0xFF64748B)),
                    const SizedBox(width: 6),
                  ],
                  Text(item == 'All' ? '$label: All' : item),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car_outlined,
                size: 48,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No matching vehicles found',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _vehicles.isEmpty
                  ? 'Register your first vehicle to begin tracking your fleet.'
                  : 'Try adjusting your search query or reset the filter dropdowns.',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Register Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _openVehicleFormDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to connect to backend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _errorMessage ?? 'Check if the backend server is reachable.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _loadVehicles,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String title, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        title,
        textAlign: align,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF475569), // Slate 600
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildTableView(List<Vehicle> filtered) {
    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 780) {
          return _buildMobileCardList(filtered);
        }

        final targetTableWidth = constraints.maxWidth > 950 ? constraints.maxWidth : 950.0;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: targetTableWidth,
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1.6), // Vehicle No.
                          1: FlexColumnWidth(1.5), // Company
                          2: FlexColumnWidth(1.1), // Type
                          3: FlexColumnWidth(1.2), // Brand
                          4: FlexColumnWidth(1.3), // Model
                          5: FlexColumnWidth(1.2), // Status
                          6: FlexColumnWidth(1.4), // Actions
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          // Modern Table Header Row
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
                            ),
                            children: [
                              _buildHeaderCell('VEHICLE NO.'),
                              _buildHeaderCell('COMPANY'),
                              _buildHeaderCell('TYPE'),
                              _buildHeaderCell('BRAND'),
                              _buildHeaderCell('MODEL'),
                              _buildHeaderCell('STATUS'),
                              _buildHeaderCell('ACTIONS', align: TextAlign.center),
                            ],
                          ),
                          // Data Rows
                          ...filtered.asMap().entries.map((entry) {
                            final index = entry.key;
                            final v = entry.value;
                            final isEven = index % 2 == 0;

                            return TableRow(
                              decoration: BoxDecoration(
                                color: isEven ? Colors.white : const Color(0xFFFAFCFF),
                                border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                              ),
                              children: [
                                // 1. Vehicle Registration Plate Badge
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RegistrationPlateBadge(plateNumber: v.vehicleNumber),
                                  ),
                                ),

                                // 2. Company
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.business_rounded,
                                          size: 14,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          v.company,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF0F172A),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 3. Type
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getVehicleTypeIcon(v.vehicleType),
                                        size: 15,
                                        color: const Color(0xFF64748B),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        v.vehicleType,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF475569),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 4. Brand
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Text(
                                    v.brand,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ),

                                // 5. Model
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Text(
                                    v.model,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF475569),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                // 6. Status Pill
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: StatusBadge(status: v.status),
                                  ),
                                ),

                                // 7. Modern Actions Button Group
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // View Action
                                      _buildTableActionButton(
                                        icon: Icons.visibility_outlined,
                                        tooltip: 'View Details',
                                        iconColor: const Color(0xFF0F766E), // Teal 700
                                        bgColor: const Color(0xFFF0FDFA),
                                        borderColor: const Color(0xFFCCFBF1),
                                        onTap: () => _openViewDetailsDialog(v),
                                      ),
                                      const SizedBox(width: 8),

                                      // Edit Action
                                      _buildTableActionButton(
                                        icon: Icons.edit_outlined,
                                        tooltip: 'Edit Vehicle',
                                        iconColor: const Color(0xFF2563EB), // Blue 600
                                        bgColor: const Color(0xFFEFF6FF),
                                        borderColor: const Color(0xFFDBEAFE),
                                        onTap: () => _openVehicleFormDialog(v),
                                      ),
                                      const SizedBox(width: 8),

                                      // Delete Action
                                      _buildTableActionButton(
                                        icon: Icons.delete_outline_rounded,
                                        tooltip: 'Delete Vehicle',
                                        iconColor: const Color(0xFFDC2626), // Red 600
                                        bgColor: const Color(0xFFFEF2F2),
                                        borderColor: const Color(0xFFFECACA),
                                        onTap: () => _openDeleteConfirmDialog(v),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Modern Table Footer: Summary & Real-time Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${filtered.length} of ${_vehicles.length} registered vehicles',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: _loadVehicles,
                      borderRadius: BorderRadius.circular(6),
                      child: const Row(
                        children: [
                          Icon(Icons.sync_rounded, size: 14, color: Color(0xFF2563EB)),
                          SizedBox(width: 4),
                          Text(
                            'Synced with server',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableActionButton({
    required IconData icon,
    required String tooltip,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Center(
              child: Icon(icon, size: 16, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }

  // Responsive Mobile Cards View
  Widget _buildMobileCardList(List<Vehicle> list) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final v = list[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RegistrationPlateBadge(plateNumber: v.vehicleNumber),
                  StatusBadge(status: v.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(_getVehicleTypeIcon(v.vehicleType), size: 16, color: const Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Text(
                    '${v.brand} ${v.model} (${v.year})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${v.company} • ${v.vehicleType}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                ),
              ),
              const Divider(color: Color(0xFFF1F5F9), height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTableActionButton(
                    icon: Icons.visibility_outlined,
                    tooltip: 'View Details',
                    iconColor: const Color(0xFF0F766E),
                    bgColor: const Color(0xFFF0FDFA),
                    borderColor: const Color(0xFFCCFBF1),
                    onTap: () => _openViewDetailsDialog(v),
                  ),
                  const SizedBox(width: 8),
                  _buildTableActionButton(
                    icon: Icons.edit_outlined,
                    tooltip: 'Edit Vehicle',
                    iconColor: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    borderColor: const Color(0xFFDBEAFE),
                    onTap: () => _openVehicleFormDialog(v),
                  ),
                  const SizedBox(width: 8),
                  _buildTableActionButton(
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Delete Vehicle',
                    iconColor: const Color(0xFFDC2626),
                    bgColor: const Color(0xFFFEF2F2),
                    borderColor: const Color(0xFFFECACA),
                    onTap: () => _openDeleteConfirmDialog(v),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
