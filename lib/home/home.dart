import 'package:cardonapp/app/widgets/home_banner.dart';
import 'package:cardonapp/home/widgets/carousel.dart';
import 'package:cardonapp/main.dart';
import 'package:cardonapp/scan/scan.dart';
import 'package:cardonapp/upload_card/add_card.dart';
import 'package:cardonapp/app/widgets/menu_button.dart';
import 'package:cardonapp/user_cards/user_cards.dart';
import 'package:cardonapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/app/providers/card_provider.dart';
import 'package:cardonapp/app/providers/query_provider.dart';

/// Page that users are redirected to when logged in.
///
/// Displays a welcome banner or the user's cards if they exist.
/// Provides navigation to other pages.

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<QueryProvider>().updatePersonalcards(context);
    context.read<QueryProvider>().updateWallet(context);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                stretch: true,
                collapsedHeight: 325.0,
                flexibleSpace: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MyApp.title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCard(),
                              ),
                            ),
                            icon: Icon(
                              Icons.library_add,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        ],
                      ),
                    ),
                    context.watch<CardProvider>().isEmpty(true)
                        ? const HomeBanner(
                            subheading: 'Add a card to get started',
                          )
                        : const Carousel(),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        children: [
                          MenuButton(
                            count: context
                                .read<CardProvider>()
                                .personalcards
                                .length,
                            icon: const Icon(Icons.person),
                            onClicked: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserCards(),
                              ),
                            ),
                            text: 'Your cards',
                          ),
                          MenuButton(
                            count: context
                                .read<CardProvider>()
                                .collectedcards
                                .length,
                            icon: const Icon(Icons.wallet),
                            onClicked: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Wallet(),
                                ),
                              )
                            },
                            text: 'Wallet',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Scan()),
            ),
            child: const Icon(Icons.crop_free_outlined, size: 35),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const BottomAppBar(
            color: Colors.blue,
            shape: CircularNotchedRectangle(),
            notchMargin: 5,
            child: SizedBox(
              height: 50,
            ),
          ),
        ),
      );
}
