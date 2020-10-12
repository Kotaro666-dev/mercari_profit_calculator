import 'package:flutter/material.dart';
import 'package:mercari_profit_calculator/views/main_screen.dart';
import 'package:mercari_profit_calculator/views/profit_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:mercari_profit_calculator/models/profit_data.dart';
import 'package:mercari_profit_calculator/models/shipping_btn_action.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfitData>(create: (context) => ProfitData()),
        ChangeNotifierProvider<ShippingBtnEventHandler>(
            create: (context) => ShippingBtnEventHandler()),
      ],
      child: MaterialApp(
        initialRoute: MainScreen.pageID,
        routes: {
          MainScreen.pageID: (context) => MainScreen(),
          ProfitScreen.pageID: (context) => ProfitScreen(),
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ProfitData(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: MainScreen.pageID,
//         routes: {
//           MainScreen.pageID: (context) => MainScreen(),
//           ProfitScreen.pageID: (context) => ProfitScreen(),
//         },
//       ),
//     );
//   }
// }
