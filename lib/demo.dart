List<String> helloStrings = [
  'Hello String 1',
  'Hello String 2',
  'Hello String 3',
  'Hello String 4',
  // 'Hello String 5'
];

List<String> welcomeStrings = [
  'Welcome String 1',
  'Welcome String 2',
  'Welcome String 3',
  'Welcome String 4',
];

Future<List<String>> fetchHelloString() async {
  await Future.delayed(Duration(seconds: 2));
  return helloStrings;
}

Future<List<String>> fetchWelcomeString() async {
  await Future.delayed(Duration(seconds: 1));
  return welcomeStrings;
}
