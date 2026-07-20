import 'package:flutter/material.dart';

import '../../core/services/firestore_seed_service.dart';
import '../device/device_screen.dart';
import '../energy/energy_statistics_screen.dart';
import '../report/report_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  bool airConditionerStatus = true;
  bool televisionStatus = true;
  bool lightStatus = false;
  bool _creatingInitialData = false;

  static const Color backgroundColor = Color(0xFF071C24);
  static const Color cardColor = Color(0xFF102C35);
  static const Color primaryColor = Color(0xFF41D6C3);
  static const Color secondaryTextColor = Color(0xFF8FA8AE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEnergySummaryCard(),
              const SizedBox(height: 15),
              _buildSummaryCards(),
              const SizedBox(height: 22),
              _buildDeviceHeader(),
              const SizedBox(height: 6),
              _buildDeviceList(),
              const SizedBox(height: 14),
              _buildManageDeviceButton(),
              const SizedBox(height: 12),
              _buildCreateFirebaseButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          _showMessage('เมนูกำลังพัฒนา');
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      title: const Text(
        'หน้าหลัก',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showMessage('หน้าแจ้งเตือนกำลังพัฒนา');
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _buildEnergySummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF17434A),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'การใช้พลังงานไฟฟ้าวันนี้',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '12.45',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 31,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        'kWh',
                        style: TextStyle(
                          color: Color(0xFFB5C8CC),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 9),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '8% น้อยกว่าเมื่อวาน',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.35),
              ),
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 40,
                  color: primaryColor,
                ),
                Icon(
                  Icons.bolt_rounded,
                  size: 21,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallSummaryCard(
            title: 'กำลังไฟฟ้าปัจจุบัน',
            value: '1.25',
            unit: 'kW',
            icon: Icons.bolt_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSmallSummaryCard(
            title: 'ค่าไฟโดยประมาณ',
            value: '45.30',
            unit: 'บาท',
            icon: Icons.payments_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSmallSummaryCard(
            title: 'อุปกรณ์กำลังทำงาน',
            value: '6',
            unit: 'เครื่อง',
            icon: Icons.devices_other_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallSummaryCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 108,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF173B42),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 19,
          ),
          const SizedBox(height: 7),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      color: secondaryTextColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'อุปกรณ์ที่เชื่อมต่อ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {
            _openPage(
              index: 1,
              page: const DeviceScreen(),
            );
          },
          child: const Text(
            'ดูทั้งหมด',
            style: TextStyle(
              color: primaryColor,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceList() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF173B42),
        ),
      ),
      child: Column(
        children: [
          _buildDeviceTile(
            icon: Icons.ac_unit_rounded,
            deviceName: 'เครื่องปรับอากาศ',
            roomName: 'ห้องนอน',
            detail: '26°C',
            status: airConditionerStatus,
            onChanged: (value) {
              setState(() {
                airConditionerStatus = value;
              });
            },
          ),
          _buildDivider(),
          _buildDeviceTile(
            icon: Icons.tv_rounded,
            deviceName: 'โทรทัศน์',
            roomName: 'ห้องนั่งเล่น',
            detail: 'กำลังทำงาน',
            status: televisionStatus,
            onChanged: (value) {
              setState(() {
                televisionStatus = value;
              });
            },
          ),
          _buildDivider(),
          _buildDeviceTile(
            icon: Icons.lightbulb_outline_rounded,
            deviceName: 'หลอดไฟ',
            roomName: 'ห้องครัว',
            detail: 'ปิด',
            status: lightStatus,
            onChanged: (value) {
              setState(() {
                lightStatus = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTile({
    required IconData icon,
    required String deviceName,
    required String roomName,
    required String detail,
    required bool status,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: status
                  ? primaryColor.withValues(alpha: 0.13)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 23,
              color: status ? primaryColor : secondaryTextColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$roomName • $detail',
                  style: TextStyle(
                    color: status ? primaryColor : secondaryTextColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: status,
              onChanged: onChanged,
              activeTrackColor: primaryColor,
              activeThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFF33484E),
              inactiveThumbColor: const Color(0xFF9BA9AC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      endIndent: 14,
      color: Color(0xFF1D3A40),
    );
  }

  Widget _buildManageDeviceButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          _openPage(
            index: 1,
            page: const DeviceScreen(),
          );
        },
        icon: const Icon(
          Icons.tune_rounded,
          size: 18,
        ),
        label: const Text(
          'จัดการอุปกรณ์ทั้งหมด',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(
            color: Color(0xFF245B60),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateFirebaseButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _creatingInitialData ? null : _createInitialFirestoreData,
        icon: _creatingInitialData
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.cloud_upload_outlined,
              ),
        label: Text(
          _creatingInitialData
              ? 'กำลังสร้างข้อมูล...'
              : 'สร้างข้อมูลเริ่มต้นใน Firebase',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          disabledBackgroundColor: const Color(0xFF245B60),
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Future<void> _createInitialFirestoreData() async {
    setState(() {
      _creatingInitialData = true;
    });

    try {
      await FirestoreSeedService.instance.createInitialData();

      if (!mounted) return;

      _showMessage(
        'สร้างข้อมูลเริ่มต้นใน Firestore เรียบร้อยแล้ว',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'เกิดข้อผิดพลาด: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _creatingInitialData = false;
        });
      }
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A222B),
        border: Border(
          top: BorderSide(
            color: Color(0xFF17383F),
          ),
        ),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryTextColor,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
          ),
          onTap: _handleNavigation,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon: Icon(
                Icons.home_rounded,
              ),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.devices_other_outlined,
              ),
              activeIcon: Icon(
                Icons.devices_other_rounded,
              ),
              label: 'อุปกรณ์',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bolt_outlined,
              ),
              activeIcon: Icon(
                Icons.bolt_rounded,
              ),
              label: 'พลังงาน',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.description_outlined,
              ),
              activeIcon: Icon(
                Icons.description_rounded,
              ),
              label: 'รายงาน',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
              ),
              activeIcon: Icon(
                Icons.settings_rounded,
              ),
              label: 'ตั้งค่า',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNavigation(int index) async {
    switch (index) {
      case 0:
        setState(() {
          _currentIndex = 0;
        });
        break;

      case 1:
        await _openPage(
          index: 1,
          page: const DeviceScreen(),
        );
        break;

      case 2:
        await _openPage(
          index: 2,
          page: const EnergyStatisticsScreen(),
        );
        break;

      case 3:
        await _openPage(
          index: 3,
          page: const ReportScreen(),
        );
        break;

      case 4:
        await _openPage(
          index: 4,
          page: const SettingsScreen(),
        );
        break;
    }
  }

  Future<void> _openPage({
    required int index,
    required Widget page,
  }) async {
    if (!mounted) return;

    setState(() {
      _currentIndex = index;
    });

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => page,
      ),
    );

    if (!mounted) return;

    setState(() {
      _currentIndex = 0;
    });
  }

  void _showMessage(
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
