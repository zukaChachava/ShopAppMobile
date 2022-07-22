import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: queryData.size.height * 0.1,
            horizontal: queryData.size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(OrdersScreen.route);
                    Scaffold.of(context).closeDrawer();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Orders',
                      style: TextStyle(fontSize: 20, color: Colors.purple),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(UserProductsScreen.route);
                    Scaffold.of(context).closeDrawer();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Manage Products',
                      style: TextStyle(fontSize: 20, color: Colors.purple),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: TextButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Exit',
                      style: TextStyle(fontSize: 20, color: Colors.purple),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
