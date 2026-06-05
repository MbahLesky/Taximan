import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../application/providers/driver_providers.dart';
import '../../application/providers/upload_providers.dart';
import '../../data/upload_service.dart';

class ProfilePhotoScreen extends ConsumerStatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  ConsumerState<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends ConsumerState<ProfilePhotoScreen> {
  String? _profilePhotoUrl;
  String? _selectedFileName;
  bool _isUploading = false;

  Future<void> _pickAndUploadPhoto() async {
    final driverId = ref.read(authStateProvider).userId;
    if (driverId == null) {
      _showMessage('Sign in before uploading a profile photo.');
      return;
    }

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: UploadService.allowedImageExtensions.toList(),
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) {
      return;
    }

    setState(() {
      _selectedFileName = file.name;
      _isUploading = true;
    });

    try {
      final url = await ref
          .read(uploadServiceProvider)
          .uploadDriverProfilePhoto(driverId: driverId, file: file);
      await ref
          .read(driverRepositoryProvider)
          .saveProfilePhotoUrl(driverId: driverId, profilePhotoUrl: url);
      if (mounted) {
        setState(() => _profilePhotoUrl = url);
      }
    } on FileSizeLimitException catch (e) {
      _showMessage(e.toString());
    } on UnsupportedFileTypeException catch (e) {
      _showMessage(e.toString());
    } catch (_) {
      _showMessage('Could not upload profile photo. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _continue() {
    final currentPhoto = ref
        .read(currentDriverProvider)
        .valueOrNull
        ?.profilePhotoUrl;
    final photoUrl = _profilePhotoUrl ?? currentPhoto;
    if (photoUrl == null || photoUrl.isEmpty) {
      _showMessage('Upload a profile photo before continuing.');
      return;
    }
    context.go('/verification-pending');
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final currentDriver = ref.watch(currentDriverProvider).valueOrNull;
    final photoUrl = _profilePhotoUrl ?? currentDriver?.profilePhotoUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile photo')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            AppCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 58,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: photoUrl == null || photoUrl.isEmpty
                        ? null
                        : NetworkImage(photoUrl),
                    child: photoUrl == null || photoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 64,
                            color: AppColors.primaryDark,
                          )
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_selectedFileName != null) ...[
                    Text(
                      _selectedFileName!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  AppButton(
                    label: photoUrl == null || photoUrl.isEmpty
                        ? 'Upload photo'
                        : 'Change photo',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.photo_camera_outlined,
                    isLoading: _isUploading,
                    onPressed: _pickAndUploadPhoto,
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(label: 'Continue', onPressed: _continue),
          ],
        ),
      ),
    );
  }
}
