import 'package:flutter/material.dart';
import 'package:flutter_application_2/page/home.dart';
import 'package:flutter_application_2/provider/auth_prover.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';



class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 2250);
  late AuthProvider _authProvider;

  Future<String?> _authUser(LoginData data) async {
    
    return Future.delayed(loginTime).then((_) async {
      try{
await _authProvider.SignIn(data.name, data.password);
return null;
      }catch(err){
       
      
        return err.toString();
      }
     
     
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    return Future.delayed(loginTime).then((_) async {
      try {
        await _authProvider.SignUp(
            data.name as String, data.password as String);
      } catch (err) {
        return err as String;
      }
      return "oke";
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'User not exists';
      // }
      return null;
    });
  }

  @override
  void didChangeDependencies() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Todo App',
      // logo: AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
       

        Provider.of<AuthProvider>(context,listen: false).changeData();
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
