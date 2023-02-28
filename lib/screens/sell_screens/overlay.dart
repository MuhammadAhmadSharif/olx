import 'package:flutter/material.dart';

void _showOverlay(BuildContext context, {required String text}) async {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: Container(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ));
  overlayState!.insert(overlayEntry);
  await Future.delayed(Duration(seconds: 2));
  overlayEntry.remove();
}
