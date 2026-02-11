import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/custom_text_field.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/position_model.dart';

class CreateElectionScreen extends StatefulWidget {
  const CreateElectionScreen({super.key});

  @override
  State<CreateElectionScreen> createState() => _CreateElectionScreenState();
}

class _CreateElectionScreenState extends State<CreateElectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _classroomController = TextEditingController();
  
  bool _isCommitteeVote = false;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<PositionModel> _positions = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _classroomController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );

        setState(() {
          if (isStartDate) {
            _startDate = dateTime;
          } else {
            _endDate = dateTime;
          }
        });
      }
    }
  }

  void _addPosition() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(
            'Ajouter un Poste',
            style: AppTypography.kHeading3,
          ),
          content: CustomTextField(
            controller: controller,
            label: 'Nom du poste',
            hint: 'Ex: Président, Vice-Président...',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: TextStyle(color: AppColors.kGrey),
              ),
            ),
            PrimaryButton(
              text: 'Ajouter',
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _positions.add(
                      PositionModel(
                        id: _positions.length + 1,
                        name: controller.text,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _removePosition(int index) {
    setState(() {
      _positions.removeAt(index);
    });
  }

  Future<void> _createElection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_positions.isEmpty) {
      SnackbarUtils.showError(context, 'Ajoutez au moins un poste');
      return;
    }

    if (_startDate == null || _endDate == null) {
      SnackbarUtils.showError(context, 'Sélectionnez les dates de début et fin');
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      SnackbarUtils.showError(context, 'La date de fin doit être après la date de début');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Call API to create election
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        SnackbarUtils.showSuccess(context, 'Élection créée avec succès');
        Navigator.pop(context, true);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: const CustomAppBar(
        title: 'Créer une Élection',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            // Title
            CustomTextField(
              controller: _titleController,
              label: 'Titre de l\'élection',
              hint: 'Ex: Élection du Comité de Classe L3',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le titre est requis';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.md),

            // Type
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: [AppColors.cardShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type d\'élection',
                    style: AppTypography.kBody1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Classe'),
                          value: false,
                          groupValue: _isCommitteeVote,
                          onChanged: (value) {
                            setState(() => _isCommitteeVote = value!);
                          },
                          activeColor: AppColors.kPrimary,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Comité'),
                          value: true,
                          groupValue: _isCommitteeVote,
                          onChanged: (value) {
                            setState(() => _isCommitteeVote = value!);
                          },
                          activeColor: AppColors.kPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.md),

            // Classroom (if not committee)
            if (!_isCommitteeVote) ...[
              CustomTextField(
                controller: _classroomController,
                label: 'Classe',
                hint: 'Ex: L3 Info, M1 Génie Logiciel...',
                validator: (value) {
                  if (!_isCommitteeVote && (value == null || value.isEmpty)) {
                    return 'La classe est requise';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.md),
            ],

            // Dates
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: [AppColors.cardShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Période de vote',
                    style: AppTypography.kBody1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  
                  // Start Date
                  InkWell(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kGreyLight),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.kPrimary),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date de début',
                                  style: AppTypography.kCaption.copyWith(
                                    color: AppColors.kGrey,
                                  ),
                                ),
                                Text(
                                  _startDate != null
                                      ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} ${_startDate!.hour}:${_startDate!.minute.toString().padLeft(2, '0')}'
                                      : 'Sélectionner',
                                  style: AppTypography.kBody1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  // End Date
                  InkWell(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kGreyLight),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.kError),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date de fin',
                                  style: AppTypography.kCaption.copyWith(
                                    color: AppColors.kGrey,
                                  ),
                                ),
                                Text(
                                  _endDate != null
                                      ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year} ${_endDate!.hour}:${_endDate!.minute.toString().padLeft(2, '0')}'
                                      : 'Sélectionner',
                                  style: AppTypography.kBody1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.md),

            // Positions
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: [AppColors.cardShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Postes à pourvoir',
                        style: AppTypography.kBody1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: AppColors.kPrimary),
                        onPressed: _addPosition,
                      ),
                    ],
                  ),

                  if (_positions.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Center(
                        child: Text(
                          'Aucun poste ajouté',
                          style: AppTypography.kBody1.copyWith(
                            color: AppColors.kGrey,
                          ),
                        ),
                      ),
                    )
                  else
                    ..._positions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final position = entry.value;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.kPrimary.withOpacity(0.1),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: AppColors.kPrimary),
                          ),
                        ),
                        title: Text(position.name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: AppColors.kError),
                          onPressed: () => _removePosition(index),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Create Button
            PrimaryButton(
              text: 'Créer l\'Élection',
              onPressed: _isLoading ? null : _createElection,
              isLoading: _isLoading,
            ),

            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
