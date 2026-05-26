import 'package:flutter/foundation.dart';
import 'package:honeywell/product.dart';
import 'package:intl/intl.dart';

/// Helper function to build an Arabic receipt string with center alignment
String buildArabicReceipt(List<Product> products) {
  double grandTotal = 0;

  // Get the current time formatted as "HH:mm"
  String formattedTime = DateFormat('HH:mm').format(DateTime.now());
  String formattedDate = DateFormat('d MMMM y').format(DateTime.now());

  // Define receipt width in characters (adjust based on your printer's character width)
  const int receiptWidth = 40; // Start with a smaller width for debugging

  // Helper function to center-align text
  String centerAlign(String text) {
    /// todo : investigate
    int totalPadding = receiptWidth - text.length;
    int paddingLeft = (totalPadding / 2).floor();
    int paddingRight = totalPadding - paddingLeft;
    return ' ' * paddingLeft + text + ' ' * paddingRight;
  }

  // Initialize the receipt string
  String receipt = '';

  // Add receipt header
  receipt += '${centerAlign("إيصال دفع")}\n';
  receipt += '${centerAlign("________________________________")}\n';
  receipt += '${centerAlign("التاريخ: $formattedDate $formattedTime")}\n';
  receipt += '${centerAlign("________________________________")}\n';
  receipt += '${centerAlign("التوقيت: $formattedTime")}\n';

  receipt +=
      '${centerAlign("رقم الإيصال: ${DateTime.now().millisecondsSinceEpoch}")}\n';
  receipt += '${centerAlign("------------")}\n';
  receipt += '${centerAlign("العنوان: شارع الزيتون، القاهرة")}\n';
  receipt += '${centerAlign("---------------------------------")}\n';
  receipt += '${centerAlign("المنتجات:")}\n';
  receipt += '${centerAlign("---------------------------------")}\n';

  // Add table headers
  receipt += '${centerAlign("اسم المنتج        الكمية        الإجمالي")}\n';
  receipt += '${centerAlign("---------------------------------")}\n';

  // Add product details
  for (var product in products) {
    grandTotal += product.total;
    String line =
        "${product.productName.padRight(15)} ${product.quantity.toString().padRight(10)} ${product.total.toStringAsFixed(2)}";
    receipt += '${centerAlign(line)}\n';
  ///TODO:REFORMAT RECEIPT STRUCTURE
  }
  // Add total
  receipt += '${centerAlign("---------------------------------")}\n';
  receipt +=
      '${centerAlign("الإجمالي الكلي: ${grandTotal.toStringAsFixed(2)} جنيه")}\n';
  receipt += '\n';
  receipt += '${centerAlign("________________________________")}\n';
  receipt += '${centerAlign("شكراً لتسوقكم معنا!")}\n';

  // Use debugPrint for larger output
  if (kDebugMode) {
    print(receipt);
  }
  return receipt;
}
