import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app_with_api/constant/provider.dart';
import 'package:restaurant_app_with_api/models/get_search_results.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_with_api/widgets/restaurant_card.dart';

class SearchResultsPage extends StatefulWidget {
  final String input;
  const SearchResultsPage({super.key, required this.input});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<GetSearchResults> _dataSearchResults;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<GetSearchResults> _getSearchResults() async {
    final response = await http.get(Uri.parse('$url/search?q=${widget.input}'));
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      return GetSearchResults.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  void initState() {
    super.initState();
    _dataSearchResults = _getSearchResults();
  }

  Future<void> _refresh() {
    return _getSearchResults().then((value) {
      setState(() {
        _dataSearchResults = _getSearchResults();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: widget.input != ""
            ? Text(
                "Search: ${widget.input}",
                style: Theme.of(context).textTheme.titleSmall,
              )
            : Text(
                "Search: All",
                style: Theme.of(context).textTheme.titleSmall,
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
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<GetSearchResults>(
              future: _dataSearchResults,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.restaurants.isNotEmpty) {
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
                          pictureId:
                              snapshot.data!.restaurants[index].pictureId,
                          name: snapshot.data!.restaurants[index].name,
                          city: snapshot.data!.restaurants[index].city,
                          rating: snapshot.data!.restaurants[index].rating,
                        );
                      },
                    );
                  } else {
                    return IntrinsicHeight(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/error.svg",
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                            Text(
                              "Oops,\nSepertinya hasil pencarian ${widget.input} tidak ditemukan",
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return IntrinsicHeight(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            "assets/error.svg",
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                          const Text(
                            "Oops,\nSepertinya terjadi kesalahan, cobalah periksa jaringan anda",
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return IntrinsicHeight(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
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
}
