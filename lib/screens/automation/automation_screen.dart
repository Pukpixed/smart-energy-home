import 'package:flutter/material.dart';

class AutomationScreen extends StatefulWidget {
  const AutomationScreen({super.key});

  @override
  State<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends State<AutomationScreen> {
  int _selectedTab = 0;
  int _selectedBottomIndex = 3;

  static const Color backgroundColor = Color(0xFF071C24);
  static const Color cardColor = Color(0xFF102A33);
  static const Color primaryColor = Color(0xFF41D6C3);
  static const Color secondaryTextColor = Color(0xFF8FA8AE);

  final List<AutomationRule> _rules = <AutomationRule>[
    AutomationRule(
      title: 'ออกจากบ้าน',
      subtitle: 'ปิดเครื่องใช้ไฟฟ้า, ล็อกประตู',
      icon: Icons.directions_walk_rounded,
      isEnabled: true,
    ),
    AutomationRule(
      title: 'กลับบ้าน',
      subtitle: 'เปิดไฟห้องรับแขก, เปิดแอร์ 24°C',
      icon: Icons.home_rounded,
      isEnabled: true,
    ),
    AutomationRule(
      title: 'ก่อนนอน',
      subtitle: 'ปิดไฟ, ปิดแอร์, เปิดโหมดประหยัด',
      icon: Icons.nightlight_round,
      isEnabled: true,
    ),
    AutomationRule(
      title: 'ประหยัดพลังงาน',
      subtitle: 'ปิดอุปกรณ์เมื่อใช้พลังงานสูงเกินกำหนด',
      icon: Icons.savings_outlined,
      isEnabled: false,
    ),
  ];

  final List<AutomationRule> _schedules = <AutomationRule>[
    AutomationRule(
      title: 'เปิดแอร์ตอนเย็น',
      subtitle: 'ทุกวัน เวลา 18:00 น.',
      icon: Icons.schedule_rounded,
      isEnabled: true,
    ),
    AutomationRule(
      title: 'ปิดไฟหน้าบ้าน',
      subtitle: 'ทุกวัน เวลา 06:00 น.',
      icon: Icons.lightbulb_outline_rounded,
      isEnabled: true,
    ),
  ];

  List<AutomationRule> get _currentItems {
    return _selectedTab == 0 ? _rules : _schedules;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: const Icon(Icons.menu_rounded),
        ),
        title: const Text(
          'อัตโนมัติ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'เพิ่มกฎอัตโนมัติ',
            onPressed: _showAddAutomationDialog,
            icon: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            const SizedBox(height: 10),
            Expanded(
              child: _currentItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        6,
                        16,
                        24,
                      ),
                      itemCount: _currentItems.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return _buildAutomationCard(
                          _currentItems[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTabs() {
    const List<String> tabs = <String>[
      'สถานการณ์',
      'ตั้งเวลา',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: List<Widget>.generate(
            tabs.length,
            (int index) {
              final bool isSelected = _selectedTab == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.14)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected
                            ? primaryColor
                            : secondaryTextColor,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAutomationCard(AutomationRule rule) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          _showAutomationDetails(rule);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: rule.isEnabled
                      ? primaryColor.withValues(alpha: 0.14)
                      : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  rule.icon,
                  color: rule.isEnabled
                      ? primaryColor
                      : secondaryTextColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rule.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: rule.isEnabled,
                  activeTrackColor: primaryColor,
                  activeThumbColor: Colors.white,
                  inactiveTrackColor:
                      const Color(0xFF33484E),
                  inactiveThumbColor:
                      const Color(0xFF9BA9AC),
                  onChanged: (bool value) {
                    setState(() {
                      rule.isEnabled = value;
                    });

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            value
                                ? 'เปิดใช้งาน ${rule.title} แล้ว'
                                : 'ปิดใช้งาน ${rule.title} แล้ว',
                          ),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_motion_outlined,
            color: secondaryTextColor,
            size: 50,
          ),
          SizedBox(height: 12),
          Text(
            'ยังไม่มีกฎอัตโนมัติ',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
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
          currentIndex: _selectedBottomIndex,
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
          onTap: _onBottomNavigationTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.devices_other_outlined),
              activeIcon: Icon(Icons.devices_other_rounded),
              label: 'อุปกรณ์',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'สถิติ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_motion_outlined),
              activeIcon: Icon(Icons.auto_awesome_motion_rounded),
              label: 'อัตโนมัติ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'ตั้งค่า',
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavigationTap(int index) {
    if (index == _selectedBottomIndex) {
      return;
    }

    switch (index) {
      case 0:
        Navigator.maybePop(context);
        break;
      case 1:
        _showPageNotReady('หน้าอุปกรณ์');
        break;
      case 2:
        _showPageNotReady('หน้าสถิติ');
        break;
      case 3:
        setState(() {
          _selectedBottomIndex = 3;
        });
        break;
      case 4:
        _showPageNotReady('หน้าตั้งค่า');
        break;
    }
  }

  void _showPageNotReady(String pageName) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$pageName กำลังพัฒนา'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _showAddAutomationDialog() async {
    final TextEditingController titleController =
        TextEditingController();
    final TextEditingController subtitleController =
        TextEditingController();

    final bool? shouldAdd = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'เพิ่มกฎอัตโนมัติ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'ชื่อกฎ',
                  labelStyle: TextStyle(
                    color: secondaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subtitleController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'รายละเอียด',
                  labelStyle: TextStyle(
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ],
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
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: backgroundColor,
              ),
              child: const Text('เพิ่ม'),
            ),
          ],
        );
      },
    );

    final String title = titleController.text.trim();
    final String subtitle = subtitleController.text.trim();

    titleController.dispose();
    subtitleController.dispose();

    if (shouldAdd != true || title.isEmpty || subtitle.isEmpty) {
      return;
    }

    setState(() {
      final AutomationRule newRule = AutomationRule(
        title: title,
        subtitle: subtitle,
        icon: _selectedTab == 0
            ? Icons.auto_awesome_motion_rounded
            : Icons.schedule_rounded,
        isEnabled: true,
      );

      if (_selectedTab == 0) {
        _rules.add(newRule);
      } else {
        _schedules.add(newRule);
      }
    });
  }

  void _showAutomationDetails(AutomationRule rule) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  rule.icon,
                  color: primaryColor,
                  size: 42,
                ),
                const SizedBox(height: 12),
                Text(
                  rule.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rule.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  rule.isEnabled
                      ? 'สถานะ: เปิดใช้งาน'
                      : 'สถานะ: ปิดใช้งาน',
                  style: TextStyle(
                    color: rule.isEnabled
                        ? primaryColor
                        : secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AutomationRule {
  final String title;
  final String subtitle;
  final IconData icon;
  bool isEnabled;

  AutomationRule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
  });
}
