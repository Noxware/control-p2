import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:control_p2/widgets/split_view.dart';
import 'package:control_p2/widgets/resource_viewer.dart';
import 'package:control_p2/widgets/friendly_error.dart';
import 'package:control_p2/cubit/organizer_cubit.dart';
import 'package:control_p2/models/models.dart';

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
      ratio: 0.2,
      first: _viewer(context, state),
      second: _decisions(context, state),
    );
  }

  Widget _viewer(BuildContext context, OrganizerSnapshot state) {
    if (state.isEmpty) {
      return Text('Organization complete');
    }

    return ResourceViewer(resource: state.resource!);
  }

  Widget _decisions(BuildContext context, OrganizerSnapshot state) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final d = state.decisions[index];

        return ListTile(
          title: Text(d.name),
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
}
