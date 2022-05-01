import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
class ConnectBluetoothDevice extends StatefulWidget {
  const ConnectBluetoothDevice({required this.age,required this.onSelectPatient});
  final int age;
  final ValueChanged<Map> onSelectPatient;
  @override
  _ConnectBluetoothDeviceState createState() => _ConnectBluetoothDeviceState();
}

class _ConnectBluetoothDeviceState extends State<ConnectBluetoothDevice> {
  List<BluetoothService> _services = <BluetoothService>[];
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  BluetoothCharacteristic? _bleCharacterisitcs;
  StreamSubscription? stream;
  ChartSeriesController? _chartSeriesController;
  List<_ChartData>? chartData;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _connectedDevice;
  String deviceStatus="Stethoscope Connection";
  bool _isDeviceConnected=false;
  bool _isDeviceScanStartedFirstTime=true;
  DateTime? startTime;
  DateTime? EndTime;
  int BeatsPerMinut=0;
  int bpm=0;
  String bpmStatus="";

  int ElapsedTimeInSecond=0;
  int num=1;
  bool _isDeviceStartedListening=false;
  _addDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }


   scanForDevices()async{
    setState(() {
      deviceStatus="Scanning Device";
    });
     print("scanning device");
     await flutterBlue.connectedDevices
         .asStream()
         .listen((List<BluetoothDevice> devices) async{
       for (BluetoothDevice device in devices) {
         if(device.name=="BT05"){
          device.disconnect();

         }

       }
     });

     await flutterBlue.startScan(timeout: Duration(seconds: 5));

     await flutterBlue.scanResults.listen((List<ScanResult> results) async{
       for (ScanResult result in results) {
         if(result.device.name=="BT05"){
           print("Device Found");
           setState(() {
             deviceStatus="Device Found";
           });
           await _addDeviceTolist(result.device);
           await flutterBlue.stopScan();
           return;
         }

       }
     });
  }
   connecttDevice()async{

    for (BluetoothDevice device in devicesList) {
      print("Looping Device List");
      print(device.name);
      if(device.name=='BT05'){
        setState(() {
          deviceStatus="Connecting to Device";
        });
        print("Connecting To Device");
        await device.connect();
        print("Connected Success");
        _services = await device.discoverServices();
        _connectedDevice = device;
        print("Service Discovered");
        //print(_connectedDevice);
        for (BluetoothService service in _services) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            print("UUID:${characteristic.uuid}");
            if(characteristic.uuid.toString()=="0000ffe1-0000-1000-8000-00805f9b34fb"){
              setState(() {
                _isDeviceConnected=true;
                setState(() {
                  deviceStatus="Device Connected";
                });
                print("Device Connected");
                _bleCharacterisitcs=characteristic;
                return ;
              });

            }
          }
        }
      }
    }
  }
  void _updateDataSource(int number,int number2) {


    chartData!.add(_ChartData(number,number2));
    if (chartData!.length > 20) {
      chartData!.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
      );
    }

  }
  SfCartesianChart _buildLiveLineChart() {
    print(chartData);

    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
        NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0)),
        series: <LineSeries<_ChartData, int>>[
          LineSeries<_ChartData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData!,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (_ChartData sales, _) => sales.soundValue,
            yValueMapper: (_ChartData sales, _) => sales.time,
            animationDuration: 0,
          )
        ]);
  }
   readValueFromConnectedDevice(BluetoothCharacteristic characteristic)async{
    print("Listening Device");
    setState(() {
      _isDeviceStartedListening=true;
    });

    if(characteristic!=null && _isDeviceConnected){
      chartData!.clear();

      startTime=DateTime.now();
      BeatsPerMinut=0;
      stream=characteristic.value.listen((value) {
        String BlData=ascii.decode(value).toString();
        if(int.parse(BlData)>0){
          BeatsPerMinut++;
        }
        num++;
        _updateDataSource(num, int.parse(BlData));
        print(value);

      });

        if(!characteristic.isNotifying)
          await characteristic.setNotifyValue(true);

    }



  }
stopListen()async {

EndTime=DateTime.now();
ElapsedTimeInSecond=EndTime!.difference(startTime!).inSeconds;
 await  _connectedDevice!.disconnect();
 calculateBPOStatus(widget.age, double.parse(BeatsPerMinut.toString()), ElapsedTimeInSecond);
 setState(() {
   _isDeviceConnected=false;
   _isDeviceStartedListening=false;
   _isDeviceScanStartedFirstTime=false;
 });

}

  EstablishConnection()async{
    await scanForDevices();

    print(devicesList.length);
    await connecttDevice();



  }
  calculateBPOStatus(int age,double beepsPerSecond,int elapsedSecond){
    double bpm=1.2*elapsedSecond;
    this.bpm=bpm.toInt();
    int ageNumber=220-age;
    double seventyPercentageofAgeNumber=(ageNumber*70)/100;
    double fiftyPercentageofAgeNumber=(ageNumber*50)/100;
    if(bpm>=fiftyPercentageofAgeNumber && bpm<=seventyPercentageofAgeNumber){
      bpmStatus="Normal";

    }
    else if(bpm>seventyPercentageofAgeNumber)
      bpmStatus="High";
    else if(bpm<fiftyPercentageofAgeNumber)
      bpmStatus="Low";
  }
  @override
  void initState() {
    // TODO: implement initState

    chartData = <_ChartData>[
    _ChartData(1, 47),
    _ChartData(2, 33),
    _ChartData(3, 49),
    _ChartData(4, 54),
    _ChartData(5, 41),
    _ChartData(6, 58),
    _ChartData(7, 51),
    _ChartData(8, 98),
    _ChartData(9, 41),
    _ChartData(10, 53),
    _ChartData(11, 72),
    _ChartData(12, 86),
    _ChartData(13, 52),
    _ChartData(14, 94),
    _ChartData(15, 92),
    _ChartData(16, 86),
    _ChartData(17, 72),
    _ChartData(18, 94),
];

    EstablishConnection();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Blue Steth"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Center(child: Text("Status: $deviceStatus",style: TextStyle(fontSize: 18),),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: _isDeviceScanStartedFirstTime?true:false,
                  child: ElevatedButton.icon(onPressed: ()async{
                    if(_isDeviceConnected){
                      if(_bleCharacterisitcs!=null)
                        await readValueFromConnectedDevice(_bleCharacterisitcs!);
                    }
                    else{
                      if(_connectedDevice!=null){
                        EstablishConnection();
                      }

                    }

                  }, icon: Icon(Icons.bluetooth),style: ElevatedButton.styleFrom(primary: _isDeviceConnected?Colors.blue:Colors.black12), label: Text("Listen For Pulse")
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton.icon(onPressed: ()async{
                  if(_isDeviceStartedListening)
                    stopListen();

                }, icon: Icon(Icons.ac_unit),style: ElevatedButton.styleFrom(primary: _isDeviceStartedListening?Colors.blue:Colors.black12), label: Text("Stop Listening")),

              ],
            ),
            SizedBox(height: 50,),
            _buildLiveLineChart(),
            SizedBox(height: 20,),
            Visibility(child:
                Column(
                  children: [
                    Text("Result",style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold,fontSize: 20
                    ),),
                    SizedBox(height: 10,),
                    Text("BPM(Beats Per Minute): ${bpm}"),
                    SizedBox(height: 10,),
                    Text("Elapsed Time(Seconds): ${ElapsedTimeInSecond}"),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 150,
                        height: 50,
                        child: Center(child: Text(bpmStatus,style: TextStyle(color: Colors.white),)),
                        decoration: BoxDecoration(  borderRadius: BorderRadius.circular(15),color: bpmStatus=="Normal"?Colors.green:bpmStatus=="Low"?Colors.amber:bpmStatus=="High"?Colors.deepOrange:Colors.black),

                      ),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton.icon(onPressed: (){
                      var ledgerDetails={
                        'bpm':bpm.toString(),
                        'bpmStatus':bpmStatus
                      };
                      widget.onSelectPatient(ledgerDetails);
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.check_circle,color: Colors.white,),style: ElevatedButton.styleFrom(primary: Colors.green), label: Text("Submite Result"))

                  ],
                ),
              visible: _isDeviceScanStartedFirstTime?false:true,
            )
          ],
        )
      ),
    );
  }
}
class _ChartData {
  _ChartData(this.soundValue, this.time);
  final int soundValue;
  final num time;
}