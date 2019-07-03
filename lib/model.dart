Map config = {
  'protocol': 'http',
  'serverUrl': '10.99.201.151',
  'serverPort': '4100'
};

String baseServer = '${config['protocol']}://${config['serverUrl']}:${config['serverPort']}';
String baseApi = '$baseServer/api';