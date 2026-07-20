import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const Color backgroundColor = Color(0xFF071C24);
  static const Color cardColor = Color(0xFF102C35);
  static const Color primaryColor = Color(0xFF41D6C3);
  static const Color borderColor = Color(0xFF1A444B);
  static const Color secondaryTextColor = Color(0xFF8FA8AE);

  int _selectedTab = 0;
  int _currentBottomIndex = 3;

  String _selectedMonth = 'พฤษภาคม 2569';

  final List<String> _months = const [
    'มกราคม 2569',
    'กุมภาพันธ์ 2569',
    'มีนาคม 2569',
    'เมษายน 2569',
    'พฤษภาคม 2569',
    'มิถุนายน 2569',
    'กรกฎาคม 2569',
    'สิงหาคม 2569',
    'กันยายน 2569',
    'ตุลาคม 2569',
    'พฤศจิกายน 2569',
    'ธันวาคม 2569',
  ];

  final List<BillDetail> _billDetails = const [
    BillDetail(
      title: 'ค่าไฟฟ้าตามการใช้งาน',
      value: '1,012.20 บาท',
    ),
    BillDetail(
      title: 'ค่าบริการรายเดือน',
      value: '38.22 บาท',
    ),
    BillDetail(
      title: 'ค่าผันแปรอัตโนมัติ (Ft)',
      value: '70.91 บาท',
    ),
    BillDetail(
      title: 'ภาษีมูลค่าเพิ่ม 7%',
      value: '168.12 บาท',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopTabs(),
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _buildSummaryPage(),
                  _buildComparisonPage(),
                  _buildForecastPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: const Text(
        'รายงานค่าไฟ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showReportOptions,
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTopTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0B252E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          _buildTabButton(
            index: 0,
            title: 'สรุป',
          ),
          _buildTabButton(
            index: 1,
            title: 'เปรียบเทียบ',
          ),
          _buildTabButton(
            index: 2,
            title: 'การคาดการณ์',
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String title,
  }) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.transparent,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? primaryColor : secondaryTextColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthDropdown(),
          const SizedBox(height: 14),
          _buildTotalBillCard(),
          const SizedBox(height: 14),
          _buildBillDetailsCard(),
          const SizedBox(height: 14),
          _buildEnergyUsageCard(),
          const SizedBox(height: 14),
          _buildDownloadButton(),
        ],
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMonth,
          isExpanded: true,
          dropdownColor: cardColor,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: secondaryTextColor,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          items: _months.map((month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Text(month),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              _selectedMonth = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTotalBillCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'ค่าไฟฟ้ารวม',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1,289.45 บาท',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_downward_rounded,
                  color: primaryColor,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '7.3% น้อยกว่าเดือนที่แล้ว',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'ค่าไฟฟ้าจากรายการ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...List.generate(
            _billDetails.length,
            (index) {
              final detail = _billDetails[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDetailRow(
                  title: detail.title,
                  value: detail.value,
                ),
              );
            },
          ),
          const Divider(
            color: Color(0xFF23434A),
            height: 18,
          ),
          const SizedBox(height: 3),
          _buildDetailRow(
            title: 'รวม',
            value: '1,289.45 บาท',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isTotal ? Colors.white : secondaryTextColor,
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? primaryColor : Colors.white,
            fontSize: isTotal ? 15 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyUsageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                color: primaryColor,
                size: 21,
              ),
              SizedBox(width: 7),
              Text(
                'ข้อมูลการใช้พลังงาน',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildEnergyItem(
                  title: 'พลังงานที่ใช้',
                  value: '287.50',
                  unit: 'kWh',
                  icon: Icons.electric_meter_outlined,
                ),
              ),
              Container(
                width: 1,
                height: 55,
                color: const Color(0xFF23434A),
              ),
              Expanded(
                child: _buildEnergyItem(
                  title: 'เฉลี่ยต่อวัน',
                  value: '9.27',
                  unit: 'kWh',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyItem({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 20,
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: const TextStyle(
            color: secondaryTextColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 5),
        RichText(
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
      ],
    );
  }

  Widget _buildDownloadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showMessage('กำลังเตรียมไฟล์รายงาน');
        },
        icon: const Icon(
          Icons.download_rounded,
          size: 20,
        ),
        label: const Text(
          'ดาวน์โหลดรายงาน',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          _buildMonthDropdown(),
          const SizedBox(height: 14),
          _buildInformationCard(
            icon: Icons.compare_arrows_rounded,
            title: 'เปรียบเทียบค่าไฟ',
            description:
                'ค่าไฟเดือนนี้ลดลง 101.55 บาท เมื่อเปรียบเทียบกับเดือนก่อน',
          ),
          const SizedBox(height: 14),
          _buildComparisonCard(
            title: 'เดือนก่อน',
            month: 'เมษายน 2569',
            value: '1,391.00 บาท',
            color: secondaryTextColor,
          ),
          const SizedBox(height: 10),
          _buildComparisonCard(
            title: 'เดือนปัจจุบัน',
            month: _selectedMonth,
            value: '1,289.45 บาท',
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required String month,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: color,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  month,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          _buildInformationCard(
            icon: Icons.auto_graph_rounded,
            title: 'คาดการณ์ค่าไฟเดือนถัดไป',
            description: 'ระบบประเมินจากรูปแบบการใช้พลังงานในช่วงที่ผ่านมา',
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.trending_down_rounded,
                  color: primaryColor,
                  size: 42,
                ),
                SizedBox(height: 10),
                Text(
                  'ประมาณ 1,245.00 บาท',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'คาดว่าจะลดลงประมาณ 3.4%',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildSavingSuggestionCard(),
        ],
      ),
    );
  }

  Widget _buildInformationCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingSuggestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'คำแนะนำประหยัดพลังงาน',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 13),
          Text(
            '• ปิดเครื่องปรับอากาศก่อนออกจากห้อง',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              height: 1.7,
            ),
          ),
          Text(
            '• ตั้งอุณหภูมิเครื่องปรับอากาศที่ 26°C',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              height: 1.7,
            ),
          ),
          Text(
            '• ถอดปลั๊กอุปกรณ์เมื่อไม่ได้ใช้งาน',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              height: 1.7,
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
          currentIndex: _currentBottomIndex,
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
          onTap: _handleBottomNavigation,
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
              icon: Icon(Icons.bolt_outlined),
              activeIcon: Icon(Icons.bolt_rounded),
              label: 'พลังงาน',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description_rounded),
              label: 'รายงาน',
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

  void _handleBottomNavigation(int index) {
    if (index == 3) {
      setState(() {
        _currentBottomIndex = 3;
      });
      return;
    }

    if (index == 0 && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _currentBottomIndex = index;
    });

    const pageNames = [
      'หน้าหลัก',
      'หน้าอุปกรณ์',
      'หน้าพลังงาน',
      'หน้ารายงาน',
      'หน้าตั้งค่า',
    ];

    _showMessage('กรุณาเชื่อม ${pageNames[index]} ในระบบนำทาง');
  }

  void _showReportOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: secondaryTextColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf_outlined,
                    color: primaryColor,
                  ),
                  title: const Text(
                    'ส่งออกเป็น PDF',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage('กำลังเตรียมไฟล์ PDF');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.share_outlined,
                    color: primaryColor,
                  ),
                  title: const Text(
                    'แชร์รายงาน',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage('ฟังก์ชันแชร์รายงานกำลังพัฒนา');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: cardColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class BillDetail {
  final String title;
  final String value;

  const BillDetail({
    required this.title,
    required this.value,
  });
}
