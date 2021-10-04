// _firebaseMessaging.configure(
//   onMessage: (message) async {},
//   onLaunch: (message) async {
//     if (message.containsKey('threadId') && message.containsKey('messageId')) {
//       navigatorKey.currentState.pushNamedAndRemoveUntil('/thread', (Route<dynamic> route) => route.isFirst, arguments: message);
//     }
//   },
//   onResume: (message) async {
//     if (message.containsKey('threadId') && message.containsKey('messageId')) {
//       navigatorKey.currentState.pushNamedAndRemoveUntil('/thread', (Route<dynamic> route) => route.isFirst, arguments: message);
//     }
//   },
// );
