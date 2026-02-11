#!/usr/bin/env python3
"""
Script pour corriger automatiquement les noms de constantes dans les fichiers Dart
"""

import os
import re

# Mappings de remplacement
REPLACEMENTS = {
    # AppAssets
    'AppAssets.iconsNotification': 'AppAssets.kNotification',
    'AppAssets.iconsActivity': 'AppAssets.kActivity',
    'AppAssets.iconsBookOpen': 'AppAssets.kBookOpen',
    'AppAssets.iconsStatistics': 'AppAssets.kStatistics',
    'AppAssets.iconsProfile': 'AppAssets.kProfile',
    'AppAssets.iconsHome': 'AppAssets.kHome',
    'AppAssets.iconsHelp': 'AppAssets.kHelp',
    'AppAssets.iconsAdd': 'AppAssets.kAdd',
    'AppAssets.iconsThumbUp': 'AppAssets.kThumbUp',
    'AppAssets.iconsCalendar': 'AppAssets.kCalendar',
    'AppAssets.iconsStudents': 'AppAssets.kStudents',
    'AppAssets.iconsPassword': 'AppAssets.kPassword',
    'AppAssets.iconsTheme': 'AppAssets.kTheme',
    'AppAssets.iconsPrivacy': 'AppAssets.kPrivacy',
    
    # AppTypography
    'AppTypography.h1': 'AppTypography.kHeading1',
    'AppTypography.h2': 'AppTypography.kHeading2',
    'AppTypography.h3': 'AppTypography.kHeading3',
    
    # AppColors
    'AppColors.primary': 'AppColors.kPrimary',
    'AppColors.success': 'AppColors.kSuccess',
    'AppColors.warning': 'AppColors.kWarning',
    'AppColors.error': 'AppColors.kError',
    'AppColors.info': 'AppColors.kInfo',
    'AppColors.textPrimary': 'AppColors.kSecondary',
    'AppColors.textSecondary': 'AppColors.kGrey',
    'AppColors.border': 'AppColors.kGreyLight',
}

def fix_file(filepath):
    """Corrige les constantes dans un fichier"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Appliquer tous les remplacements
        for old, new in REPLACEMENTS.items():
            content = content.replace(old, new)
        
        # Sauvegarder si modifié
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✅ Corrigé: {filepath}")
            return True
        else:
            print(f"⏭️  Ignoré: {filepath} (aucun changement)")
            return False
            
    except Exception as e:
        print(f"❌ Erreur: {filepath} - {e}")
        return False

def main():
    """Fonction principale"""
    print("🔧 Correction des constantes dans les fichiers Dart...\n")
    
    # Fichiers à corriger
    files_to_fix = [
        'voxlyce_front/lib/presentation/admin/screens/admin_dashboard.dart',
        'voxlyce_front/lib/presentation/supervisor/screens/supervisor_dashboard.dart',
        'voxlyce_front/lib/presentation/common/screens/profile_screen.dart',
    ]
    
    fixed_count = 0
    for filepath in files_to_fix:
        if os.path.exists(filepath):
            if fix_file(filepath):
                fixed_count += 1
        else:
            print(f"⚠️  Fichier non trouvé: {filepath}")
    
    print(f"\n✨ Terminé! {fixed_count} fichier(s) corrigé(s)")

if __name__ == '__main__':
    main()
