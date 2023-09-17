import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app_with_api/constant/provider.dart';
import 'package:restaurant_app_with_api/models/get_detail_data_restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_with_api/widgets/customer_review_card.dart';
import 'package:restaurant_app_with_api/widgets/menus_slider.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<GetDetailRestaurant> _dataDetailRestaurant;

  final TextEditingController _reviewController = TextEditingController();

  Future<GetDetailRestaurant> _getDetailRestaurnt() async {
    debugPrint(widget.id);
    final response = await http.get(Uri.parse('$url/detail/${widget.id}'));

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      return GetDetailRestaurant.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to load details of restaurant";
    }
  }

  Future<void> _postReview(context, id, name, review) async {
    final response = await http.post(Uri.parse('$url/review'), body: {
      'id': id.toString(),
      'name': name.toString(),
      'review': review.toString(),
    });
    debugPrint("HASIL POST REVIEW: ${response.statusCode}");
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review posted'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to post review'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _dataDetailRestaurant = _getDetailRestaurnt();
  }

  Future<void> _refresh() {
    return _getDetailRestaurnt().then((value) {
      setState(() {
        _dataDetailRestaurant = _getDetailRestaurnt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 14, top: 7, bottom: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
            ),
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
                "assets/user.svg",
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FutureBuilder<GetDetailRestaurant>(
            future: _dataDetailRestaurant,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 17.0),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: CachedNetworkImage(
                          imageUrl:
                              '$pictureLarge/${snapshot.data!.restaurant.pictureId}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ...snapshot.data!.restaurant.categories
                                      .map((e) => Text("${e.name} "))
                                      .toList(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data!.restaurant.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Text(snapshot.data!.restaurant.rating
                                          .toString())
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 18,
                                  ),
                                  Text(
                                      "${snapshot.data!.restaurant.address}, ${snapshot.data!.restaurant.city}"),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                snapshot.data!.restaurant.description,
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Menu",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Foods",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    child: Text(
                                      "More..",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17.0),
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...snapshot.data!.restaurant.menus.foods.map(
                                (food) => MenuCard(
                                  menus: food.name,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Drinks",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17.0),
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...snapshot.data!.restaurant.menus.drinks.map(
                                (drink) => MenuCard(
                                  menus: drink.name,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Customer Reviews",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          IntrinsicWidth(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 56 * 2,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      child: TextField(
                                        onSubmitted: (value) {
                                          _postReview(
                                            context,
                                            snapshot.data!.restaurant.id,
                                            "Radja Fajrul",
                                            _reviewController.text,
                                          ).then(
                                            (value) =>
                                                _getDetailRestaurnt().then(
                                              (value) {
                                                setState(() {
                                                  _dataDetailRestaurant =
                                                      _getDetailRestaurnt();
                                                });
                                              },
                                            ),
                                          );
                                        },
                                        maxLines: 3,
                                        textInputAction: TextInputAction.send,
                                        controller: _reviewController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Write your review',
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.send_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        onPressed: () {
                                          _postReview(
                                            context,
                                            snapshot.data!.restaurant.id,
                                            "Radja Fajrul",
                                            _reviewController.text,
                                          ).then(
                                            (value) =>
                                                _getDetailRestaurnt().then(
                                              (value) {
                                                setState(() {
                                                  _dataDetailRestaurant =
                                                      _getDetailRestaurnt();
                                                });
                                                _reviewController.clear();
                                              },
                                            ),
                                          );
                                        },
                                      )),
                                ]),
                          ),
                          if (snapshot
                              .data!.restaurant.customerReviews.isNotEmpty)
                            const SizedBox(height: 12),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  maxHeight: double.infinity, minHeight: 56.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    CustomerReviewCard(
                                  name: snapshot.data!.restaurant
                                      .customerReviews[index].name,
                                  review: snapshot.data!.restaurant
                                      .customerReviews[index].review,
                                  date: snapshot.data!.restaurant
                                      .customerReviews[index].date,
                                ),
                                itemCount: snapshot
                                    .data!.restaurant.customerReviews.length,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              } else if (snapshot.hasError) {
                return IntrinsicHeight(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/error.svg",
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Opps, Sepertinya terjadi kesalahan, cobalah periksa jaringan anda",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return IntrinsicHeight(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
