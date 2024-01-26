import boto3
def lambda_handler(event, context):
    result = "Hello Weather"
    return {
        'statusCode' : 200,
        'body': result
    }