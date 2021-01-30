import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/profile/profile_bloc.dart';

enum ProfileSection { POSTS, COMMENTS, SAVED, HIDDEN, UPVOTED, DOWNVOTED }

class ProfileSectionSwitcher extends StatelessWidget {
  const ProfileSectionSwitcher({
    Key key,
    @required this.selectedSection,
    @required this.setSelectedSection,
  }) : super(key: key);

  final ProfileSection selectedSection;
  final void Function(ProfileSection) setSelectedSection;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => ToggleButtons(
            color: Color(0xFF014A60),
            fillColor: Colors.white,
            selectedColor: Color(0xFF014A60),
            borderRadius: BorderRadius.circular(5),
            constraints: BoxConstraints.expand(
              width: (constraints.maxWidth - 16) / 3,
              height: 26,
            ),
            children: [
              Text('Posts'),
              Text('Comments'),
              Text('Saved'),
            ],
            onPressed: (index) {
              switch (index) {
                case 0:
                  setSelectedSection(ProfileSection.POSTS);
                  context.read<ProfileBloc>().add(ProfileContentRequested(
                        section: ProfileSection.POSTS,
                        filter: DEFAULT_PROFILE_FILTER,
                      ));
                  break;
                case 1:
                  setSelectedSection(ProfileSection.COMMENTS);
                  context.read<ProfileBloc>().add(ProfileContentRequested(
                        section: ProfileSection.COMMENTS,
                        filter: DEFAULT_PROFILE_FILTER,
                      ));
                  break;
                case 2:
                  setSelectedSection(ProfileSection.SAVED);
                  context.read<ProfileBloc>().add(ProfileContentRequested(
                        section: ProfileSection.SAVED,
                        filter: DEFAULT_PROFILE_FILTER,
                      ));
                  break;
                default:
                  break;
              }
            },
            isSelected: [
              selectedSection == ProfileSection.POSTS,
              selectedSection == ProfileSection.COMMENTS,
              selectedSection == ProfileSection.SAVED,
            ],
          ),
        ),
      ),
    );
  }
}
