import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';

class VerifyStudentsScreen extends StatefulWidget {
  const VerifyStudentsScreen({super.key});

  @override
  State<VerifyStudentsScreen> createState() => _VerifyStudentsScreenState();
}

class _VerifyStudentsScreenState extends State<VerifyStudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  String _filterStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Call API
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _students = [
        {
          'id': 1,
          'name': 'Jean Dupont',
          'email': 'jean.dupont@example.com',
          'classroom': 'L3 Info',
          'studentId': 'STU001',
          'verified': true,
        },
        {
          'id': 2,
          'name': 'Marie Martin',
          'email': 'marie.martin@example.com',
          'classroom': 'L3 Info',
          'studentId': 'STU002',
          'verified': false,
        },
        {
          'id': 3,
          'name': 'Pierre Durand',
          'email': 'pierre.durand@example.com',
          'classroom': 'M1 Génie Logiciel',
          'studentId': 'STU003',
          'verified': true,
        },
        {
          'id': 4,
          'name': 'Sophie Bernard',
          'email': 'sophie.bernard@example.com',
          'classroom': 'L3 Info',
          'studentId': 'STU004',
          'verified': false,
        },
        {
          'id': 5,
          'name': 'Luc Petit',
          'email': 'luc.petit@example.com',
          'classroom': 'M1 Génie Logiciel',
          'studentId': 'STU005',
          'verified': false,
        },
      ];
      
      _filteredStudents = _students;
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students.where((student) {
        final matchesSearch = student['name'].toString().toLowerCase().contains(query) ||
            student['email'].toString().toLowerCase().contains(query) ||
            student['studentId'].toString().toLowerCase().contains(query);
        
        final matchesStatus = _filterStatus == 'ALL' ||
            (_filterStatus == 'VERIFIED' && student['verified'] == true) ||
            (_filterStatus == 'UNVERIFIED' && student['verified'] == false);
        
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _toggleVerification(Map<String, dynamic> student) async {
    try {
      // TODO: Call API
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        final index = _students.indexWhere((s) => s['id'] == student['id']);
        if (index != -1) {
          _students[index]['verified'] = !_students[index]['verified'];
        }
        _filterStudents();
      });
      
      if (mounted) {
        SnackbarUtils.showSuccess(
          context,
          student['verified']
              ? 'Étudiant vérifié'
              : 'Vérification annulée',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    }
  }

  int get _verifiedCount => _students.where((s) => s['verified'] == true).length;
  int get _unverifiedCount => _students.where((s) => s['verified'] == false).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Vérifier les Étudiants',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStudents,
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Card
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            color: AppColors.kWhite,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    _students.length.toString(),
                    Icons.people,
                    AppColors.kPrimary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: AppColors.kGreyLight,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Vérifiés',
                    _verifiedCount.toString(),
                    Icons.verified_user,
                    AppColors.kSuccess,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: AppColors.kGreyLight,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Non vérifiés',
                    _unverifiedCount.toString(),
                    Icons.pending,
                    AppColors.kWarning,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            color: AppColors.kWhite,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, email ou ID...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                filled: true,
                fillColor: AppColors.kBackground,
              ),
            ),
          ),

          // Filters
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            color: AppColors.kWhite,
            child: Row(
              children: [
                _buildFilterChip('ALL', 'Tous'),
                SizedBox(width: AppSpacing.sm),
                _buildFilterChip('VERIFIED', 'Vérifiés'),
                SizedBox(width: AppSpacing.sm),
                _buildFilterChip('UNVERIFIED', 'Non vérifiés'),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          // Students List
          Expanded(
            child: _isLoading
                ? const LoadingWidget()
                : _filteredStudents.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadStudents,
                        child: ListView.builder(
                          padding: EdgeInsets.all(AppSpacing.md),
                          itemCount: _filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = _filteredStudents[index];
                            return _buildStudentCard(student);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.kHeading3.copyWith(color: color),
        ),
        Text(
          label,
          style: AppTypography.kCaption.copyWith(color: AppColors.kGrey),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
          _filterStudents();
        });
      },
      backgroundColor: AppColors.kWhite,
      selectedColor: AppColors.kPrimary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.kPrimary : AppColors.kGrey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final isVerified = student['verified'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
        border: Border.all(
          color: isVerified
              ? AppColors.kSuccess.withOpacity(0.3)
              : AppColors.kWarning.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isVerified
                      ? AppColors.kSuccess
                      : AppColors.kWarning,
                  child: Text(
                    student['name'].toString()[0].toUpperCase(),
                    style: TextStyle(color: AppColors.kWhite),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['name'].toString(),
                        style: AppTypography.kHeading4,
                      ),
                      Text(
                        student['email'].toString(),
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isVerified ? AppColors.kSuccess : AppColors.kWarning,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVerified ? Icons.check_circle : Icons.pending,
                        color: AppColors.kWhite,
                        size: 16.sp,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        isVerified ? 'Vérifié' : 'En attente',
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Icon(Icons.badge, size: 20.sp, color: AppColors.kGrey),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'ID: ${student['studentId']}',
                  style: AppTypography.kBody2.copyWith(
                    color: AppColors.kGrey,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Icon(Icons.class_, size: 20.sp, color: AppColors.kGrey),
                SizedBox(width: AppSpacing.xs),
                Text(
                  student['classroom'].toString(),
                  style: AppTypography.kBody2.copyWith(
                    color: AppColors.kGrey,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            PrimaryButton(
              text: isVerified ? 'Annuler la vérification' : 'Vérifier l\'étudiant',
              onPressed: () => _toggleVerification(student),
              backgroundColor: isVerified ? AppColors.kError : AppColors.kSuccess,
              icon: isVerified ? Icons.cancel : Icons.check_circle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucun étudiant trouvé',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Essayez de modifier vos critères de recherche',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }
}
