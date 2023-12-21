import json

def lambda_handler(event, context):
    # Extracting number1 and number2 from the event object
    number1 = json.loads(event['body'])['number1']
    number2 = json.loads(event['body'])['number1']

    # Check if number1 and number2 are provided
    if number1 is None or number2 is None:
        return {
            "statusCode": 400,  # Bad Request
            "body": json.dumps({"error": "number1 and number2 must be provided"})
        }

    # Calculate the sum
    result = number1 + number2

    # Returning the response with statusCode and body
    return {
        "statusCode": 200,  # OK
        "body": json.dumps({"sum": result})
    }
