// Packages
import 'package:chatifyapp/widgets/rounded_image_network.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

// Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';

// Providers
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
// * Responsive layout
  late double _deviceWidth;
  late double _deviceHeight;

  //* Store reference Provider
  late AuthenticationProvider _auth;
  //* Store database reference Provider
  late DatabaseService _database;
  //* Store cloud storage reference
  late CloudStorageService _cloudStorageService;

// *Variables to store each Form field input values (texts)
  String? _username;
  String? _email;
  String? _password;

// * Variable responsible for holding/store our image
  PlatformFile? _profileImage;

// Form key
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _database = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * .03,
          vertical: _deviceHeight * .02,
        ),
        width: _deviceWidth * .97,
        height: _deviceHeight * .98,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(
              height: _deviceHeight * .05,
            ),
            _registerForm(),
            SizedBox(
              height: _deviceHeight * .05,
            ),
            _registerButton(),
            SizedBox(
              height: _deviceHeight * .05,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () =>
          GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
        (_file) {
          setState(
            () {
              _profileImage = _file;
            },
          );
        },
      ),
      child: () {
        if (_profileImage != null) {
          // Selected image
          return RoundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * .15,
          );
        } else {
          // Default Image
          return RoundedImageNetwork(
            key: UniqueKey(),
            size: _deviceHeight * .15,
            imagePath:
                'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg', //'http://i.pravatar.cc/1000?img=65',
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      height: _deviceHeight * .35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // *Username
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _username = _value;
                });
              },
              regularExpression: r'.{8}',
              hintText: 'Username',
              obscureText: false,
            ),
            // *Email Field
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regularExpression:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: 'Email',
              obscureText: false,
            ),
            // TODO: Add Hde/Show Password toggle
            // *Password Field
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regularExpression: r".{8,}", //Password longer than 8 char
              hintText: 'Email',
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

// TODO: Futuramente, mudar o nome de Register => Sign up e colocar texto SIgn up em bold
  Widget _registerButton() {
    return RoundedButton(
      name: 'Register',
      width: _deviceWidth * .65,
      height: _deviceHeight * .075,
      onPress: () async {
        if (_registerFormKey.currentState!.validate() && _profileImage != null) {
          //* Continue with registering user
        }
      },
    );
  }
}
