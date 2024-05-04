import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late ColorPallete colorPallete;
  late SharedPreferences prefs;

  XFile? _selectedImage;
  bool _isLoading = true;

   @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    prefs = await SharedPreferences.getInstance().then((value) {
      colorPallete = value.getBool('isDarkMode') ?? false
          ? DarkModeColorPallete()
          : LightModeColorPallete();
      setState(() {
        _isLoading = false;
      });
      return value;
    });
  }

  Future<void> submit() async {
    try {
      if (_selectedImage != null) {
        ProfileService.addPhotoProfile(_selectedImage as File);
      }

      if (_usernameController.text.isNotEmpty) {
        ProfileService.addUser(_usernameController.text, _phoneController.text, _bioController.text);
      } else {
        return;
      }

      Navigator.popAndPushNamed(context, 'home');
    } catch (e) {
     print(e); 
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading 
    ? const Center(child: CircularProgressIndicator()) : 
    Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: () {
            submit();
          }, child: const Text('Done')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () async {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      
                      if (image != null) {
                        setState(() {
                          _selectedImage = image;
                        });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          minRadius: 60,
                          maxRadius: 60,
                          child: _selectedImage != null ? 
                            Image.file(_selectedImage! as File, fit: BoxFit.cover,) : 
                            Image(image: colorPallete.logo, fit: BoxFit.cover,),
                        ),
                        const Icon(Icons.add, color: Colors.black26, size: 60,),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('Username'),
                        Tooltip(
                          enableTapToDismiss: true,
                          verticalOffset: 10,
                          triggerMode: TooltipTriggerMode.tap,
                          message: "required",
                          child: Text(" *"),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _usernameController,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Phone Number'),
                    TextField(
                      controller: _phoneController,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bio'),
                    TextField(
                      controller: _bioController,
                    ),
                  ],
                ),
              ],
            ),
          ],
        
        ),
      ),
    );
  }
}