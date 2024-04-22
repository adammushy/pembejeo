import 'package:flutter/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBars {
  final BuildContext ctx;
  SnackBars({required this.ctx});

  infoSnackBar(String message) {
    return showTopSnackBar(
      Overlay.of(ctx),
      CustomSnackBar.info(
        message: message,
      ),
    );
  }

  successSnackBar(String message) {
    return showTopSnackBar(
      Overlay.of(ctx),
      CustomSnackBar.success(
        message: message,
      ),
    );
  }

  errorSnackBar(String message) {
    return showTopSnackBar(
      Overlay.of(ctx),
      CustomSnackBar.error(
        message: message,
      ),
    );
  }
}
