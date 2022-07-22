import 'package:flutter/material.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth-screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual); can hide top and bottom bars
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black54, systemNavigationBarColor: Colors.yellow)); can modify top and bottom bars
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, value, previous) => ProductsProvider(),
          create: (_) => ProductsProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder()
              }),
              colorScheme: const ColorScheme(
                primary: Colors.purple,
                onPrimary: Colors.white,
                secondary: Colors.orange,
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                surface: Colors.black,
                onSurface: Colors.white,
                background: Colors.black,
                onBackground: Colors.white,
                brightness: Brightness.light,
              )),
          home:
              auth.isAuth ? const ProductsOverviewScreen() : const AuthScreen(),
          routes: {
            ProductsOverviewScreen.route: (ctx) =>
                const ProductsOverviewScreen(),
            ProductDetailsScreen.route: (ctx) => const ProductDetailsScreen(),
            CartScreen.route: (ctx) => const CartScreen(),
            OrdersScreen.route: (ctx) => const OrdersScreen(),
            UserProductsScreen.route: (ctx) => const UserProductsScreen(),
            EditProductScreen.route: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
