import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:honeywell/product.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'helper_function.dart';
import 'image_to_zpl.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honeywell Printer Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PrinterScreen(),
    );
  }
}

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({Key? key}) : super(key: key);

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothConnect.request().isGranted &&
        await Permission.bluetoothScan.request().isGranted) {
      // Permissions are granted, proceed with your Bluetooth operation
    } else {
      // Handle the case where permissions are not granted
      print("Bluetooth permissions not granted!");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Honeywell Printer Example')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Print Button
          ElevatedButton(
            onPressed: () async {
              final device = await _selectDevice(context);
              if (device != null) {
                // Sample product list
                List<Product> products = [
                  Product("كتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتابكتاب  ", 1, 30.0, ),
                  // Product("قلم", 2, 10.0, ),
                  // Product("حقيبة", 1, 70.0, ),
                  // Product("قفاز", 1, 70.0, ),
                  // Product("اريكة", 1, 70.0),
                  // Product("لعبة اطفال", 1, 70.0,),
                  // Product("طاولة", 1, 70.0,),
                  // Product("كرسي", 1, 70.0, ),
                  // Product("شيبسي", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 999.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("كرة سلة", 1, 90.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 88.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0,),
                  // Product("دبابيس", 1, 70.0, ),
                  // Product("دبابيس", 1, 70.0, ),
                ];

                // Build receipt string
                String arabicReceipt = buildArabicReceipt(products);
                // Generate ZPL
                var converter1 = ArabicTextZplConverter();
                final zpl = await converter1.generateArabicTextAsZPL(arabicReceipt);

                // Print to the selected device
                await _printToDevice(device.address, zpl);
              }
            },
            child: const Text('Print Arabic Receipt'),
          ),
        ],
      ),
    );
  }


  Future<BluetoothDevice?> _selectDevice(BuildContext context) async {
    final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    return await showDialog<BluetoothDevice>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Printer'),
          children: devices
              .map((device) => SimpleDialogOption(
            onPressed: () => Navigator.pop(context, device),
            child: Text(device.name ?? device.address),
          ))
              .toList(),
        );
      },
    );
  }

  Future<void> _printToDevice(String address, String zpl) async {
    try {
      final connection = await BluetoothConnection.toAddress(address);
      connection.output.add(Uint8List.fromList(zpl.codeUnits));
      await connection.output.allSent;
      await connection.finish();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Printed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
  }
}