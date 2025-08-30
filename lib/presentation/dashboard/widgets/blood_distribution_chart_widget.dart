import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

/// Widget displaying blood type distribution using interactive pie chart
/// with medical color coding and accessibility features
class BloodDistributionChartWidget extends StatefulWidget {
  final Map<String, int> bloodTypeData;

  const BloodDistributionChartWidget({
    super.key,
    required this.bloodTypeData,
  });

  @override
  State<BloodDistributionChartWidget> createState() =>
      _BloodDistributionChartWidgetState();
}

class _BloodDistributionChartWidgetState
    extends State<BloodDistributionChartWidget> {
  int? _touchedIndex;

  // Medical color palette for blood types
  static const List<Color> _bloodTypeColors = [
    Color(0xFFD32F2F), // A+ - Medical Red
    Color(0xFFE57373), // O+ - Light Red
    Color(0xFF1976D2), // B+ - Medical Blue
    Color(0xFF42A5F5), // AB+ - Light Blue
    Color(0xFF388E3C), // A- - Medical Green
    Color(0xFF66BB6A), // O- - Light Green
    Color(0xFFF57C00), // B- - Medical Orange
    Color(0xFFFFB74D), // AB- - Light Orange
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.black.withAlpha(13)
                : Colors.white.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Donor Distribution by Blood Type',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Touch segments for detailed information',
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ),

          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // Pie Chart
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = null;
                              return;
                            }
                            _touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _buildPieChartSections(),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Legend
                Expanded(
                  flex: 2,
                  child: _buildLegend(context),
                ),
              ],
            ),
          ),

          // Total count
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total Active Donors: ${_getTotalCount()}',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final List<String> bloodTypes = widget.bloodTypeData.keys.toList();
    final int totalCount = _getTotalCount();

    return bloodTypes.asMap().entries.map((entry) {
      final int index = entry.key;
      final String bloodType = entry.value;
      final int count = widget.bloodTypeData[bloodType] ?? 0;
      final bool isTouched = index == _touchedIndex;

      return PieChartSectionData(
        color: _bloodTypeColors[index % _bloodTypeColors.length],
        value: count.toDouble(),
        title: isTouched ? '$count' : '',
        radius: isTouched ? 65.0 : 55.0,
        titleStyle: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final List<String> bloodTypes = widget.bloodTypeData.keys.toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: bloodTypes.asMap().entries.map((entry) {
        final int index = entry.key;
        final String bloodType = entry.value;
        final int count = widget.bloodTypeData[bloodType] ?? 0;
        final Color color = _bloodTypeColors[index % _bloodTypeColors.length];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bloodType,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Text(
                count.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  int _getTotalCount() {
    return widget.bloodTypeData.values.fold(0, (sum, count) => sum + count);
  }
}
