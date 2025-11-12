import mysql.connector
import json
import time
import os
import subprocess

# Wait for MySQL container to start
time.sleep(20)

# Fetch Terraform outputs dynamically
def get_terraform_output(output_name):
    result = subprocess.run(
        ["terraform", "output", "-json"],
        capture_output=True,
        text=True
    )
    outputs = json.loads(result.stdout)
    return outputs[output_name]["value"]

# Get variables from environment or Terraform output
EC2_PUBLIC_IP = get_terraform_output("ec2_public_ip")
MYSQL_USER = os.getenv("MYSQL_USER", "root")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "root123")
MYSQL_DB = os.getenv("MYSQL_DB", "testdb")

# Connect to MySQL
db = mysql.connector.connect(
    host=EC2_PUBLIC_IP,
    user=MYSQL_USER,
    password=MYSQL_PASSWORD
)

cursor = db.cursor()
cursor.execute(f"CREATE DATABASE IF NOT EXISTS {MYSQL_DB};")
cursor.execute(f"USE {MYSQL_DB};")

# Create table
cursor.execute("""
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary INT
);
""")

# Insert dummy data
cursor.executemany("""
INSERT INTO employees (name, department, salary)
VALUES (%s, %s, %s);
""", [
    ("anitha", "IT", 70000),
    ("harika", "Engineering", 65000),
    ("subha", "Sales", 55000)
])

db.commit()
print("✅ Data inserted successfully!")
db.close()
