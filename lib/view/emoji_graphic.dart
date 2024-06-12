import 'package:dream_diary/auth/auth_dreams.dart';
import 'package:dream_diary/utility/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EmojiGraphic extends StatefulWidget {

  @override
  State<EmojiGraphic> createState() => _EmojiGraphicState();
}

class _EmojiGraphicState extends State<EmojiGraphic> {
  @override
  Widget build(BuildContext context) {
    List<double> emojiValues = [];
    List<String> emojiTitles = [];
    double allDreamsCount = 0;
    for(var emoji in emojis){
      double count = 0;
      for(var doc in AuthDreams.dreams!.docs){
        if(FirebaseAuth.instance.currentUser != null) {
          if(doc['user id'] == FirebaseAuth.instance.currentUser!.uid&&
        doc['emoji'] == emoji
        ){
          count += 1;
          allDreamsCount += 1;
        }
        }
      }
      emojiValues.add(count);
    }
    for(var value in emojiValues){
      double title = (value/allDreamsCount)*100;
      emojiTitles.add('${title.toStringAsFixed(1)}%');
    }
    return AspectRatio(
      aspectRatio: 1.4,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections(emojiValues,emojiTitles),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      List<double> emojiValues, List<String> emojiTitles) {
    return List.generate(emojis.length, (i) {
      final fontSize =  16.0;
      final radius =  100.0;
      final widgetSize = 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: emojiBackgroundColors[i],
        value: emojiValues[i],
        title: emojiTitles[i],
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          emojis[i],
          size: widgetSize,
          borderColor: Colors.black,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.emoji, {
        required this.size,
        required this.borderColor,
      });

  final String emoji;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .05),
      child: Center(
        child: Text(emoji,style: TextStyle(
          fontSize: size == 55?26:18
        ),),
      ),
    );
  }
}
