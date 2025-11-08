# UiTM Event Management System — Setup & Usage

This README explains how to set up and run the UiTM Event Management System locally using XAMPP (MySQL) and a servlet container (Tomcat). Instructions for both macOS and Windows are included. Copy everything in this box and save as README.md in the project root.

---

## Prerequisites

- Java JDK 11+ installed
- XAMPP (MySQL) installed and running
- Apache Tomcat (or other servlet container) to run the webapp
- An IDE (Eclipse, IntelliJ, VS Code with Java extensions) or ability to deploy a WAR
- The SQL file included in this repository (e.g., `UiTM Event Management System.sql`)

---

## Files to know in the repo

- SQL to import: `UiTM Event Management System.sql`
- DAO and servlet files for DB config and file handling:
  - `src/main/java/dao/EventDAO.java`
  - `src/main/java/dao/RegistrationDAO.java`
  - `src/main/java/dao/FeedbackDAO.java`
  - `src/main/java/controller/CreateEventServlet.java`
  - `src/main/java/controller/EditEventServlet.java`

---

## Step A — Start XAMPP / MySQL

macOS:
1. Open XAMPP Control (or use Terminal) and start MySQL (and Apache if using phpMyAdmin).
2. Visit: http://localhost/phpmyadmin

Windows:
1. Open XAMPP Control Panel and click Start for MySQL (and Apache if using phpMyAdmin).
2. Visit: http://localhost/phpmyadmin

---

## Step B — Import the SQL database

1. In phpMyAdmin, either create a database named `s9946_UEMS` (recommended) or let the SQL create it.
2. Select the database, go to Import → Choose File → select `UiTM Event Management System.sql` → Go.
3. Confirm tables like `EVENT`, `REGISTRATION`, `FEEDBACK_REPORT` are created.

If the SQL uses a different DB name, either change it in phpMyAdmin or update DAO DB URL constants.

---

## Step C — Configure DB credentials (if needed)

Open DAO files and verify/update DB connection constants:

Example values to check:
```java
private static final String URL = "jdbc:mysql://localhost:3306/s9946_UEMS";
private static final String USER = "root";
private static final String PASSWORD = "";
```

Update these values if you changed MySQL user/password or DB name.

---

## Step D — Add required JARs (place 4 files into lib / build path)

Copy these four JARs into your webapp `WEB-INF/lib/` (or add to IDE build path). These are minimal required libraries:

1. mysql-connector-java-8.0.x.jar — MySQL JDBC driver  
2. jakarta.servlet-api-5.0.x.jar (or servlet API matching your container) — Servlet API  
3. jakarta.servlet.jsp-api-3.x.jar (or JSP API matching your container) — JSP API  
4. JSTL jar (e.g., jakarta.servlet.jsp.jstl-x.x.jar or taglibs-standard-impl.jar) — JSTL support

Where to put them:
- Preferred: `src/main/webapp/WEB-INF/lib/` (or `WebContent/WEB-INF/lib/`)
- Eclipse: Project → Properties → Java Build Path → Libraries → Add JARs / Add External JARs
- Tomcat alternative (less recommended): `TOMCAT_HOME/lib/`

---

## Step E — Build & Deploy

Using an IDE:
1. Configure Tomcat runtime.
2. Add the project to the server and Run.
3. Access: http://localhost:8080/<context-path>/

Manual WAR deploy:
1. Export project as WAR.
2. Copy WAR to `TOMCAT_HOME/webapps/`.
3. Start Tomcat and visit the app.

---

## Windows-specific notes

- XAMPP default MySQL user: `root` with empty password. If UAC or firewall blocks ports, allow Apache/Tomcat and MySQL.
- Paths and commands:
  - Start XAMPP: Use XAMPP Control Panel shortcut.
  - Tomcat: Use `bin\startup.bat` to start and `bin\shutdown.bat` to stop.
- If using MySQL Workbench or command line:
  - Import SQL: mysql -u root -p s9946_UEMS < "UiTM Event Management System.sql"

---

## Common troubleshooting

- Connection errors:
  - Ensure MySQL is running.
  - Confirm DB URL, user, password in DAO classes.
- ClassNotFound/NoClassDefFoundError:
  - Ensure the 4 JARs are present in `WEB-INF/lib` or added to the build path.
- File upload / poster save issues:
  - Check folder write permissions for paths used by servlets (see Create/EditEventServlet).
- Port conflicts:
  - Change Tomcat or Apache port if 8080/80 already used.

---

## Quick checklist before running

- [ ] MySQL started (XAMPP)
- [ ] SQL imported into `s9946_UEMS` (or matching database)
- [ ] DAO DB credentials match your MySQL settings
- [ ] Four JAR files copied to `WEB-INF/lib` or added to build path
- [ ] Webapp deployed to Tomcat

---

## Where to edit settings

- Database and credentials: `src/main/java/dao/*.java`
- File save paths and upload handling: `src/main/java/controller/CreateEventServlet.java` and `EditEventServlet.java`
- SQL file: `UiTM Event Management System.sql`

---
