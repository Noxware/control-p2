import 'dart:io';

import 'package:control_p2/models/models.dart';
import 'package:control_p2/widgets/friendly_error.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceViewer extends StatefulWidget {
  final Resource resource;

  const ResourceViewer({
    Key? key,
    required this.resource,
  }) : super(key: key);

  @override
  _ResourceViewerState createState() => _ResourceViewerState();
}

class _ResourceViewerState extends State<ResourceViewer> {
  Future<Object>? _dataFuture;

  @override
  Widget build(BuildContext context) {
    if (widget.resource.isRemote) {
      throw UnimplementedError('Remote resources are not supported yet.');
    }

    if (widget.resource.isText) {
      return _text(context);
    } else if (widget.resource.isImage) {
      return _image(context);
    } else {
      return _other(context);
    }
  }

  Widget _text(BuildContext context) {
    if (_dataFuture == null) {
      _dataFuture = File.fromUri(widget.resource.uri).readAsString();
    }

    return FutureBuilder(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loading(context);
        }

        if (snapshot.hasError) {
          return FriendlyError(
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }

        final text = snapshot.data as String;

        return SelectableText(text);
      },
    );
  }

  Widget _image(BuildContext context) {
    return ClipRect(
      child: PhotoView(
        imageProvider: FileImage(File.fromUri(widget.resource.uri)),
        /*backgroundDecoration: BoxDecoration(
          color: Colors.transparent,
        ),*/
      ),
    );

    /*return ExtendedImage.file(
      File.fromUri(widget.resource.uri),
      mode: ExtendedImageMode.gesture,
    );*/
  }

  Widget _other(BuildContext context) {
    return Column(
      children: [
        Text(widget.resource.uri.toString()),
        ElevatedButton(
          child: Text('Open URI'),
          onPressed: () {
            launch(widget.resource.uri.toString());
          },
        ),
      ],
    );
  }

  Widget _loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}