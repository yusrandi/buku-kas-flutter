import 'package:flutter/material.dart';
import 'package:irza/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<GDPData> chartData;
  late List<GDPData> chartDataX;
  late List<ChartDataPie> chartDataPie;

  @override
  void initState() {
    super.initState();
    chartData = getChartData();
    chartDataX = getChartDataX();
    chartDataPie = getChartDataPie();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SfCircularChart(series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartDataPie, String>(
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: chartDataPie,
              enableSmartLabels: true,
              pointColorMapper: (ChartDataPie data, _) => data.color,
              dataLabelMapper: (ChartDataPie data, _) => data.x,
              xValueMapper: (ChartDataPie data, _) => data.x,
              yValueMapper: (ChartDataPie data, _) => data.y),
        ])),
        Expanded(
            child: SfCartesianChart(
          series: <ColumnSeries<GDPData, String>>[
            // Renders bar chart
            ColumnSeries<GDPData, String>(
                color: Colors.green[600],
                dataSource: chartData,
                xValueMapper: (GDPData gdp, _) => gdp.continent,
                yValueMapper: (GDPData gdp, _) => gdp.gdp),
            ColumnSeries<GDPData, String>(
                color: Colors.red[400],
                dataSource: chartDataX,
                xValueMapper: (GDPData gdp, _) => gdp.continent,
                yValueMapper: (GDPData gdp, _) => gdp.gdp),
          ],
          primaryXAxis: CategoryAxis(),
        )),
      ],
    );
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData("2016", 16, "Pemasukan"),
      GDPData("2017", 24, "Pemasukan"),
      GDPData("2018", 30, "Pemasukan"),
      GDPData("2019", 10, "Pemasukan"),
      GDPData("2020", 40, "Pemasukan"),
    ];

    return chartData;
  }

  List<GDPData> getChartDataX() {
    final List<GDPData> chartData = [
      GDPData("2016", 10, "Pengeluaran"),
      GDPData("2017", 20, "Pengeluaran"),
      GDPData("2018", 35, "Pengeluaran"),
      GDPData("2019", 20, "Pengeluaran"),
      GDPData("2020", 20, "Pengeluaran"),
    ];

    return chartData;
  }

  List<ChartDataPie> getChartDataPie() {
    final List<ChartDataPie> chartData = [
      ChartDataPie('Hiburan', 25, Colors.blue),
      ChartDataPie('Pendidikan', 38, Colors.red.shade600),
      ChartDataPie('Tagihan', 34, Colors.green.shade600),
      ChartDataPie('Jasa', 20, Colors.pink.shade600),
      ChartDataPie('Others', 52, Colors.orangeAccent)
    ];

    return chartData;
  }
}

class GDPData {
  final String continent;
  final String status;
  final double gdp;

  GDPData(this.continent, this.gdp, this.status);
}

class ChartDataPie {
  ChartDataPie(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
