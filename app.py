from flask import Flask, render_template_string
import os

app = Flask(__name__)
APP_VERSION = os.getenv("APP_VERSION", "v0.0.0")

html = f"""
<h2 style='text-align:center'>Netflix Clone App - Version: {APP_VERSION}</h2>
<p style='text-align:center'>Deployed with Jenkins + Docker 🚀</p>
"""

@app.route("/")
def home():
    return render_template_string(html)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

