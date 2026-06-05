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
import '../../domain/driver_document_requirements.dart';

class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  final Map<String, PlatformFile> _selectedFiles = {};
  final Map<String, String> _uploadedUrls = {};
  String? _uploadingDocumentType;
  bool _isSubmitting = false;

  Future<void> _pickDocument(DriverDocumentRequirement document) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: UploadService.allowedDocumentExtensions.toList(),
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) {
      return;
    }
    if (file.size > UploadService.maxFileSizeBytes) {
      _showMessage('Files must be 1 MB or smaller.');
      return;
    }
    if (file.bytes == null) {
      _showMessage('Could not read that file. Please choose another file.');
      return;
    }

    setState(() {
      _selectedFiles[document.type] = file;
      _uploadedUrls.remove(document.type);
    });
  }

  Future<void> _submit() async {
    final driverId = ref.read(authStateProvider).userId;
    if (driverId == null) {
      _showMessage('Sign in before uploading documents.');
      return;
    }
    final missingDocuments = requiredDriverDocuments
        .where((document) => !_selectedFiles.containsKey(document.type))
        .map((document) => document.label)
        .join(', ');
    if (missingDocuments.isNotEmpty) {
      _showMessage('Add these documents: $missingDocuments.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final uploadService = ref.read(uploadServiceProvider);
      final urls = <String, String>{};

      for (final document in requiredDriverDocuments) {
        setState(() => _uploadingDocumentType = document.type);
        final file = _selectedFiles[document.type]!;
        final url = await uploadService.uploadDriverDocument(
          driverId: driverId,
          documentType: document.type,
          file: file,
        );
        urls[document.type] = url;
        setState(() => _uploadedUrls[document.type] = url);
      }

      await ref
          .read(driverRepositoryProvider)
          .saveDocumentUrls(driverId: driverId, documentUrls: urls);

      if (mounted) {
        context.push('/profile-photo');
      }
    } on FileSizeLimitException catch (e) {
      _showMessage(e.toString());
    } on UnsupportedFileTypeException catch (e) {
      _showMessage(e.toString());
    } catch (e) {
      _showMessage('Could not upload documents. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _uploadingDocumentType = null;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload documents')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Upload PDF, JPG, or PNG files. Each file must be 1 MB or smaller.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ...requiredDriverDocuments.map((document) {
            final file = _selectedFiles[document.type];
            final uploaded = _uploadedUrls.containsKey(document.type);
            final uploading = _uploadingDocumentType == document.type;

            return AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  uploaded ? Icons.check_circle : Icons.upload_file,
                  color: uploaded ? AppColors.success : AppColors.primaryDark,
                ),
                title: Text(document.label),
                subtitle: Text(
                  uploading
                      ? 'Uploading...'
                      : file == null
                      ? 'No file selected'
                      : '${file.name} (${_formatBytes(file.size)})',
                ),
                trailing: IconButton(
                  icon: Icon(
                    file == null ? Icons.add_circle_outline : Icons.edit,
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () => _pickDocument(document),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Upload and Continue',
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

String _formatBytes(int bytes) {
  final kilobytes = bytes / 1024;
  if (kilobytes < 1024) {
    return '${kilobytes.toStringAsFixed(0)} KB';
  }
  return '${(kilobytes / 1024).toStringAsFixed(1)} MB';
}
