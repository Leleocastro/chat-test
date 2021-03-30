import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) onImagePick;

  UserImagePicker(this.onImagePick);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;

  bool isCamera = true;

  Future<void> _dialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deseja utilizar a câmera ou a galeria?"),
          actions: [
            TextButton.icon(
              icon: Icon(Icons.camera),
              label: Text("Câmera"),
              onPressed: () {
                isCamera = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.image_search),
              label: Text("Galeria"),
              onPressed: () {
                isCamera = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    _pickImage();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onImagePick(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
        ),
        TextButton.icon(
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            'Adicionar Imagem',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: _dialog,
        )
      ],
    );
  }
}
