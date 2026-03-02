function handler(event) {
  var request = event.request;
  var response = event.response;
  var origin = request.headers['origin'] ? request.headers['origin'].value : '';
  if (origin === 'https://${allowed_origin}') {
    response.headers['access-control-allow-origin'] = { value: origin };
    response.headers['access-control-allow-methods'] = { value: 'GET, HEAD, OPTIONS' };
  }
  return response;
}
