Map config = {
  'protocol': 'http',
  'serverUrl': '13.229.208.63',
  'serverPort': '4200'
};

String baseServer = '${config['protocol']}://${config['serverUrl']}:${config['serverPort']}';
String baseApi = '$baseServer/api';