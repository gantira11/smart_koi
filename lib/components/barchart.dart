import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_koi/constant.dart';

class Barchart extends StatefulWidget {
  const Barchart({
    Key? key,
    required this.data,
    required this.sort,
  }) : super(key: key);

  final List data;
  final String sort;

  @override
  State<Barchart> createState() => _BarchartState();
}

class _BarchartState extends State<Barchart> {
  final Color leftBarColor = primary;
  final Color middleBarColor = const Color(0xFFC149AD);
  final Color rightBarColor = secondary;
  final double width = 7;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = 0;

  List data = [];
  List<String> title = [];
  List<BarChartGroupData> items = [];
  List<BarChartGroupData> itemsPermintaan = [];
  List<BarChartGroupData> itemsPersediaan = [];
  List<BarChartGroupData> itemsProduksi = [];

  @override
  void initState() {
    super.initState();
    // fetchData();
    data = widget.data;

    title = List.generate(
      data.length,
      (index) => formater.format(
        DateTime.parse(data[index]['period_date']),
      ),
    );

    items = List.generate(
      data.length,
      (index) => makeGroupData(
        index,
        data[index]['market_demand'],
        data[index]['stock'],
        data[index]['production'],
      ),
    );

    itemsPermintaan = List.generate(
      data.length,
      (index) => makeGroupData(
        index,
        0,
        data[index]['market_demand'],
        0,
      ),
    );

    itemsPersediaan = List.generate(
      data.length,
      (index) => makeGroupData(
        index,
        0,
        data[index]['stock'],
        0,
      ),
    );

    itemsProduksi = List.generate(
      data.length,
      (index) => makeGroupData(
        index,
        0,
        data[index]['production'],
        0,
      ),
    );

    rawBarGroups = widget.sort == ''
        ? items
        : widget.sort == 'permintaan'
            ? itemsPermintaan
            : widget.sort == 'persediaan'
                ? itemsPersediaan
                : widget.sort == 'produksi'
                    ? itemsProduksi
                    : items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data.isEmpty
          ? Container()
          : AspectRatio(
              aspectRatio: 1,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          makeTransactionsIcon(),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            'Grafik Produksi 3 Periode Terakhir',
                            style: TextStyle(
                              color: Color(0xff77839a),
                              fontSize: 14,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            maxY: widget.sort == 'persediaan' ? 200 : 4000,
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitles,
                                  reservedSize: 42,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  interval: 1,
                                  getTitlesWidget: widget.sort == 'persediaan'
                                      ? leftTitlesPersediaan
                                      : leftTitles,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                left: BorderSide(
                                  width: 0.5,
                                  color: Color(0xff77839a),
                                ),
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color(0xff77839a),
                                ),
                              ),
                            ),
                            barGroups: showingBarGroups,
                            gridData: FlGridData(show: false),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 1000) {
      text = '1K';
    } else if (value == 2000) {
      text = '2K';
    } else if (value == 3000) {
      text = '3K';
    } else if (value == 4000) {
      text = '4K';
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2,
      child: Text(
        text,
        style: style,
      ),
    );
  }

  Widget leftTitlesPersediaan(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 50) {
      text = '50';
    } else if (value == 100) {
      text = '100';
    } else if (value == 150) {
      text = '150';
    } else if (value == 200) {
      text = '200';
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2,
      child: Text(
        text,
        style: style,
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    List<String> titles = title;

    Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 12, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, int y1, int y2, int y3) {
    return BarChartGroupData(barsSpace: 3, x: x, barRods: [
      BarChartRodData(
        toY: y1.toDouble(),
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y2.toDouble(),
        color: widget.sort == 'permintaan'
            ? leftBarColor
            : widget.sort == 'persediaan'
                ? middleBarColor
                : widget.sort == 'produksi'
                    ? rightBarColor
                    : middleBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y3.toDouble(),
        color: rightBarColor,
        width: width,
      )
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFC149AD).withOpacity(1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          decoration: BoxDecoration(
            color: secondary.withOpacity(1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          decoration: BoxDecoration(
            color: primary.withOpacity(1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          decoration: BoxDecoration(
            color: secondary.withOpacity(1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFC149AD).withOpacity(1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
