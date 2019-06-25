Map config = {
  'protocol': 'http',
  'serverUrl': '54.169.38.97',
  'serverPort': '4200'
};

String baseServer = '${config['protocol']}://${config['serverUrl']}:${config['serverPort']}';
String baseApi = '$baseServer/api';