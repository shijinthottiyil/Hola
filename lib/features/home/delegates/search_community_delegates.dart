// this is the screen for searching
//first extend the class by SearchDelegate

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hola/core/common/error_text.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  // the 4 methods or functions present here are related to appbar where our search is gettng done
  //buildActions is related to the end part of the appbar
  //buildLeading is realted to the leading part of the or starting  part of the app bar
  //buildresults  is related to the result we get when we start typing
  //suggestions related to the suggestions we get while typing

  ///buildActions:
  ///in build action what we want is a icon button or more specifically a  close button which when we press it
  ///all the search query in it should gets deleted.

//In order to get access to the searchcontrollerProvider here we will first create a variable of ref and using the constru. we initiallize the variable
//using that variable we can get access to that controller

  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/$communityName');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; //query is from search delegate class
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //for leading i don't want anything so i will return null
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // we dont want anything for the result part also but
    //it can not be null so we return an empty sizedbox
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //in the suggestions we want to display the list of community according to what the user is typing
    //watch is used because we have to keep listening
    return ref.watch(serachCommunityProvider(query)).when(
        data: (communities) {
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final community = communities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text(community.name),
                onTap: () => navigateToCommunity(context, community.name),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        // loading: () => const SizedBox());
        loading: () => const Loader());
  }
}
