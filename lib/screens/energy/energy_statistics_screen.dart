import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EnergyStatisticsScreen extends StatefulWidget {
  const EnergyStatisticsScreen({super.key});

  @override
  State<EnergyStatisticsScreen> createState() => _EnergyStatisticsScreenState();
}

class _EnergyStatisticsScreenState extends State<EnergyStatisticsScreen> {
  int selectedTab = 1;

  DateTime selectedDate = DateTime(2024, 5, 16);

  final List<double> hourlyEnergy = <double>[
    0.4,
    0.7,
    0.5,
    1.2,
    1.6,
    1.1,
    1.9,
    1.4,
    1.6,
    2.2,
    2.7,
    2.0,
    1.7,
    1.5,
    2.1,
    1.4,
    2.8,
    2.4,
    1.9,
    1.2,
    1.6,
    1.8,
    1.0,
    0.6,
  ];

  final List<EnergyDeviceItem> devices = const <EnergyDeviceItem>[
    EnergyDeviceItem(
      name: 'แอร์',
      value: 6.25,
      percentage: 50,
      color: Color(0xFF43D7C8),
    ),
    EnergyDeviceItem(
      name: 'เครื่องทำน้ำอุ่น',
      value: 2.80,
      percentage: 22,
      color: Color(0xFF3FB7CF),
    ),
    EnergyDeviceItem(
      name: 'ตู้เย็น',
      value: 1.50,
      percentage: 12,
      color: Color(0xFF5F93E8),
    ),
    EnergyDeviceItem(
      name: 'แสงสว่าง',
      value: 1.20,
      percentage: 10,
      color: Color(0xFF9D78E8),
    ),
    EnergyDeviceItem(
      name: 'อื่น ๆ',
      value: 0.70,
      percentage: 6,
      color: Color(0xFF727D8A),
    ),
  ];

  String get formattedDate {
    final int buddhistYear = selectedDate.year + 543;

    const List<String> thaiMonths = <String>[
      '',
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];

    return '${selectedDate.day} '
        '${thaiMonths[selectedDate.month]} '
        '$buddhistYear';
  }

  void changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(
        Duration(days: days),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF071C24);
    const Color cardColor = Color(0xFF0D2932);
    const Color primaryColor = Color(0xFF42D6C3);
    const Color secondaryTextColor = Color(0xFF839BA3);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text(
          'สถิติการใช้พลังงาน',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTabs(
                primaryColor: primaryColor,
                cardColor: cardColor,
              ),
              const SizedBox(height: 18),
              _buildDateSelector(
                textColor: secondaryTextColor,
              ),
              const SizedBox(height: 20),
              _buildEnergySummary(
                primaryColor: primaryColor,
                secondaryTextColor: secondaryTextColor,
              ),
              const SizedBox(height: 20),
              _buildChart(
                primaryColor: primaryColor,
                secondaryTextColor: secondaryTextColor,
              ),
              const SizedBox(height: 24),
              _buildDeviceSection(
                cardColor: cardColor,
                secondaryTextColor: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs({
    required Color primaryColor,
    required Color cardColor,
  }) {
    const List<String> tabs = <String>[
      'วัน',
      'สัปดาห์',
      'เดือน',
      'ปี',
    ];

    return Container(
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
            final bool isSelected = selectedTab == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color:
                          isSelected ? primaryColor : const Color(0xFF8DA3AA),
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required Color textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () => changeDate(-1),
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        Text(
          formattedDate,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: () => changeDate(1),
          icon: const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergySummary({
    required Color primaryColor,
    required Color secondaryTextColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Text(
          '12.45',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            'kWh',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.trending_up,
                color: primaryColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '8.5%',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart({
    required Color primaryColor,
    required Color secondaryTextColor,
  }) {
    return SizedBox(
      height: 230,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 3.2,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (double value) {
              return FlLine(
                color: Colors.white.withValues(alpha: 0.08),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(2)} kWh',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 26,
                getTitlesWidget: (
                  double value,
                  TitleMeta meta,
                ) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (
                  double value,
                  TitleMeta meta,
                ) {
                  final int hour = value.toInt();

                  if (hour != 0 &&
                      hour != 6 &&
                      hour != 12 &&
                      hour != 18 &&
                      hour != 23) {
                    return const SizedBox.shrink();
                  }

                  final String text = hour == 23
                      ? '24:00'
                      : '${hour.toString().padLeft(2, '0')}:00';

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List<BarChartGroupData>.generate(
            hourlyEnergy.length,
            (int index) {
              return BarChartGroupData(
                x: index,
                barRods: <BarChartRodData>[
                  BarChartRodData(
                    toY: hourlyEnergy[index],
                    width: 6,
                    color: primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceSection({
    required Color cardColor,
    required Color secondaryTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'รายละเอียด',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          child: Column(
            children: devices.map(
              (EnergyDeviceItem device) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: device.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          device.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        '${device.value.toStringAsFixed(2)} kWh',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 42,
                        child: Text(
                          '(${device.percentage}%)',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class EnergyDeviceItem {
  final String name;
  final double value;
  final int percentage;
  final Color color;

  const EnergyDeviceItem({
    required this.name,
    required this.value,
    required this.percentage,
    required this.color,
  });
}
