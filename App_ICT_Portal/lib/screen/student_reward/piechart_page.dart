// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class PieChartPage extends StatelessWidget {
//   final Map<String, int> skillFrequencies;

//   PieChartPage({required this.skillFrequencies});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Skill Level Distribution'),
//       ),
//       body: Center(
//         child: PieChart(
//           PieChartData(
//             sections: skillFrequencies.entries.map((entry) {
//               return PieChartSectionData(
//                 // color: getRandomColor(), // Define or use a function to generate colors
//                 value: entry.value.toDouble(),
//                 title: '${entry.key}: ${entry.value}',
//                 radius: 100,
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
