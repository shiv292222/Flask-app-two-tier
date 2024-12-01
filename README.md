Flask App with MySQL - Dockerized Setup
This is a simple Flask application that interacts with a MySQL database. The app allows users to submit messages, which are stored in the database and displayed on the frontend.

Prerequisites
Before getting started, ensure you have the following installed on your system:

Docker
Git (optional, for cloning the repository)
Setup
Step 1: Clone the Repository
Clone this repository to your local system:

bash
Copy code
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
Step 2: Create a .env File
Create a .env file in the project directory to store MySQL environment variables:

bash
Copy code
touch .env
Add the following configuration to the .env file:

env
Copy code
MYSQL_HOST=mysql
MYSQL_USER=your_username
MYSQL_PASSWORD=your_password
MYSQL_DB=your_database
Step 3: Start the Containers
Build and start the containers using Docker Compose:

bash
Copy code
docker-compose up --build
Usage
Access the Application
Frontend: Visit the frontend in your browser at http://localhost.
Backend: Access the backend API at http://localhost:5000.
Create the Database Table
Create the messages table in your MySQL database. Use a MySQL client or tool (e.g., phpMyAdmin) and execute the following SQL command:

sql
Copy code
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT
);
Interacting with the App
Visit the frontend (http://localhost) to submit new messages via the form.
Use the backend API (http://localhost:5000/insert_sql) to insert messages directly into the messages table.
Running Without Docker Compose
To run this application without Docker Compose:

Step 1: Build the Flask App Docker Image
bash
Copy code
docker build -t flaskapp .
Step 2: Create a Docker Network
bash
Copy code
docker network create twotier
Step 3: Run the Containers
1. MySQL Container
bash
Copy code
docker run -d \
    --name mysql \
    -v mysql-data:/var/lib/mysql \
    --network=twotier \
    -e MYSQL_DATABASE=mydb \
    -e MYSQL_ROOT_PASSWORD=admin \
    -p 3306:3306 \
    mysql:5.7
2. Flask Backend Container
bash
Copy code
docker run -d \
    --name flaskapp \
    --network=twotier \
    -e MYSQL_HOST=mysql \
    -e MYSQL_USER=root \
    -e MYSQL_PASSWORD=admin \
    -e MYSQL_DB=mydb \
    -p 5000:5000 \
    flaskapp:latest
Cleaning Up
Stop and remove all containers:

bash
Copy code
docker-compose down
Notes
Replace placeholders in the .env file (e.g., your_username, your_password, your_database) with your actual MySQL configuration.
Follow best practices for security and performance in production environments.
Be cautious with direct SQL queries. Always validate and sanitize user inputs to prevent vulnerabilities like SQL injection.
For troubleshooting, check logs using:
Docker logs: docker logs <container_name>
MySQL logs: Inside the container at /var/log/mysql/.
License
This project is licensed under the MIT License.
