part of '../flutter_artist.dart';

class LoginView extends StatelessWidget {
  final LoginZilch loginZilch;
  final LoginModel loginModel;

  const LoginView({
    super.key,
    required this.loginZilch,
    required this.loginModel,
  });

  @override
  Widget build(BuildContext context) {
    return ZilchFragmentWidgetBuilder(
      zilch: loginZilch,
      ownerClassInstance: this,
      description: null,
      build: () {
        return Text("OK");
      },
    );
  }
}
