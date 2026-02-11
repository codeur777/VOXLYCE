# 🎨 Voxlyce Premium UI - Guide d'Utilisation

## 🚀 Installation

```bash
cd FRONTEND/voxlyce_front
flutter pub get
```

## 📱 Lancer l'Application

```bash
# Mode debug
flutter run

# Mode release
flutter run --release

# Choisir un device spécifique
flutter devices
flutter run -d <device_id>
```

## 🎯 Structure Premium

### Système de Design

Le système de design Voxlyce est basé sur les meilleurs éléments d'Eden avec des améliorations spécifiques au vote électronique.

#### 1. Couleurs

```dart
import 'package:voxlyce_front/core/theme/app_colors.dart';

// Couleurs principales
AppColors.kPrimary        // Bleu professionnel
AppColors.kSecondary      // Slate foncé
AppColors.kSuccess        // Vert
AppColors.kError          // Rouge

// Couleurs de statut vote
AppColors.kPending        // Orange
AppColors.kOngoing        // Vert
AppColors.kValidated      // Violet
AppColors.kRejected       // Rouge

// Ombres
AppColors.defaultShadow
AppColors.cardShadow
AppColors.elevatedShadow

// Gradients
AppColors.primaryGradient
AppColors.successGradient
```

#### 2. Typographie

```dart
import 'package:voxlyce_front/core/theme/app_typography.dart';

// Titres
AppTypography.kDisplay1   // 48sp
AppTypography.kHeading1   // 32sp
AppTypography.kHeading2   // 28sp

// Corps de texte
AppTypography.kBody1      // 16sp
AppTypography.kBody2      // 14sp

// Boutons et labels
AppTypography.kButton     // 16sp, bold
AppTypography.kLabel      // 14sp, medium

// Avec couleur
AppTypography.kHeading1Primary
AppTypography.kBody1Grey
```

#### 3. Espacement

```dart
import 'package:voxlyce_front/core/theme/app_spacing.dart';

// Horizontal
AppSpacing.xs    // 4w
AppSpacing.sm    // 8w
AppSpacing.md    // 16w
AppSpacing.lg    // 24w
AppSpacing.xl    // 32w

// Vertical
AppSpacing.xsVertical
AppSpacing.mdVertical
AppSpacing.lgVertical

// Border Radius
AppSpacing.radiusSm   // 8r
AppSpacing.radiusMd   // 12r
AppSpacing.radiusLg   // 16r

// Icônes
AppSpacing.iconSm     // 20r
AppSpacing.iconMd     // 24r
AppSpacing.iconLg     // 32r
```

### Composants Premium

#### 1. Boutons

```dart
import 'package:voxlyce_front/core/widgets/buttons/primary_button.dart';

// Bouton standard
PrimaryButton(
  text: 'Voter',
  onTap: () {
    // Action
  },
)

// Avec icône
PrimaryButton(
  text: 'Soumettre',
  icon: Icons.check,
  onTap: () {},
)

// État loading
PrimaryButton(
  text: 'Chargement...',
  isLoading: true,
  onTap: () {},
)

// Désactivé
PrimaryButton(
  text: 'Indisponible',
  isDisabled: true,
  onTap: () {},
)

// Outlined
PrimaryButton(
  text: 'Annuler',
  isOutlined: true,
  onTap: () {},
)

// Personnalisé
PrimaryButton(
  text: 'Custom',
  color: AppColors.kSuccess,
  textColor: AppColors.kWhite,
  width: 200,
  height: 56,
  borderRadius: 20,
  onTap: () {},
)
```

#### 2. Cartes

```dart
import 'package:voxlyce_front/core/widgets/cards/premium_card.dart';

// Carte standard
PremiumCard(
  child: Column(
    children: [
      Text('Titre'),
      Text('Description'),
    ],
  ),
)

// Carte cliquable
PremiumCard(
  onTap: () {
    // Navigation
  },
  child: ListTile(
    title: Text('Élection'),
    subtitle: Text('En cours'),
  ),
)

// Carte élevée
ElevatedCard(
  child: Text('Contenu important'),
)

// Carte avec gradient
GradientCard(
  gradient: AppColors.primaryGradient,
  child: Text(
    'Résultat validé',
    style: AppTypography.kHeading3.copyWith(
      color: AppColors.kWhite,
    ),
  ),
)

// Personnalisée
PremiumCard(
  padding: EdgeInsets.all(AppSpacing.lg),
  margin: EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  ),
  borderRadius: AppSpacing.radiusXl,
  hasShadow: true,
  border: Border.all(color: AppColors.kPrimary),
  child: Text('Contenu'),
)
```

#### 3. Champs de Texte

```dart
import 'package:voxlyce_front/core/widgets/inputs/custom_text_field.dart';

// Champ standard
CustomTextField(
  controller: emailController,
  label: 'Email',
  hint: 'Entrez votre email',
  prefixIcon: Icons.email,
)

// Mot de passe
CustomTextField(
  controller: passwordController,
  label: 'Mot de passe',
  hint: '••••••••',
  obscureText: true,
  prefixIcon: Icons.lock,
  suffixIcon: Icons.visibility,
  onSuffixTap: () {
    // Toggle visibility
  },
)

// Avec validation
CustomTextField(
  controller: controller,
  label: 'Nom',
  errorText: 'Ce champ est requis',
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Requis';
    }
    return null;
  },
)

// Multi-ligne
CustomTextField(
  controller: manifestoController,
  label: 'Manifeste',
  hint: 'Décrivez votre programme...',
  maxLines: 5,
  keyboardType: TextInputType.multiline,
)
```

#### 4. AppBars

```dart
import 'package:voxlyce_front/core/widgets/appbars/custom_appbar.dart';

// AppBar standard
Scaffold(
  appBar: CustomAppBar(
    title: 'Élections',
  ),
  body: ...,
)

// Avec actions
CustomAppBar(
  title: 'Profil',
  actions: [
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {},
    ),
  ],
)

// Sans bouton retour
CustomAppBar(
  title: 'Accueil',
  showBackButton: false,
)

// AppBar avec gradient
GradientAppBar(
  title: 'Résultats',
  gradient: AppColors.successGradient,
)
```

#### 5. Loading

```dart
import 'package:voxlyce_front/core/widgets/loading/loading_widget.dart';

// Indicateur simple
LoadingWidget()

// Avec message
LoadingWidget(
  message: 'Chargement des élections...',
)

// Overlay plein écran
Stack(
  children: [
    // Contenu
    if (isLoading)
      LoadingOverlay(
        message: 'Traitement en cours...',
      ),
  ],
)

// Shimmer loading
ShimmerLoading(
  width: double.infinity,
  height: 100,
  borderRadius: AppSpacing.radiusMd,
)
```

## 🎨 Exemples d'Écrans

### Écran de Login

```dart
import 'package:flutter/material.dart';
import 'package:voxlyce_front/core/theme/app_colors.dart';
import 'package:voxlyce_front/core/theme/app_spacing.dart';
import 'package:voxlyce_front/core/theme/app_typography.dart';
import 'package:voxlyce_front/core/widgets/buttons/primary_button.dart';
import 'package:voxlyce_front/core/widgets/inputs/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.how_to_vote_rounded,
                size: 80,
                color: AppColors.kPrimary,
              ),
              SizedBox(height: AppSpacing.lgVertical),
              
              // Titre
              Text(
                'Connexion',
                style: AppTypography.kHeading1Primary,
              ),
              SizedBox(height: AppSpacing.mdVertical),
              
              // Email
              CustomTextField(
                controller: emailController,
                label: 'Email',
                hint: 'votre.email@lycee.com',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSpacing.mdVertical),
              
              // Mot de passe
              CustomTextField(
                controller: passwordController,
                label: 'Mot de passe',
                hint: '••••••••',
                obscureText: true,
                prefixIcon: Icons.lock,
              ),
              SizedBox(height: AppSpacing.xlVertical),
              
              // Bouton
              PrimaryButton(
                text: 'Se connecter',
                onTap: () {
                  // Login logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Carte d'Élection

```dart
import 'package:flutter/material.dart';
import 'package:voxlyce_front/core/widgets/cards/premium_card.dart';
import 'package:voxlyce_front/core/theme/app_colors.dart';
import 'package:voxlyce_front/core/theme/app_spacing.dart';
import 'package:voxlyce_front/core/theme/app_typography.dart';

class ElectionCard extends StatelessWidget {
  final String title;
  final String status;
  final DateTime startDate;
  final int candidatesCount;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      onTap: () {
        // Navigate to details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.kHeading4,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kOngoing.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  status,
                  style: AppTypography.kCaptionMedium.copyWith(
                    color: AppColors.kOngoing,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.smVertical),
          
          // Info
          Row(
            children: [
              Icon(Icons.calendar_today, size: AppSpacing.iconSm),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Début: ${startDate.day}/${startDate.month}/${startDate.year}',
                style: AppTypography.kBody2Grey,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xsVertical),
          
          Row(
            children: [
              Icon(Icons.people, size: AppSpacing.iconSm),
              SizedBox(width: AppSpacing.xs),
              Text(
                '$candidatesCount candidats',
                style: AppTypography.kBody2Grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## 🎯 Best Practices

### 1. Utiliser les Constantes

❌ **Mauvais**
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFF2563EB),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

✅ **Bon**
```dart
Container(
  padding: EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: AppColors.kPrimary,
    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
  ),
)
```

### 2. Utiliser les Composants

❌ **Mauvais**
```dart
GestureDetector(
  onTap: () {},
  child: Container(
    height: 48,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(child: Text('Bouton')),
  ),
)
```

✅ **Bon**
```dart
PrimaryButton(
  text: 'Bouton',
  onTap: () {},
)
```

### 3. Mode Sombre

Tous les composants supportent automatiquement le mode sombre. Utilisez:

```dart
bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
```

## 📚 Ressources

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [ScreenUtil Package](https://pub.dev/packages/flutter_screenutil)
- [GetX Documentation](https://pub.dev/packages/get)

## 🎉 Prêt à Coder!

Le système de design premium est maintenant en place. Vous pouvez commencer à créer les écrans de l'application avec une base solide et professionnelle! 🚀
