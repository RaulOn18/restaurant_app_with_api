import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_with_api/constant/provider.dart';
import 'package:restaurant_app_with_api/pages/detail_page.dart';

class RestaurantCard extends StatefulWidget {
  final String id;
  final String pictureId;
  final String name;
  final String city;
  final double rating;

  const RestaurantCard({
    super.key,
    required this.id,
    required this.pictureId,
    required this.name,
    required this.city,
    required this.rating,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DetailPage(id: widget.id),
          ),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          height: 110,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IntrinsicHeight(
              child: Container(
                width: 120,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    key: Key(widget.id),
                    imageUrl: '$pictureSmall/${widget.pictureId}',
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 171,
                        width: 171,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      );
                    },
                    placeholder: (context, url) => Container(
                      height: 171,
                      width: 171,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 171,
                        width: 171,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.48,
                        child: Text(
                          widget.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                          ),
                          IntrinsicWidth(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Text(
                                widget.city,
                                style: Theme.of(context).textTheme.titleSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ])
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.amber,
                    ),
                    Text(
                      widget.rating.toString(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
