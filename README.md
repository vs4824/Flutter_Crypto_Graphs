# Crypto Graphs

## chart_sparkline

Beautiful sparkline charts for Flutter.

### Quick Start 

import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

void main() {
var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
runApp(
MaterialApp(
home: Scaffold(
body: Center(
child: Container(
width: 300.0,
height: 100.0,
child: Sparkline(
data: data,
),
),
),
),
),
);
}




