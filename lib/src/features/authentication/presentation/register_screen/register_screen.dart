// Packages
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';

// Services

// Widgets
import '../../../../application/firestore_database_service/database_service.dart';
import '../../../../application/application_export.dart';
import '../../application/authentication_provider_service.dart';

// Providers
import 'package:provider/provider.dart';

import '../../widgets/widgets_export.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
// * Responsive layout
  late double _deviceWidth;
  late double _deviceHeight;

  //* Store reference Provider
  late AuthenticationProviderService _auth;
  //* Store database reference Provider
  late DatabaseService _database;
  //* Store cloud storage reference
  late CloudStorageService _cloudStorageService;
  // * Store reference to the navigation service

// *Variables to store each Form field input values (texts)
  String? _name;
  String? _email;
  String? _password;

// * Variable responsible for holding/store our image
  PlatformFile? _profileImage;

// Form key
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // * The auth provider will work because we wrapped our mainApp with MultiProvider
    _auth = Provider.of<AuthenticationProviderService>(context);
    _database = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();

    // * Responsive device
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

  // *Upload image
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
          return RoundedImageNetworkWidget(
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
            // *Name
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              regularExpression: r'.{8}',
              hintText: 'Name',
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
            // TODO: Add Hide/Show Password toggle
            // *Password Field
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regularExpression: r".{8,}", //Password longer than 8 char
              hintText: 'Password',
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

// TODO: Futuramente, mudar o nome de Register => Sign up e colocar texto Sign up em bold
  Widget _registerButton() {
    return CustomRoundedButtonWidget(
      name: 'Register',
      width: _deviceWidth * .65,
      height: _deviceHeight * .075,
      onPress: () async {
        if (_registerFormKey.currentState!.validate() &&
            _profileImage != null) {
          //* Saving the input
          _registerFormKey.currentState!.save();
          //* Register user in the Firebase Authentication
          final _uid = await _auth.registerUserUsingEmailAndPassword(
            _email!,
            _password!,
          );
          //* Upload the user image to the Firebase Storage
          final _imageUrl =
              await _cloudStorageService.saveUserImageProfileToStorage(
            _uid!,
            _profileImage!,
          );
          // Go to database to create user with uid
          await _database.createUser(
            _uid,
            _email!,
            _name!,
            _imageUrl!,
          );
          //* Once the user is created, we will go back to the login page where we can login with the registered credentials
          await _auth.logout();
          // * requires the login with the user previously created
          await _auth.loginUsingEmailAndPassword(
            _email!,
            _password!,
          );
        }
      },
    );
  }
}
