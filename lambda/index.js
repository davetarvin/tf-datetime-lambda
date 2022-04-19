module.exports.handler = async (event) => {
  console.log('Event: ', event);
  const timeZone = 'America/Chicago';
  const dateTime = new Date().toLocaleString('en', {timeZone});
  const message = `The Lambda function ran at: ${dateTime}`;

  return {
    statusCode: 200,
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({message}),
  }
}
