module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let timeZone = 'America/Chicago';

  if (event.queryStringParameters && event.queryStringParameters.timezone) {
    timeZone = event.queryStringParameters.timezone;
  }

  const dateTime = new Date().toLocaleString('en', {timeZone});

  return {
    statusCode: 200,
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({dateTime}),
  }
}
