function handler(event) {
  var request = event.request;
  var match = request.uri.match(/^\/api\/scoresaber\/player\/(\d+)\/basic$/);
  if (!match) {
    return {
      statusCode: 403,
      statusDescription: 'Forbidden',
      body: { encoding: 'text', data: 'Invalid request' }
    };
  }
  request.uri = '/api/player/' + match[1] + '/basic';
  return request;
}
