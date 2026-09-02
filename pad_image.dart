import 'dart:io';
import 'package:image/image.dart';

void main() {
  final file = File('assets/image/logoAleman.png');
  if (!file.existsSync()) {
    print('File not found');
    return;
  }
  
  final image = decodeImage(file.readAsBytesSync());
  if (image == null) return;
  
  // Create a larger image to add padding. e.g. 1.8x size
  final paddedSize = (image.width > image.height ? image.width : image.height) * 1.8;
  final int size = paddedSize.toInt();
  
  final paddedImage = Image(width: size, height: size);
  // Fill with white
  fill(paddedImage, color: ColorRgba8(255, 255, 255, 255));
  
  // Draw the original image in the center
  final dstX = (size - image.width) ~/ 2;
  final dstY = (size - image.height) ~/ 2;
  
  compositeImage(paddedImage, image, dstX: dstX, dstY: dstY);
  
  final out = File('assets/image/logoAleman_android12.png');
  out.writeAsBytesSync(encodePng(paddedImage));
  print('Saved padded image!');
}
