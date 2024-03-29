import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class AppProductItem extends StatelessWidget {
  const AppProductItem(
      {Key? key,
      this.item,
      this.onPressed,
      required this.type,
      this.trailing,
      this.isShadow})
      : super(key: key);

  final ProductModel? item;
  final ProductViewType type;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      ///Mode View Small
      case ProductViewType.small:
        if (item == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 180,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item!.priceDisplay,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )
            ],
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item!.image.thumb,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      width: 84,
                      height: 84,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item!.title,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item?.category?.title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppTag(
                          "${item!.rate}",
                          type: TagType.rate,
                        ),
                        const SizedBox(width: 4),
                        RatingBar.builder(
                          initialRating: item!.rate,
                          minRating: 1,
                          allowHalfRating: true,
                          unratedColor: Colors.amber.withAlpha(100),
                          itemCount: 5,
                          itemSize: 12.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rate) {},
                          ignoreGestures: true,
                        ),
                      ],
                    ),
                    price ?? Container(),
                  ],
                ),
              ),
              trailing ?? Container()
            ],
          ),
        );

      ///Mode View Gird
      case ProductViewType.grid:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 24,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Text(
            item!.priceDisplay,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.end,
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item!.image.thumb,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            item!.status.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: AppTag(
                                      item!.status,
                                      type: TagType.status,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                item!.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                item?.category?.title ?? '',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                item!.title,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AppTag(
                    "${item!.rate}",
                    type: TagType.rate,
                  ),
                  const SizedBox(width: 4),
                  RatingBar.builder(
                    initialRating: item!.rate,
                    minRating: 1,
                    allowHalfRating: true,
                    unratedColor: Colors.amber.withAlpha(100),
                    itemCount: 5,
                    itemSize: 12.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rate) {},
                    ignoreGestures: true,
                  ),
                  Expanded(
                    child: price ?? Container(),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item!.address,
                maxLines: 1,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        );

      ///Mode View List
      case ProductViewType.list:
        if (item == null) {
          return AppPlaceholder(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 140,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 20,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                item!.priceDisplay,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )
            ],
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Stack(
            children: [
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: item!.image.thumb,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 120,
                        height: 140,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            item!.status.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: AppTag(
                                      item!.status,
                                      type: TagType.status,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return AppPlaceholder(
                        child: Container(
                          width: 120,
                          height: 140,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return AppPlaceholder(
                        child: Container(
                          width: 120,
                          height: 140,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item?.category?.title ?? '',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item!.title,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AppTag(
                              "${item!.rate}",
                              type: TagType.rate,
                            ),
                            const SizedBox(width: 4),
                            RatingBar.builder(
                              initialRating: item!.rate,
                              minRating: 1,
                              allowHalfRating: true,
                              unratedColor: Colors.amber.withAlpha(100),
                              itemCount: 5,
                              itemSize: 12.0,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rate) {},
                              ignoreGestures: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item!.address,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Row(
                        //   children: <Widget>[
                        //     Icon(
                        //       Icons.phone_outlined,
                        //       size: 12,
                        //       color: Theme.of(context).primaryColor,
                        //     ),
                        //     const SizedBox(width: 4),
                        //     Expanded(
                        //       child: Text(item!.phone,
                        //           maxLines: 1,
                        //           style: Theme.of(context).textTheme.caption),
                        //     )
                        //   ],
                        // ),

                        price ?? Container(),
                      ],
                    ),
                  )
                ],
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: Icon(
              //     item!.favorite ? Icons.favorite : Icons.favorite_border,
              //     color: Theme.of(context).primaryColor,
              //   ),
              // )
            ],
          ),
        );

      ///Mode View Block
      case ProductViewType.block:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                item!.priceDisplay,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )
            ],
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item!.image.thumb,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              item!.status.isNotEmpty
                                  ? AppTag(
                                      item!.status,
                                      type: TagType.status,
                                    )
                                  : Container(),
                              Icon(
                                item!.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      AppTag(
                                        "${item!.rate}",
                                        type: TagType.rate,
                                      ),
                                      const SizedBox(width: 4),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Text(
                                              Translate.of(context).translate(
                                                'rate',
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          RatingBar.builder(
                                            initialRating: item!.rate,
                                            minRating: 1,
                                            allowHalfRating: true,
                                            unratedColor:
                                                Colors.amber.withAlpha(100),
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rate) {},
                                            ignoreGestures: true,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item!.numRate} ${Translate.of(context).translate('feedback')}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      height: 200,
                      color: Colors.white,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      height: 200,
                      color: Colors.white,
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                item?.category?.title ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item!.title,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        price ?? Container(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item!.address,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone_outlined,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item!.phone,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );

      ///Case View Card small
      case ProductViewType.card:
        if (item == null) {
          return SizedBox(
            width: 110,
            child: AppPlaceholder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        }
        return SizedBox(
          width: 110,
          child: GestureDetector(
            onTap: onPressed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item!.image.thumb,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return AppPlaceholder(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return AppPlaceholder(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    item!.title,
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
      case ProductViewType.large:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 24,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Text(
            item!.priceDisplay,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.end,
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: item!.image.thumb,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 187,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                item!.status.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: AppTag(
                                          item!.status,
                                          type: TagType.status,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            //     Padding(
                            //       padding: const EdgeInsets.all(4),
                            //       child: Icon(
                            //         item!.favorite
                            //             ? Icons.favorite
                            //             : Icons.favorite_border,
                            //         color: Colors.white,
                            //       ),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return AppPlaceholder(
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return AppPlaceholder(
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      height: 20,
                      // width: 70,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.5)),
                      alignment: Alignment.center,
                      child: Text(
                        item?.category?.title ?? '',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              // const SizedBox(height: 8),
              Container(
                height: 120,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(
                          3.0, // Move to right 7.0 horizontally
                          5.0, // Move to bottom 8.0 Vertically
                        ))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            item!.title,
                            maxLines: 2,
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                          ),
                        ),
                        Spacer(),
                        RatingBar.builder(
                          initialRating: item!.rate,
                          minRating: 1,
                          allowHalfRating: true,
                          unratedColor: Colors.amber.withAlpha(100),
                          itemCount: 5,
                          itemSize: 20.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            // size: 30,
                          ),
                          onRatingUpdate: (rate) {},
                          ignoreGestures: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item!.category?.title ?? '',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(height: 4),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     AppTag(
                    //       "${item!.rate}",
                    //       type: TagType.rate,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Expanded(
                    //       child: price ?? Container(),
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            item!.address,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF356DB4),
                          ),
                          alignment: Alignment.center,
                          child: Transform.rotate(
                              angle: 0.6,
                              child: Icon(
                                Icons.navigation_rounded,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      case ProductViewType.gridCard:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 24,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Text(
            item!.priceDisplay,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.end,
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Container(
            height: 120,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              boxShadow: (isShadow ?? false)
                  ? const [
                      BoxShadow(
                        color: Color.fromARGB(174, 188, 255, 190),
                        blurRadius: 20.0, // soften the shadow
                        // spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          2.0, // Move to right 5  horizontally
                          5.0, // Move to bottom 5 Vertically
                        ),
                      )
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: item!.image.thumb,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              item!.status.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: AppTag(
                                        item!.status,
                                        type: TagType.status,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return AppPlaceholder(
                      child: Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return AppPlaceholder(
                      child: Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.error),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  item!.title,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  item!.address,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        );

      default:
        return Container(width: 160.0);
    }
  }
}
