# def lambda_handler(event, context):
#     number1 = event['number1']
#     number2 = event['number2']
#     return {'sum': number1 + number2}


import json

def lambda_handler(event, context):
    # Extracting number1 and number2 from the event object
    number1 = event.get('number1')
    number2 = event.get('number2')

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
