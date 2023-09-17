import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app_with_api/constant/provider.dart';
import 'package:restaurant_app_with_api/models/get_all_data_restaurant.dart';
import 'package:restaurant_app_with_api/pages/search_results_page.dart';
import 'package:restaurant_app_with_api/widgets/img_slider.dart';
import 'package:restaurant_app_with_api/widgets/restaurant_card.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<GetAllRestaurant> _dataRestaurant;
  final TextEditingController _searchController = TextEditingController();
  final List<bool> _selected = <bool>[true, false];

  Future<GetAllRestaurant> _getListRestaurant() async {
    final response = await http.get(Uri.parse('$url/list'));
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      return GetAllRestaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load list of restaurant');
    }
  }

  Future<void> _refresh() {
    return _getListRestaurant().then((value) {
      setState(() {
        _dataRestaurant = _getListRestaurant();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _dataRestaurant = _getListRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: SvgPicture.asset('assets/menu.svg'),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Container(
            width: 42,
            height: 42,
            margin: const EdgeInsets.only(right: 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SvgPicture.asset(
                'assets/user.svg',
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .color!
                              .withOpacity(0.5),
                        ),
                  ),
                  Text(
                    "Radja Fajrul Ghufron",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: TextField(
                              onSubmitted: (value) {
                                setState(
                                  () {
                                    _searchController.text = value;
                                  },
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResultsPage(
                                      input: _searchController.text,
                                    ),
                                  ),
                                ).then((value) => _searchController.clear());
                              },
                              controller: _searchController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: 'Find your ideal restaurant',
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/search.svg',
                                    width: 19.5,
                                    height: 19.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _displayBottomSheet(context);
                            },
                            icon: SvgPicture.asset('assets/settings.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 3.0,
                enlargeCenterPage: true,
                clipBehavior: Clip.antiAlias,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            FutureBuilder<GetAllRestaurant>(
              future: _dataRestaurant,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.data!.restaurants.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return RestaurantCard(
                        id: snapshot.data!.restaurants[index].id,
                        pictureId: snapshot.data!.restaurants[index].pictureId,
                        name: snapshot.data!.restaurants[index].name,
                        city: snapshot.data!.restaurants[index].city,
                        rating: snapshot.data!.restaurants[index].rating,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return IntrinsicHeight(
                    child: Container(
                      height: 320,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            "assets/error.svg",
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          const Text(
                            "Oops, Sepertinya terjadi kesalahan, cobalah periksa jaringan anda",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return IntrinsicHeight(
                    child: Container(
                      height: 320,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 0,
      builder: (BuildContext context) => Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              height: 10,
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search Settings",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Search By"),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      child: ToggleButtons(
                        selectedColor: Colors.white,
                        fillColor: Theme.of(context).colorScheme.primary,
                        color: Colors.grey[400],
                        isSelected: _selected,
                        onPressed: (int index) {
                          setState(() {
                            _selected[index] = !_selected[index];
                          });
                        },
                        children: const [
                          Icon(Icons.abc),
                          Icon(Icons.location_on_rounded),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
