from flask import Flask, request, jsonify, send_file
from weasyprint import HTML
from io import BytesIO

app = Flask(__name__)


@app.route("/convert", methods=["POST"])
def convert_html_to_pdf():
    # Check for the correct content type
    if request.content_type != "application/json":
        return jsonify({"error": "Content-Type must be application/json"}), 415

    # Try to parse the JSON data
    try:
        data = request.get_json(
            force=True
        )  # force=True to parse JSON even if Content-Type is not set correctly
    except Exception as e:
        return jsonify({"error": "Invalid JSON payload"}), 400

    # Check for the HTML content
    html_content = data.get("html")
    if not html_content:
        return jsonify({"error": "HTML content is required"}), 400

    # Generate PDF
    pdf = HTML(string=html_content).write_pdf()
    return send_file(BytesIO(pdf), download_name="output.pdf", as_attachment=True)


if __name__ == "__main__":
    app.run(debug=True)
