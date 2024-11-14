# MySQL Troubleshooting

Test Query to see if data is being written to the database: 

mysql -h mysql.cosmos.svc.cluster.local -u root -ptHtkmh2t05cu9Qft30lnoGLWV29u2OnsZfWZtp4mNkLVVDLhijhK5397o

---

CREATE DATABASE saber_db;

---

GRANT ALL PRIVILEGES ON saber_db.* TO 'root'@'%';
FLUSH PRIVILEGES;

---

USE saber_db;

---SELECT 
  TABLE_NAME, 
  UPDATE_TIME
FROM 
  INFORMATION_SCHEMA.TABLES
WHERE 
  TABLE_SCHEMA = 'saber_db'
ORDER BY 
  UPDATE_TIME DESC;

---

DESCRIBE table_name;

---

SELECT * FROM table_name LIMIT 5;

---

SELECT 
  TABLE_NAME, 
  UPDATE_TIME
FROM 
  INFORMATION_SCHEMA.TABLES
WHERE 
  TABLE_SCHEMA = 'saber_db'
ORDER BY 
  UPDATE_TIME DESC;

            