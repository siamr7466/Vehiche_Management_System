import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../models/vehicle.dart';
import '../services/vehicle_repository.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/dashboard_overview_view.dart';
import '../widgets/delete_action_button.dart';
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

  // Register / Add a new vehicle (Spring Boot applies validation & business rules)
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

  // Edit / Update an existing vehicle (Spring Boot applies validation & business rules)
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

  // Open View Details Dialog
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

  // Open Add / Edit Form Dialog
  void _openVehicleFormDialog([Vehicle? vehicle]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => VehicleFormDialog(
        vehicle: vehicle,
        existingVehicles: _vehicles,
        onSave: (savedVehicle) async {
          if (vehicle == null) {
            await _addVehicle(savedVehicle);
          } else {
            await _updateVehicle(savedVehicle);
          }
        },
      ),
    );
  }

  // Open Delete Confirmation Dialog
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 850;
        final currentPageName = _currentPage == NavPage.dashboard ? 'Dashboard' : 'Vehicles';

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          drawer: isDesktop
              ? null
              : Drawer(
                  child: AppSidebar(
                    selectedPage: _currentPage,
                    onPageSelected: (page) => setState(() => _currentPage = page),
                    onRegisterVehiclePressed: () => _openVehicleFormDialog(),
                    isDrawer: true,
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
                ),

              // 2. MAIN WORKSPACE AREA (Right)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar (Breadcrumbs, Refresh, Notifications, Profile)
                    AppTopBar(
                      currentPageName: currentPageName,
                      showMenuButton: !isDesktop,
                      onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      onRefresh: _loadVehicles,
                    ),

                    // Main Content Workspace
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _errorMessage != null && _vehicles.isEmpty
                                ? _buildErrorState()
                                : _buildCurrentPageContent(),
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

  Widget _buildCurrentPageContent() {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page Header for Vehicles List
        PageHeader(
          title: 'Vehicle Fleet',
          subtitle: 'Search, filter, inspect details, update records, and manage all registered vehicles',
          actionLabel: 'Register Vehicle',
          onAction: () => _openVehicleFormDialog(),
        ),

        // Metrics Summary Row
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            StatCard(
              label: 'Total Fleet',
              value: '${_vehicles.length}',
              icon: Icons.directions_car_filled,
              color: AppColors.primary,
            ),
            StatCard(
              label: 'Active',
              value: '${_vehicles.where((v) => v.status == "Active").length}',
              icon: Icons.check_circle_outline,
              color: AppColors.active,
            ),
            StatCard(
              label: 'In Maintenance',
              value: '${_vehicles.where((v) => v.status == "Under Maintenance").length}',
              icon: Icons.build_circle_outlined,
              color: AppColors.maintenance,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Search & Filter Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 720) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by registration number, make, model, owner...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (val) {
                            setState(() => _searchQuery = val.trim());
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _buildFilterDropdown(
                        label: 'Type',
                        value: _selectedTypeFilter,
                        items: ['All', ...AppConstants.vehicleTypes],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTypeFilter = val);
                        },
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _buildFilterDropdown(
                        label: 'Status',
                        value: _selectedStatusFilter,
                        items: ['All', ...AppConstants.vehicleStatuses],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedStatusFilter = val);
                        },
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          '${filtered.length} found',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by registration number, make, model...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          setState(() => _searchQuery = val.trim());
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterDropdown(
                              label: 'Type',
                              value: _selectedTypeFilter,
                              items: ['All', ...AppConstants.vehicleTypes],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedTypeFilter = val);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildFilterDropdown(
                              label: 'Status',
                              value: _selectedStatusFilter,
                              items: ['All', ...AppConstants.vehicleStatuses],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedStatusFilter = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Main Table Area
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          style: AppTypography.bodyMedium.copyWith(fontSize: 13),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item == 'All' ? '$label: All' : item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car_outlined, size: 48, color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('No matching vehicles found', style: AppTypography.cardTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _vehicles.isEmpty
                ? 'Register your first vehicle to begin managing the fleet.'
                : 'Try adjusting your search keywords or filter criteria.',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.inactive.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.inactive),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Unable to connect to backend', style: AppTypography.cardTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _errorMessage ?? 'Check if the Spring Boot server is running on port 8080.',
            textAlign: TextAlign.center,
            style: AppTypography.caption,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: _loadVehicles,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md + 2,
      ),
      child: Text(
        title,
        textAlign: align,
        style: AppTypography.tableHeader,
      ),
    );
  }

  Widget _buildTableView(List<Vehicle> filtered) {
    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return _buildMobileCardList(filtered);
        }

        final targetTableWidth = constraints.maxWidth > 950 ? constraints.maxWidth : 950.0;

        return Card(
          clipBehavior: Clip.antiAlias,
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
                    2: FlexColumnWidth(1.0), // Type
                    3: FlexColumnWidth(1.2), // Brand
                    4: FlexColumnWidth(1.3), // Model
                    5: FlexColumnWidth(1.2), // Status
                    6: FlexColumnWidth(1.4), // Actions
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // Header Row: Exactly matches master prompt fields
                    TableRow(
                      decoration: const BoxDecoration(
                        color: AppColors.tableHeaderBg,
                        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.2)),
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
                          border: const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
                        ),
                        children: [
                          // 1. Vehicle Registration Plate Badge
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: RegistrationPlateBadge(plateNumber: v.vehicleNumber),
                            ),
                          ),
                          // 2. Company
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Text(
                              v.company,
                              style: AppTypography.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 3. Type
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Text(v.vehicleType, style: AppTypography.body),
                          ),
                          // 4. Brand
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Text(v.brand, style: AppTypography.bodyMedium),
                          ),
                          // 5. Model
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Text(v.model, style: AppTypography.body),
                          ),
                          // 6. Status Pill
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: StatusBadge(status: v.status),
                            ),
                          ),
                          // 7. Actions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs + 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.visibility_outlined,
                                    color: AppColors.actionView,
                                    size: 19,
                                  ),
                                  tooltip: 'View Details',
                                  onPressed: () => _openViewDetailsDialog(v),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: AppColors.actionEdit,
                                    size: 19,
                                  ),
                                  tooltip: 'Edit Vehicle',
                                  onPressed: () => _openVehicleFormDialog(v),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                DeleteActionButton(
                                  isCompact: true,
                                  onPressed: () => _openDeleteConfirmDialog(v),
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
        );
      },
    );
  }

  // Responsive Mobile Cards View
  Widget _buildMobileCardList(List<Vehicle> list) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final v = list[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                const SizedBox(height: AppSpacing.md),
                Text(
                  '${v.brand} ${v.model} (${v.year})',
                  style: AppTypography.cardTitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${v.company} • ${v.vehicleType}',
                  style: AppTypography.caption,
                ),
                const Divider(height: AppSpacing.xxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.visibility_outlined, size: 16, color: AppColors.actionView),
                      label: Text('View', style: AppTypography.caption.copyWith(color: AppColors.actionView, fontWeight: FontWeight.bold)),
                      onPressed: () => _openViewDetailsDialog(v),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.actionEdit),
                      label: Text('Edit', style: AppTypography.caption.copyWith(color: AppColors.actionEdit, fontWeight: FontWeight.bold)),
                      onPressed: () => _openVehicleFormDialog(v),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    DeleteActionButton(
                      onPressed: () => _openDeleteConfirmDialog(v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
