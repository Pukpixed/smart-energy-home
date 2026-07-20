import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _notificationEnabled = true;
  bool _loadingProfile = true;
  bool _savingNotification = false;
  bool _loggingOut = false;

  String _userName = 'ผู้ใช้งาน';
  String _userEmail = '';
  String _selectedLanguage = 'ไทย';

  static const Color backgroundColor = Color(0xFF071C24);
  static const Color cardColor = Color(0xFF102A33);
  static const Color primaryColor = Color(0xFF41D6C3);
  static const Color secondaryTextColor = Color(0xFF9EB2B9);
  static const Color dangerColor = Color(0xFFFF6B6B);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        _loadingProfile = false;
      });
      return;
    }

    try {
      final userDocument =
          await _firestore.collection('users').doc(user.uid).get();

      final settingsDocument =
          await _firestore.collection('settings').doc(user.uid).get();

      final userData = userDocument.data();
      final settingsData = settingsDocument.data();

      if (!mounted) return;

      final firestoreName =
          userData?['name']?.toString().trim() ?? '';

      final firestoreEmail =
          userData?['email']?.toString().trim() ?? '';

      setState(() {
        _userName = firestoreName.isNotEmpty
            ? firestoreName
            : (user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : 'ผู้ใช้งาน');

        _userEmail = firestoreEmail.isNotEmpty
            ? firestoreEmail
            : (user.email ?? '');

        _notificationEnabled =
            settingsData?['notificationEnabled'] as bool? ?? true;

        _selectedLanguage =
            settingsData?['language'] == 'en' ? 'English' : 'ไทย';

        _loadingProfile = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _userName = user.displayName ?? 'ผู้ใช้งาน';
        _userEmail = user.email ?? '';
        _loadingProfile = false;
      });

      _showMessage(
        'ไม่สามารถโหลดข้อมูลผู้ใช้ได้',
        isError: true,
      );
    }
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? const Color(0xFFE65757) : cardColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'ตั้งค่า',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          backgroundColor: cardColor,
          onRefresh: _loadUserProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            child: Column(
              children: [
                _buildProfileSection(),
                const SizedBox(height: 24),
                _buildSettingsCard(),
                const SizedBox(height: 18),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProfileSection() {
    if (_loadingProfile) {
      return const SizedBox(
        height: 70,
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    final User? user = _auth.currentUser;
    final String? photoUrl = user?.photoURL;

    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.65),
              width: 2,
            ),
          ),
          child: photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 34,
                    );
                  },
                )
              : const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 34,
                ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _userEmail.isEmpty ? 'ไม่พบอีเมล' : _userEmail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _showEditProfileDialog,
          icon: const Icon(
            Icons.edit_outlined,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.person_outline_rounded,
            title: 'ข้อมูลส่วนตัว',
            onTap: _showEditProfileDialog,
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.lock_outline_rounded,
            title: 'จัดการรหัสผ่าน',
            onTap: _sendPasswordResetEmail,
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.home_outlined,
            title: 'จัดการบ้านของฉัน',
            onTap: () {
              _showMessage('ฟังก์ชันนี้กำลังพัฒนา');
            },
          ),
          _buildDivider(),
          _buildNotificationTile(),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.language_rounded,
            title: 'ภาษา',
            trailingText: _selectedLanguage,
            onTap: _showLanguageDialog,
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.help_outline_rounded,
            title: 'ช่วยเหลือ',
            onTap: () {
              _showMessage('ฟังก์ชันนี้กำลังพัฒนา');
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.info_outline_rounded,
            title: 'เกี่ยวกับแอป',
            onTap: _showAboutApplicationDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                trailingText,
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ),
          const Icon(
            Icons.chevron_right_rounded,
            color: secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.notifications_none_rounded,
          color: primaryColor,
          size: 21,
        ),
      ),
      title: const Text(
        'การแจ้งเตือน',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: _savingNotification
          ? const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2,
              ),
            )
          : Switch.adaptive(
              value: _notificationEnabled,
              activeTrackColor: primaryColor,
              activeThumbColor: Colors.white,
              inactiveTrackColor: Colors.white24,
              onChanged: _updateNotificationSetting,
            ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      color: Colors.white.withValues(alpha: 0.06),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _loggingOut ? null : _confirmLogout,
        icon: _loggingOut
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: dangerColor,
                ),
              )
            : const Icon(
                Icons.logout_rounded,
                size: 20,
              ),
        label: Text(
          _loggingOut ? 'กำลังออกจากระบบ...' : 'ออกจากระบบ',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: dangerColor,
          side: BorderSide(
            color: dangerColor.withValues(alpha: 0.55),
          ),
          backgroundColor:
              dangerColor.withValues(alpha: 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      height: 70,
      selectedIndex: 4,
      onDestinationSelected: _onBottomNavigationTap,
      backgroundColor: const Color(0xFF0A222B),
      indicatorColor: primaryColor.withValues(alpha: 0.16),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home_rounded,
            color: primaryColor,
          ),
          label: 'หน้าหลัก',
        ),
        NavigationDestination(
          icon: Icon(Icons.devices_outlined),
          selectedIcon: Icon(
            Icons.devices_rounded,
            color: primaryColor,
          ),
          label: 'อุปกรณ์',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(
            Icons.bar_chart_rounded,
            color: primaryColor,
          ),
          label: 'สถิติ',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_none_rounded),
          selectedIcon: Icon(
            Icons.notifications_rounded,
            color: primaryColor,
          ),
          label: 'แจ้งเตือน',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(
            Icons.settings_rounded,
            color: primaryColor,
          ),
          label: 'ตั้งค่า',
        ),
      ],
    );
  }

  void _onBottomNavigationTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop();
        break;
      case 1:
        _showMessage('หน้าอุปกรณ์กำลังพัฒนา');
        break;
      case 2:
        _showMessage('หน้าสถิติกำลังพัฒนา');
        break;
      case 3:
        _showMessage('หน้าแจ้งเตือนกำลังพัฒนา');
        break;
      case 4:
        break;
    }
  }

  Future<void> _showEditProfileDialog() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      _showMessage(
        'กรุณาเข้าสู่ระบบใหม่',
        isError: true,
      );
      return;
    }

    final controller = TextEditingController(text: _userName);

    final bool? save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: const Text(
            'แก้ไขชื่อผู้ใช้',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'ชื่อผู้ใช้งาน',
              labelStyle: TextStyle(
                color: secondaryTextColor,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );

    final newName = controller.text.trim();
    controller.dispose();

    if (save != true || newName.isEmpty) return;

    try {
      await _firestore.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'name': newName,
          'email': user.email ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      await user.updateDisplayName(newName);

      if (!mounted) return;

      setState(() {
        _userName = newName;
      });

      _showMessage('บันทึกข้อมูลเรียบร้อยแล้ว');
    } catch (e) {
      _showMessage(
        'บันทึกข้อมูลไม่สำเร็จ',
        isError: true,
      );
    }
  }

  Future<void> _updateNotificationSetting(bool value) async {
    if (_savingNotification) return;

    final User? user = _auth.currentUser;

    if (user == null) return;

    final oldValue = _notificationEnabled;

    setState(() {
      _notificationEnabled = value;
      _savingNotification = true;
    });

    try {
      await _firestore.collection('settings').doc(user.uid).set(
        {
          'userId': user.uid,
          'notificationEnabled': value,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _notificationEnabled = oldValue;
      });

      _showMessage(
        'บันทึกการตั้งค่าไม่สำเร็จ',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingNotification = false;
        });
      }
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _auth.currentUser?.email ?? _userEmail;

    if (email.isEmpty) {
      _showMessage(
        'ไม่พบอีเมล',
        isError: true,
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage('ส่งลิงก์เปลี่ยนรหัสผ่านแล้ว');
    } catch (e) {
      _showMessage(
        'ส่งอีเมลไม่สำเร็จ',
        isError: true,
      );
    }
  }

  Future<void> _showLanguageDialog() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardColor,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(sheetContext);
                  _saveLanguage('th');
                },
                title: const Text(
                  'ภาษาไทย',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(sheetContext);
                  _saveLanguage('en');
                },
                title: const Text(
                  'English',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveLanguage(String code) async {
    final User? user = _auth.currentUser;

    if (user == null) return;

    try {
      await _firestore.collection('settings').doc(user.uid).set(
        {
          'userId': user.uid,
          'language': code,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      setState(() {
        _selectedLanguage = code == 'en' ? 'English' : 'ไทย';
      });
    } catch (e) {
      _showMessage(
        'บันทึกภาษาไม่สำเร็จ',
        isError: true,
      );
    }
  }

  Future<void> _confirmLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: const Text(
            'ออกจากระบบ',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'คุณต้องการออกจากระบบใช่หรือไม่?',
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _loggingOut = true;
    });

    try {
      await _auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'ออกจากระบบไม่สำเร็จ',
        isError: true,
      );

      setState(() {
        _loggingOut = false;
      });
    }
  }

  void _showAboutApplicationDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Smart Energy Home',
      applicationVersion: '1.0.0',
      children: const [
        Text(
          'ระบบแสดงผลและควบคุมการใช้พลังงานภายในบ้าน',
        ),
      ],
    );
  }
}
