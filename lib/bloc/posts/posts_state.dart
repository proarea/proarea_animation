part of 'posts_cubit.dart';

@immutable
class PostsState extends BaseState {
  final List<Post> posts;

  const PostsState({
    super.status,
    super.message,
    this.posts = const [],
  });

  @override
  List<Object?> get props {
    return [
      ...super.props,
      posts,
    ];
  }

  PostsState copyWith({
    StateStatus? status,
    String? massage,
    List<Post>? posts,
  }) {
    return PostsState(
      status: status ?? super.status,
      message: massage ?? super.message,
      posts: posts ?? this.posts,
    );
  }
}