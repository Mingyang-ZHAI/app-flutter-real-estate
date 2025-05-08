from flask import Flask, request, jsonify
from flask_cors import CORS
import stripe
import logging
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

# 设置更详细的日志格式
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

stripe.api_key = os.getenv("STRIPE_SECRET_KEY")

@app.route("/create-payment-intent", methods=["POST"])
def create_payment():
    logger.info("Received request to create payment intent")
    try:
        if not request.is_json:
            logger.error("Request is not JSON")
            return jsonify({"error": "Content-Type must be application/json"}), 400

        data = request.get_json()
        logger.info(f"Received data: {data}")

        amount = data.get("amount")
        if amount is None:
            logger.error("Amount is missing")
            return jsonify({"error": "Amount is required"}), 400
        
        try:
            amount = int(amount)
            logger.info(f"Processing amount: {amount}")
        except (TypeError, ValueError):
            logger.error(f"Invalid amount value: {amount}")
            return jsonify({"error": "Amount must be a number"}), 400

        logger.info("Creating Stripe PaymentIntent...")
        intent = stripe.PaymentIntent.create(
            amount=amount,
            currency="usd",
            automatic_payment_methods={"enabled": True},
        )
        
        logger.info(f"PaymentIntent created successfully: {intent.id}")
        response = jsonify({"client_secret": intent.client_secret})
        logger.info(f"Sending response: {response.get_data(as_text=True)}")
        return response
    
    except stripe.error.StripeError as e:
        logger.error(f"Stripe error: {str(e)}")
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    logger.info("Starting Flask server...")
    app.run(host="0.0.0.0", port=5001, debug=True)
