import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/screens/gallery/gallery.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.item}) : super(key: key);

  final ProductModel item;

  @override
  _ProductDetailState createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetail> {
  final _scrollController = ScrollController();
  final _productDetailCubit = ProductDetailCubit();
  late StreamSubscription _reviewSubscription;

  Color? _iconColor = Colors.white;
  bool _showCategoryLocation = true;
  bool _showHour = true;
  bool _showFile = true;
  bool _showSocial = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _productDetailCubit.onLoad(widget.item.id);
    _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
      if (state is ReviewSuccess &&
          state.id != null &&
          state.id == widget.item.id) {
        _productDetailCubit.onLoad(widget.item.id);
      }
    });
  }

  @override
  void dispose() {
    _reviewSubscription.cancel();
    _productDetailCubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  ///Handle icon theme
  void _onScroll() {
    Color? color;
    if (_scrollController.position.extentBefore < 110) {
      color = Colors.white;
    }
    if (color != _iconColor) {
      setState(() {
        _iconColor = color;
      });
    }
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  ///On Preview Profile
  void _onProfile(UserModel user) {
    Navigator.pushNamed(context, Routes.profile, arguments: user);
  }

  ///On navigate map
  void _onLocation(ProductModel item) {
    Navigator.pushNamed(
      context,
      Routes.gpsPicker,
      arguments: item.location,
    );
  }

  ///On show message fail
  void _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('explore_product'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }

  void _onCopy(ProductModel item) {
    Clipboard.setData(
      ClipboardData(text: item.link),
    );
    AppBloc.messageCubit.onShow('listing_link_copied');
  }

  ///On Scan QR
  void _onShare(ProductModel item) async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final id = '${item.id}';
        final link = 'listar://qrcode?type=listing&action=view&id=$id';
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: item.image.thumb,
                              placeholder: (context, url) {
                                return AppPlaceholder(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              },
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return AppPlaceholder(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Translate.of(context).translate(
                                    'share_qr_listing',
                                  ),
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  AppButton(
                                    Translate.of(context).translate('share'),
                                    mainAxisSize: MainAxisSize.max,
                                    size: ButtonSize.small,
                                    type: ButtonType.outline,
                                    onPressed: () {
                                      Navigator.pop(context, "share");
                                    },
                                  ),
                                  AppButton(
                                    Translate.of(context).translate('copy'),
                                    mainAxisSize: MainAxisSize.max,
                                    size: ButtonSize.small,
                                    onPressed: () {
                                      Navigator.pop(context, "copy");
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 150,
                              child: QrImage(
                                data: link,
                                size: 150,
                                backgroundColor: Colors.white,
                                errorStateBuilder: (cxt, err) {
                                  return const Text(
                                    "Uh oh! Something went wrong...",
                                    textAlign: TextAlign.center,
                                  );
                                },
                                padding: EdgeInsets.zero,
                                embeddedImage: NetworkImage(item.image.thumb),
                                embeddedImageStyle: QrEmbeddedImageStyle(
                                  size: const Size(24, 24),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (result == 'share') {
      Share.share(
        'Check out my item ${item.link}',
        subject: 'PassionUI',
      );
    } else if (result == 'copy') {
      _onCopy(item);
    }
  }

  ///On navigate gallery
  void _onPhotoPreview(ProductModel item, {int index = 0}) {
    Navigator.push(context,
        // Routes.gallery,
        // arguments: item,
        MaterialPageRoute(
      builder: (context) {
        return Gallery(
          product: item,
          currentIndex: index,
        );
      },
    ));
  }

  ///On navigate review
  void _onReview(ProductModel product) async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) return;
    }
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      Routes.review,
      arguments: product,
    );
  }

  ///On like product
  void _onFavorite() async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) return;
    }
    _productDetailCubit.onFavorite();
  }

  ///On Booking
  void _onBooking() async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) return;
    }
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      Routes.booking,
      arguments: widget.item.id,
    );
  }

  ///Phone action
  void _phoneAction(String phone) async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Column(
                      children: [
                        AppListTitle(
                          title: 'WhatsApp',
                          leading: SizedBox(
                            height: 32,
                            width: 32,
                            child: Image.asset(Images.whatsapp),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "WhatsApp");
                          },
                        ),
                        AppListTitle(
                          title: 'Viber',
                          leading: SizedBox(
                            height: 32,
                            width: 32,
                            child: Image.asset(Images.viber),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "Viber");
                          },
                        ),
                        AppListTitle(
                          title: 'Telegram',
                          leading: SizedBox(
                            height: 32,
                            width: 32,
                            child: Image.asset(Images.telegram),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "Telegram");
                          },
                          border: false,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      String url = '';

      switch (result) {
        case "WhatsApp":
          if (Platform.isAndroid) {
            url = "whatsapp://wa.me/$phone";
          } else {
            url = "whatsapp://api.whatsapp.com/send?phone=$phone";
          }
          break;
        case "Viber":
          url = "viber://contact?number=$phone";
          break;
        case "Telegram":
          url = "tg://msg?to=$phone";
          break;
        default:
          break;
      }

      _makeAction(url);
    }
  }

  ///Make action
  void _makeAction(String url) async {
    try {
      launchUrl(Uri.parse(url));
    } catch (e) {
      _showMessage(Translate.of(context).translate('cannot_make_action'));
    }
  }

  ///Build social image
  String _exportSocial(String type) {
    switch (type) {
      case "telegram":
        return Images.telegram;
      case "twitter":
        return Images.twitter;
      case "flickr":
        return Images.flickr;
      case "google_plus":
        return Images.google;
      case "tumblr":
        return Images.tumblr;
      case "linkedin":
        return Images.linkedin;
      case "pinterest":
        return Images.pinterest;
      case "youtube":
        return Images.youtube;
      case "instagram":
        return Images.instagram;
      default:
        return Images.facebook;
    }
  }

  ///Build content UI
  Widget _buildContent(ProductModel? product) {
    ///Build UI loading
    List<Widget> action = [];
    Widget actionGalleries = Container();
    Widget actionMapView = Container();
    Widget banner = AppPlaceholder(
      child: Container(
        color: Colors.white,
      ),
    );
    Widget imagePreview = Container();
    Widget propertyPicture = Container();
    Widget address = Container();
    Widget phone = Container();
    Widget fax = Container();
    Widget email = Container();
    Widget website = Container();
    Widget openHours = Container();
    Widget attachments = Container();
    Widget socials = Container();
    Widget info = AppPlaceholder(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 16,
              width: 150,
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 16,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 20,
                      width: 150,
                      color: Colors.white,
                    ),
                  ],
                ),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
          ],
        ),
      ),
    );
    Widget status = Container();
    Widget tags = Container();
    Widget latest = Container();
    Widget feature = AppPlaceholder(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
          ],
        ),
      ),
    );
    Widget related = feature;
    Widget dateEstablish = Container();
    Widget priceRange = Container();
    Widget price = Container();
    Widget booking = Container();
    Color? backgroundAction;
    int currentIndex = 0;

    /// Build Detail
    if (product != null) {
      // List<ImageModel> images = product.galleries;
      // images.insert(0, product.image);
      // images = images.toSet().toList();

      ///background action

      if (_iconColor == Colors.white) {
        backgroundAction = Colors.grey.withOpacity(0.3);
      }

      ///Action Galleries
      if (product.galleries.isNotEmpty) {
        actionGalleries = Row(
          children: [
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundAction,
              ),
              child: IconButton(
                icon: const Icon(Icons.photo_library_outlined),
                onPressed: () {
                  _onPhotoPreview(product);
                },
              ),
            ),
          ],
        );
        imagePreview = Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFFF5F5F5),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: product.galleries.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _productDetailCubit.changeCurrentIndex(index);
                },
                child: Container(
                  height: 90,
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          product.galleries[index].full),
                    ),
                  ),
                ),
              );
            },
          ),
        );
        propertyPicture = ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Translate.of(context).translate('Property Pictures'),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // ListView(
            // scrollDirection: Axis.vertical,
            // physics: NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            // children: [
            for (int i = 0; i < product.galleries.length; i = i + 2)
              Container(
                height: 187,
                margin: EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width / 1.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          _onPhotoPreview(product, index: i);
                        },
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: 175,
                          imageUrl: product.galleries[i].full,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),

                    product.galleries.length - 1 >= i + 1
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () {
                                _onPhotoPreview(product, index: i + 1);
                              },
                              child: CachedNetworkImage(
                                // width: MediaQuery.of(context).size.width /
                                //     3.2,
                                width: MediaQuery.of(context).size.width / 2.2,
                                // height: 170 / 2,
                                height: 175,
                                imageUrl: product.galleries[i + 1].full,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // product.galleries.length - 1 >= i + 2
                    //     ? ClipRRect(
                    //         borderRadius: BorderRadius.circular(8),
                    //         child: CachedNetworkImage(
                    //             width:
                    //                 MediaQuery.of(context).size.width /
                    //                     3.2,
                    //             height: 170 / 2,
                    //             fit: BoxFit.fill,
                    //             imageUrl:
                    //                 product.galleries[i + 2].full),
                    //       )
                    //     : SizedBox.shrink()
                  ],
                ),
              )
          ],
          //   )
          // ],
        );
      }

      ///Action Map View
      if (product.location != null) {
        actionMapView = Row(
          children: [
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundAction,
              ),
              child: IconButton(
                icon: const Icon(Icons.map_outlined),
                onPressed: () {
                  _onLocation(product);
                },
              ),
            ),
          ],
        );
      }

      ///Status
      if (product.status.isNotEmpty) {
        status = AppTag(
          product.status,
          type: TagType.status,
        );
      }

      ///Latest
      if (product.latest.isNotEmpty) {
        latest = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Translate.of(context).translate('latest'),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final ProductModel item = product.latest[index];
                  return Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppProductItem(
                      onPressed: () {
                        _onProductDetail(item);
                      },
                      item: item,
                      isShadow: true,
                      type: ProductViewType.gridCard,
                    ),
                  );
                },
                itemCount: product.latest.length,
              ),
            )
          ],
        );
      }

      ///Related list
      if (product.related.isNotEmpty) {
        related = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Translate.of(context).translate('related'),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final item = product.related[index];
                  return AppProductItem(
                    onPressed: () {
                      _onProductDetail(item);
                    },
                    item: item,
                    type: ProductViewType.large,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                itemCount: product.related.length,
              ),
            ],
          ),
        );
      }

      ///Action
      action = [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundAction,
          ),
          child: IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              _onShare(product);
            },
          ),
        ),
        actionMapView,
        actionGalleries,
        const SizedBox(width: 8),
      ];
      banner = Swiper(
        itemCount: product.galleries.length,
        index: _productDetailCubit.currentIndex,
        onIndexChanged: (value) {
          _productDetailCubit.changeCurrentIndex(value);
        },
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _onPhotoPreview(product, index: _productDetailCubit.currentIndex);
            },
            child: CachedNetworkImage(
              // imageUrl: product.image.full,
              imageUrl:
                  product.galleries[_productDetailCubit.currentIndex].full,

              placeholder: (context, url) {
                return AppPlaceholder(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return AppPlaceholder(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.error),
                  ),
                );
              },
            ),
          );
        },
      );

      ///Banner

      ///Video
      if (product.videoURL.isNotEmpty) {
        banner = Stack(
          children: [
            banner,
            Positioned.fill(child: AppVideo(url: product.videoURL)),
          ],
        );
      }

      ///Address
      if (product.address.isNotEmpty) {
        address =
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     const SizedBox(height: 16),
            Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  _makeAction(
                    'https://www.google.com/maps/search/?api=1&query=${product.location!.latitude},${product.location!.longitude}',
                  );
                },
                child: Row(
                  children: [
                    // Container(
                    //   width: 32,
                    //   height: 32,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Theme.of(context).dividerColor,
                    //   ),
                    //   child: const Icon(
                    //     Icons.location_on_outlined,
                    //     color: Colors.white,
                    //     size: 18,
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text(
                          //   Translate.of(context).translate('address'),
                          //   style: Theme.of(context).textTheme.caption,
                          // ),
                          Text(
                            product.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.35)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _makeAction(
                  'https://www.google.com/maps/search/?api=1&query=${product.location!.latitude},${product.location!.longitude}',
                );
              },
              child: Container(
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
              ),
            )
            // InkWell(
            //   onTap: () {
            //     setState(() {
            //       _showCategoryLocation = !_showCategoryLocation;
            //     });
            //   },
            //   child: Icon(
            //     _showCategoryLocation
            //         ? Icons.keyboard_arrow_up
            //         : Icons.keyboard_arrow_down,
            //   ),
            // )
          ],
        );
        // Visibility(
        //   visible: _showCategoryLocation,
        //   child: Container(
        //     margin: const EdgeInsets.only(left: 42),
        //     padding: const EdgeInsets.only(top: 12),
        //     child: Text(
        //       '${product.country?.title}, ${product.city?.title}, ${product.state?.title}',
        //       style: Theme.of(context).textTheme.caption,
        //     ),
        //   ),
        // );
        //   ],
        // );
      }

      ///Phone
      if (product.phone.isNotEmpty) {
        phone = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _phoneAction(product.phone);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('phone'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Fax
      if (product.fax.isNotEmpty) {
        fax = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction('tel:${product.fax}');
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.perm_phone_msg_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('fax'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.fax,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Email
      if (product.email.isNotEmpty) {
        email = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction('mailto:${product.email}');
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('email'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Website
      if (product.website.isNotEmpty) {
        website = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction(product.website);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.language_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('website'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.website,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Open hours
      if (product.openHours.isNotEmpty) {
        openHours = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _showHour = !_showHour;
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).dividerColor,
                          ),
                          child: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Translate.of(context).translate('open_time'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showHour
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  )
                ],
              ),
            ),
            Visibility(
              visible: _showHour,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.openHours.map((item) {
                  final hour = item.schedule
                      .map((e) {
                        return '${e.start.viewTime}-${e.end.viewTime}';
                      })
                      .toList()
                      .join(",");
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 42),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate(item.key),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hour,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }

      ///File attachments
      if (product.attachments.isNotEmpty) {
        attachments = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _showFile = !_showFile;
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).dividerColor,
                          ),
                          child: const Icon(
                            Icons.file_copy_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Translate.of(context).translate('attachments'),
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              '${product.attachments.length} ${Translate.of(context).translate('files')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showFile
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  )
                ],
              ),
            ),
            Visibility(
              visible: _showFile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.attachments.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(left: 42),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${item.name}.${item.type}',
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Text(
                              item.size,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            AppDownloadFile(file: item),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }

      ///Date established
      if (product.dateEstablish.isNotEmpty) {
        dateEstablish = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Translate.of(context).translate(
                'date_established',
              ),
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(height: 4),
            Text(
              product.dateEstablish,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            )
          ],
        );
      }

      ///Price range
      if (product.priceMin.isNotEmpty || product.priceMax.isNotEmpty) {
        priceRange = Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              Translate.of(context).translate('price_range'),
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(height: 4),
            Text(
              "${product.priceMin} - ${product.priceMax}",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            )
          ],
        );
      }

      ///Price
      if (product.priceDisplay.isNotEmpty) {
        price = Row(
          children: [
            Text(
              product.priceDisplay,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(width: 8)
          ],
        );
      }

      ///Booking button
      if (product.bookingUse) {
        booking = InkWell(
          onTap: _onBooking,
          child: Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            child: Text(
              Translate.of(context).translate('book_now'),
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        );
      }

      ///Feature
      if (product.features.isNotEmpty) {
        feature = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate('Amenities'),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.features.map((item) {
                return IntrinsicWidth(
                  child: AppTag(
                    item.title,
                    type: TagType.chip,
                    icon: Icon(
                      item.icon,
                      size: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }

      ///Tags
      if (product.tags.isNotEmpty) {
        tags = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate('tags'),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.tags.map((item) {
                return IntrinsicWidth(
                  child: AppTag(
                    item.title,
                    type: TagType.chip,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }

      ///socials
      if (product.socials.isNotEmpty) {
        socials = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _showSocial = !_showSocial;
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).dividerColor,
                          ),
                          child: const Icon(
                            Icons.link,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Translate.of(context).translate('social_network'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showSocial
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  )
                ],
              ),
            ),
            Visibility(
              visible: _showSocial,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.socials.entries.map((entry) {
                    return InkWell(
                      onTap: () {
                        _makeAction(entry.value ?? '');
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              _exportSocial(entry.key),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      }

      ///Info
      info = Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                price,
                InkWell(
                  onTap: () {
                    _onReview(product);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // AppTag(
                      //   "${product.rate}",
                      //   type: TagType.rate,
                      // ),
                      // const SizedBox(width: 4),
                      RatingBar.builder(
                        initialRating: product.rate,
                        unratedColor: Colors.amber.withAlpha(100),
                        itemCount: 5,
                        itemSize: 20.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rate) {},
                        ignoreGestures: true,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${product.numRate})",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                )

                // booking,
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.category?.title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
                // IconButton(
                //   icon: Icon(
                //     product.favorite ? Icons.favorite : Icons.favorite_border,
                //     color: Theme.of(context).primaryColor,
                //   ),
                //   onPressed: _onFavorite,
                // ),
              ],
            ),
            // Row(
            //   children: [
            address,
            //   ],
            // ),
            // phone,
            // fax,
            email,
            website,
            openHours,
            attachments,
            socials,
            const SizedBox(height: 16),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    height: 1.3,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dateEstablish,
                priceRange,
              ],
            ),
            feature,
            tags,
          ],
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.25,
          pinned: true,
          actions: action,
          iconTheme: Theme.of(context).iconTheme.copyWith(color: _iconColor),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: banner,
          ),
        ),
        SliverToBoxAdapter(
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    imagePreview,
                    const SizedBox(height: 16),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       AppUserInfo(
                    //         user: product?.author,
                    //         type: UserViewType.basic,
                    //         onPressed: () {
                    //           _onProfile(product!.author!);
                    //         },
                    //       ),
                    //       status
                    //     ],
                    //   ),
                    // ),
                    info,
                    propertyPicture,
                    latest,
                    const SizedBox(height: 16),
                    related,
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _productDetailCubit,
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            ProductModel? product;
            if (state is ProductDetailSuccess) {
              product = state.product;
            }
            return _buildContent(product);
          },
        ),
      ),
    );
  }
}
