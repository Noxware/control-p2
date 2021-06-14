import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import 'package:control_p2/widgets/split_view.dart';
import 'package:control_p2/widgets/resource_viewer.dart';
import 'package:control_p2/widgets/friendly_error.dart';
import 'package:control_p2/cubit/organizer_cubit.dart';
import 'package:control_p2/util/extensions/num.dart';

class Organizer extends StatelessWidget {
  const Organizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<OrganizerCubit, OrganizerState>(
        builder: (context, state) {
          if (state is OrganizerError) {
            return FriendlyError(
              error: state.error,
              stackTrace: state.stackTrace,
            );
          }

          if (state is OrganizerSnapshot) {
            if (state.isEmpty) {
              return Center(child: Text('Organization complete'));
            }

            return _snapshot(context, state);
          }

          return _loading(context, state);
        },
      )),
    );
  }

  Widget _loading(BuildContext context, OrganizerState state) {
    return Center(child: CircularProgressIndicator());
  }

  Widget _snapshot(BuildContext context, OrganizerSnapshot state) {
    return SplitView(
      axis: Axis.vertical,
      ratio: 0.7,
      first: SplitView(
          axis: Axis.horizontal,
          ratio: 0.8,
          first: _viewer(context, state),
          second: SplitView(
            axis: Axis.vertical,
            ratio: 0.6,
            first: _history(context, state),
            second: _details(context, state),
          )),
      second: _decisions(context, state),
    );
  }

  Widget _viewer(BuildContext context, OrganizerSnapshot state) {
    return GestureDetector(
      onTapDown: (details) =>
          _handleViewerMenu(context, details.globalPosition),
      child: ResourceViewer(
        resource: state.resource!,
      ),
    );
  }

  // https://stackoverflow.com/questions/54280296/how-to-show-a-menu-at-press-finger-mouse-cursor-position-in-flutter
  Future<void> _handleViewerMenu(
      BuildContext context, Offset tapPosition) async {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final ans = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem(
          child: Text('Omit'),
          value: 'omit',
        ),
        PopupMenuItem(
          child: Text('Launch URI'),
          value: 'launch',
        ),
        PopupMenuItem(
          child: Text('Cancel'),
          value: 'cancel',
        ),
      ],
      elevation: 8.0,
    );

    switch (ans) {
      case 'omit':
        context.read<OrganizerCubit>().omit();
        break;
      case 'launch':
        context.read<OrganizerCubit>().launch();
    }
  }

  Widget _decisions(BuildContext context, OrganizerSnapshot state) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final d = state.decisions[index];

        return ListTile(
          title: Text(
            d.name,
            textAlign: TextAlign.center,
          ),
          onTap: () {
            context.read<OrganizerCubit>().takeDecision(d);
          },
        );
      },
      separatorBuilder: (_, __) {
        return Divider(height: 1);
      },
      itemCount: state.decisions.length,
    );
  }

  Widget _history(BuildContext context, OrganizerSnapshot state) {
    final decisionFrames =
        context.read<OrganizerCubit>().decisionFrames.reversed.toList();

    return ListView.builder(
      itemCount: decisionFrames.length,
      itemBuilder: (context, index) {
        final f = decisionFrames[index];

        final c = f.decisions.map((d) {
          return ListTile(title: Text(d.name));
        }).toList();

        return ExpansionTile(
          title: Text(
            p.basename(File.fromUri(f.resource.uri).path),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          childrenPadding: EdgeInsets.only(left: 32, top: 8, bottom: 8),
          expandedAlignment: Alignment.centerLeft,
          leading: Icon(Icons.description),
          children: c.isNotEmpty ? c : [Text('No decision taked')],
        );
      },
    );
  }

  Widget _details(BuildContext context, OrganizerSnapshot state) {
    final res = state.resource!;
    final file = File.fromUri(res.uri);

    final filename = p.basename(file.path);
    final size = res.size?.dividedBy(1024).dividedBy(1024).toStringAsFixed(2);

    final year = res.mtime?.year.toString().padLeft(2, '0');
    final month = res.mtime?.month.toString().padLeft(2, '0');
    final day = res.mtime?.day.toString().padLeft(2, '0');
    final hour = res.mtime?.hour.toString().padLeft(2, '0');
    final minute = res.mtime?.minute.toString().padLeft(2, '0');

    final mtime = '$year/$month/$day $hour:$minute';

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Text(
          'Filename: $filename',
        ),
        SizedBox(height: 8),
        Text('Size: $size MB'),
        SizedBox(height: 8),
        Text('Last modified: $mtime'),
      ],
    );
  }
}
