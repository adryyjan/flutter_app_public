import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/local_data.dart';
import '../class/ofert_data.dart';

final selectedLokalProvider = StateProvider<Lokal?>((ref) => null);

final selectedOfertaProvider = StateProvider<Oferta?>((ref) => null);
