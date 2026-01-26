import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20,
          // Tooltip ao tocar
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.deepPurpleAccent,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.round()} pessoas',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          // Títulos
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30, 
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
                  String text;
                  switch (value.toInt()) {
                    case 0: text = '06h'; break;
                    case 1: text = '09h'; break;
                    case 2: text = '12h'; break;
                    case 3: text = '18h'; break;
                    case 4: text = '21h'; break;
                    default: text = '';
                  }
                  
                  // AQUI ESTÁ A CORREÇÃO: Usamos Padding simples
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroupData(0, 5),
            _makeGroupData(1, 12),
            _makeGroupData(2, 8),
            _makeGroupData(3, 18, isPeak: true),
            _makeGroupData(4, 10),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, {bool isPeak = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isPeak ? Colors.redAccent : Colors.deepPurpleAccent,
          width: 22,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: Colors.white10,
          ),
        ),
      ],
    );
  }
}