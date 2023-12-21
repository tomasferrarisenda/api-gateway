def lambda_handler(event, context):
    number1 = event['number1']
    number2 = event['number2']
    return {'sum': number1 + number2}
