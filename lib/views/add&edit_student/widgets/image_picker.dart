import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/image_provider.dart';

class ImagePickerWidge extends StatelessWidget {
  const ImagePickerWidge({super.key, required this.ctx});

 final BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        width: 200,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Provider.of<ImageProvder>(context, listen: false)
                    .getImage(ImageSource.camera);
                Navigator.pop(ctx);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt_sharp),
                  Text(
                    'Camera',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Provider.of<ImageProvder>(context, listen: false)
                    .getImage(ImageSource.gallery);
                Navigator.pop(ctx);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image_search),
                  Text(
                    'Gallery',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
