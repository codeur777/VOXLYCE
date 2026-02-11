import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/utils/snackbar_utils.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'Comment voter pour une élection ?',
      'answer': 'Pour voter, accédez à l\'onglet "Élections", sélectionnez l\'élection en cours, choisissez vos candidats pour chaque poste, puis confirmez votre vote. Vous recevrez une confirmation par email.',
      'category': 'Vote',
    },
    {
      'question': 'Comment devenir candidat ?',
      'answer': 'Allez dans l\'onglet "Candidatures", cliquez sur "Nouvelle candidature", remplissez le formulaire avec votre manifesto, effectuez le paiement de 500F, et attendez la validation de l\'administrateur.',
      'category': 'Candidature',
    },
    {
      'question': 'Puis-je modifier mon vote ?',
      'answer': 'Non, une fois votre vote confirmé, il ne peut plus être modifié. Assurez-vous de bien vérifier vos choix avant de confirmer.',
      'category': 'Vote',
    },
    {
      'question': 'Comment voir les résultats ?',
      'answer': 'Les résultats sont disponibles dans l\'onglet "Résultats" une fois l\'élection terminée et validée par l\'administrateur. Vous recevrez également une notification.',
      'category': 'Résultats',
    },
    {
      'question': 'Que faire si j\'ai oublié mon mot de passe ?',
      'answer': 'Sur l\'écran de connexion, cliquez sur "Mot de passe oublié", entrez votre email, et suivez les instructions reçues par email pour réinitialiser votre mot de passe.',
      'category': 'Compte',
    },
    {
      'question': 'Comment contacter le support ?',
      'answer': 'Vous pouvez nous contacter via le formulaire de contact ci-dessous, par email à support@voxlyce.com, ou par téléphone au +221 XX XXX XX XX.',
      'category': 'Support',
    },
    {
      'question': 'Mes données sont-elles sécurisées ?',
      'answer': 'Oui, toutes vos données sont cryptées et stockées de manière sécurisée. Nous ne partageons jamais vos informations avec des tiers. Consultez notre politique de confidentialité pour plus de détails.',
      'category': 'Sécurité',
    },
    {
      'question': 'Puis-je voter depuis mon téléphone ?',
      'answer': 'Oui, Voxlyce est une application mobile disponible sur Android et iOS. Vous pouvez voter depuis n\'importe où avec une connexion internet.',
      'category': 'Technique',
    },
  ];

  String _selectedCategory = 'Toutes';
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredFaqs {
    if (_selectedCategory == 'Toutes') {
      return _faqs;
    }
    return _faqs.where((faq) => faq['category'] == _selectedCategory).toList();
  }

  List<String> get categories {
    final cats = _faqs.map((faq) => faq['category'] as String).toSet().toList();
    cats.insert(0, 'Toutes');
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: const CustomAppBar(
        title: 'Aide et Support',
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          // Quick Help Card
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [AppColors.defaultShadow],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.help_center,
                  size: 48.sp,
                  color: AppColors.kWhite,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Comment pouvons-nous vous aider ?',
                  style: AppTypography.kHeading3.copyWith(
                    color: AppColors.kWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Consultez notre FAQ ou contactez-nous',
                  style: AppTypography.kBody1.copyWith(
                    color: AppColors.kWhite.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  'Email',
                  Icons.email,
                  AppColors.kPrimary,
                  () {
                    SnackbarUtils.showInfo(context, 'support@voxlyce.com');
                  },
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildQuickAction(
                  'Téléphone',
                  Icons.phone,
                  AppColors.kSuccess,
                  () {
                    SnackbarUtils.showInfo(context, '+221 XX XXX XX XX');
                  },
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildQuickAction(
                  'Chat',
                  Icons.chat,
                  AppColors.kInfo,
                  () {
                    SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // FAQ Section
          Text(
            'Questions Fréquentes',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kSecondary,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Category Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: AppColors.kWhite,
                    selectedColor: AppColors.kPrimary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.kPrimary : AppColors.kGrey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // FAQ List
          ...filteredFaqs.map((faq) => _buildFaqItem(faq)).toList(),

          SizedBox(height: AppSpacing.lg),

          // Contact Form
          Text(
            'Contactez-nous',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kSecondary,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [AppColors.cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Votre email',
                    hintText: 'email@example.com',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: AppSpacing.md),

                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Votre message',
                    hintText: 'Décrivez votre problème ou question...',
                    prefixIcon: const Icon(Icons.message),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  maxLines: 5,
                ),

                SizedBox(height: AppSpacing.md),

                PrimaryButton(
                  text: 'Envoyer',
                  onPressed: () {
                    if (_emailController.text.isEmpty || _messageController.text.isEmpty) {
                      SnackbarUtils.showError(context, 'Veuillez remplir tous les champs');
                      return;
                    }
                    SnackbarUtils.showSuccess(context, 'Message envoyé avec succès');
                    _emailController.clear();
                    _messageController.clear();
                  },
                  icon: Icons.send,
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32.sp),
            SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.kCaption.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> faq) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              Icons.help_outline,
              color: AppColors.kPrimary,
              size: 20.sp,
            ),
          ),
          title: Text(
            faq['question'],
            style: AppTypography.kBody1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kInfo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      faq['category'],
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kInfo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    faq['answer'],
                    style: AppTypography.kBody2.copyWith(
                      color: AppColors.kGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
