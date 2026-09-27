import 'package:flutter/material.dart';
import 'core/api.dart';
import 'core/theme.dart';
import 'features/auth.dart';
import 'features/rider.dart';
import 'features/mechanic.dart';
import 'features/admin.dart';

void main()=>runApp(const BikeRescueApp());
class BikeRescueApp extends StatefulWidget {const BikeRescueApp({super.key});@override State<BikeRescueApp> createState()=>_BikeRescueAppState();}
class _BikeRescueAppState extends State<BikeRescueApp>{final api=BikeApi();Map<String,dynamic>? user;bool loading=true;
 @override void initState(){super.initState();_restore();}
 Future<void> _restore() async {await api.restore();if(api.token!=null){try{user=Map<String,dynamic>.from(await api.call('GET','/profile'));}catch(_){await api.signOut();}}if(mounted)setState(()=>loading=false);}
 void _signedIn(Map<String,dynamic> value){setState(()=>user=value);}
 Future<void> _signedOut() async {await api.signOut();if(mounted)setState(()=>user=null);}
 @override Widget build(BuildContext context)=>MaterialApp(title:'Bike Rescue',theme:appTheme,debugShowCheckedModeBanner:false,home:loading?const Scaffold(body:Center(child:CircularProgressIndicator())):user==null?AuthScreen(api:api,onSignedIn:_signedIn):switch(user!['role']){'MECHANIC'=>MechanicShell(api:api,user:user!,onSignOut:_signedOut),'ADMIN'=>AdminShell(api:api,user:user!,onSignOut:_signedOut),_=>RiderShell(api:api,user:user!,onSignOut:_signedOut)});
}
