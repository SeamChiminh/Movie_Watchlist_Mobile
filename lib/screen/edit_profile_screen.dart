import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_watchlist_mobile/widgets/profile/profile_form_field.dart';
import 'package:provider/provider.dart';
import '../widgets/home/home_theme.dart';
import '../viewmodels/user_profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
    this.initialPhone = '',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  static bool _isValidEmail(String email) {
    final pattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return pattern.hasMatch(email);
  }

  static bool _isValidPhone(String phone) {
    if (phone.isEmpty) return true;
    final digitsOnly = phone.replaceAll(RegExp(r'[\s\-]'), '');
    return digitsOnly.isNotEmpty && RegExp(r'^\d+$').hasMatch(digitsOnly);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: HomeTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: HomeTheme.accent),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: HomeTheme.accent),
              title: const Text(
                'Take Photo',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeTheme.bgBottom,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _CircleIconButton(
                              icon: Icons.chevron_left_rounded,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            const Spacer(),
                            const Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 52),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Avatar + edit overlay
                        _AvatarEditor(
                          imageFile: _selectedImage,
                          initialName: _nameCtrl.text,
                          onTap: _showImageSourceDialog,
                        ),

                        const SizedBox(height: 18),

                        // Name + email display
                        Center(
                          child: Text(
                            _nameCtrl.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(
                            _emailCtrl.text,
                            style: const TextStyle(
                              color: Color(0xFFB9B9C5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Form fields
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Full Name',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ProfileFormField(
                          controller: _nameCtrl,
                          hintText: 'Full Name',
                          enabled: true,
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: 22),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ProfileFormField(
                          controller: _emailCtrl,
                          hintText: 'Email',
                          enabled: true,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: 22),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ProfileFormField(
                          controller: _phoneCtrl,
                          hintText: 'Phone Number',
                          enabled: true,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),

                    // Save button at bottom
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HomeTheme.accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: () {
                            final name = _nameCtrl.text.trim();
                            final email = _emailCtrl.text.trim();
                            final phone = _phoneCtrl.text.trim();

                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your full name'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your email'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (!_isValidEmail(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid email address'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (!_isValidPhone(phone)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Phone number can only contain digits'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final profile = context.read<UserProfileViewModel>();
                            profile.updateProfile(name: name, email: email, phone: phone);
                            profile.setProfileImagePath(_selectedImage?.path);
                            Navigator.of(context).pop(
                              (name, email, phone, _selectedImage?.path),
                            );
                          },
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: HomeTheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}

class _AvatarEditor extends StatelessWidget {
  final File? imageFile;
  final String initialName;
  final VoidCallback onTap;
  
  const _AvatarEditor({
    this.imageFile,
    required this.initialName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 22,
                    offset: const Offset(0, 14),
                  )
                ],
              ),
              child: ClipOval(
                child: imageFile != null
                    ? Image.file(
                        imageFile!,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: HomeTheme.surface.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: HomeTheme.accent,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: HomeTheme.accent.withOpacity(0.2),
      ),
      child: Center(
        child: Text(
          initialName.isNotEmpty ? initialName[0].toUpperCase() : 'U',
          style: const TextStyle(
            color: HomeTheme.accent,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
