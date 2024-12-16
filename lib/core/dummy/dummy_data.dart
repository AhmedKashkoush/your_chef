import 'dart:math';

import 'package:your_chef/features/categories/data/models/category_model.dart';
import 'package:your_chef/features/offers/data/models/offer_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/restaurants/data/models/restaurant_model.dart';

class AppDummies {
  const AppDummies._();

  static final List<CategoryModel> categories = List.from(_categories)
      .cast<String>()
      .map(
        (category) => CategoryModel(
          id: _categories.indexOf(category),
          name: category,
          image: '$_base/categories/${category.toLowerCase()}.png',
        ),
      )
      .toList();

  static final List<FoodModel> foods = List.generate(
    20,
    (i) {
      final int index = Random().nextInt(_foods.length);
      return FoodModel(
        id: i,
        category: categories[Random().nextInt(categories.length)],
        restaurant: restaurants[max(Random().nextInt(restaurants.length),
            1)], // Random().nextInt(1000),
        name: 'Name of food ' * max(Random().nextInt(2), 1),
        description: 'some long and meaningful description ' *
            max(Random().nextInt(20), 1),
        images: List.generate(
          max(Random().nextInt(8), 1),
          (_) => _foods[index],
        ),
        trending: Random().nextBool(),
        rate: double.parse(
          max(Random().nextDouble() * 5, 0.1).toStringAsFixed(1),
        ),
        price: double.parse(
          (Random().nextDouble() * 150).toStringAsFixed(1),
        ),
        sale: double.parse(
          (Random().nextDouble().round() * 0.9).toStringAsFixed(1),
        ),
      );
    },
  );

  static List<FoodModel> foodsWishlist = [
    // ...foods,
    // ...foods,
    // ...foods,
  ];

  static final List<OfferModel> offers = List.from(_offers)
      .cast<String>()
      .map(
        (offer) => OfferModel(
          id: _offers.indexOf(offer),
          restaurant: restaurants[Random().nextInt(restaurants.length)],
          image: offer,
        ),
      )
      .toList();

  static final List<RestaurantModel> restaurants = List.generate(
    20,
    (i) {
      final int index = Random().nextInt(_restaurants.length);

      return RestaurantModel(
        id: i,
        latitude: 30.033333,
        longitude: 31.233334,
        name: 'Name of restaurant ' * max(Random().nextInt(2), 1),
        phone: '+20${Random().nextInt(1000000000).toString().padLeft(10, '0')}',
        description: 'some long and meaningful description ' *
            max(Random().nextInt(20), 1),
        address:
            'some long and meaningful address ' * max(Random().nextInt(20), 1),
        profileImage: _restaurants[index],
        images: List.generate(
            max(Random().nextInt(6), 1), (_) => _restaurants[index]),
        rate: double.parse(
          (max(Random().nextDouble() * 5, 0.1)).toStringAsFixed(1),
        ),
      );
    },
  );

  static const String _base = 'assets/images/dummy';
  static const List<String> _categories = [
    'Burgers',
    'Chicken',
    'Crepes',
    'Dessert',
    'Pizza',
    'Salad',
  ];

  static const List<String> _foods = [
    'https://img.freepik.com/free-photo/grilled-gourmet-burger-with-cheese-tomato-onion-french-fries-generated-by-artificial-intelligence_25030-63181.jpg',
    'https://www.allrecipes.com/thmb/fFW1o307WSqFFYQ3-QXYVpnFj6E=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/48727-Mikes-homemade-pizza-DDMFS-beauty-4x3-BG-2974-a7a9842c14e34ca699f3b7d7143256cf.jpg',
    'https://images.deliveryhero.io/image/talabat/Menuitems/crepe_chicken_pane637922035757654335.jpg',
    'https://lakegenevacountrymeats.com/wp-content/uploads/Fried-Chicken-Pieces.jpg',
  ];

  static const List<String> _offers = [
    'https://img.pikbest.com/templates/20240602/food-burger-offer-sale-restaurant-web-banner-design_10587343.jpg!sw800',
    'https://f.nooncdn.com/food/cms-780x780/en_mb-noon-food-rect2-banner-03-260x175-1%20(2).1706084496.3925154.png',
    'https://img.freepik.com/premium-psd/banner-food-menu-restaurant-template-food-menu-restaurant-fried-chicken_609989-568.jpg'
  ];

  static const List<String> _restaurants = [
    'https://static.vecteezy.com/system/resources/thumbnails/009/900/509/small/pizza-cafe-logo-pizza-icon-illustration-graphic-emblem-pizza-of-perfect-for-fast-food-restaurant-simple-flat-style-pizza-logo-vector.jpg',
    'https://www.shutterstock.com/image-vector/indian-restaurant-royal-luxury-logo-600nw-2335561381.jpg',
    'https://www.shutterstock.com/image-vector/doner-kebab-logo-restaurants-markets-260nw-2506818861.jpg',
    'https://i.pinimg.com/564x/11/ee/74/11ee741936b01c500b859222678ad2e3.jpg',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/arabs-broasted-chicken-logo-design-template-53ca8b282c84450745addb333c0017d1_screen.jpg?ts=1641833313',
  ];
}
