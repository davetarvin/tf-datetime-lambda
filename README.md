# tf-datetime-lambda

Terraform deployed AWS Lambda function to get the current date/time for any time zone.

## Examples ##

[https://e5mlv26hz5.execute-api.us-east-1.amazonaws.com/api/now]

[https://e5mlv26hz5.execute-api.us-east-1.amazonaws.com/api/now?timezone=America/Chicago]

[https://e5mlv26hz5.execute-api.us-east-1.amazonaws.com/api/now?timezone=America/Los_Angeles]

[https://e5mlv26hz5.execute-api.us-east-1.amazonaws.com/api/now?timezone=America/New_York]

## API ##

```
Default time zone (America/Chicago):

GET /api/now
{"dateTime":"MM/DD/YYYY, HH:MM:SS AM"}

Specifying a time zone:

GET /api/now?timezone={tz timezone name}
{"dateTime":"MM/DD/YYYY, HH:MM:SS AM"}
```

## List of TZ Database time zones ##

[https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List]

## About ##

This project is deployed to AWS using Terraform:

1. `terraform init`
2. `terraform apply`

The project creates an S3 bucket, Lambda function, and API Gateway. The base URL of the API outputs to the console after running `terraform apply`.
