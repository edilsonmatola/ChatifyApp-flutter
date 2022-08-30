import 'package:file_picker/file_picker.dart';

class MediaService {
  const MediaService();

  // Null checker in case we may not get any image to return
  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (_result != null) {
      // Return the first image of the array
      return _result.files[0];
    }
    // Otherwise, return null
    return null;
  }
}
