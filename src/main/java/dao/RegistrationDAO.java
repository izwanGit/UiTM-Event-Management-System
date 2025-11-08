package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Registration;
import model.EventRegistration;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class RegistrationDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/s9946_UEMS";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // XAMPP's default password is empty
    
    private static final String getLastRegistrationID = "SELECT registrationID FROM REGISTRATION ORDER BY registrationID DESC LIMIT 1";
    
    // Static block to load the driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public static String generateNextRegistrationID() {
        String lastID = null;
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
                PreparedStatement ps = con.prepareStatement(getLastRegistrationID);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                lastID = rs.getString("registrationID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (lastID == null) {
            return "RG0001";
        }

        int num = Integer.parseInt(lastID.substring(2)) + 1;
        return String.format("RG%04d", num);
    }

    public List<EventRegistration> getRegisteredEvents(String participantId) {
        List<EventRegistration> eventList = new ArrayList<>();

        try{
            // Load JDBC driver
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/s9946_UEMS", "root", "");
            // Adjusted SQL query to only use the EVENT table
            String sql = "SELECT r.registrationID, e.eventName, e.eventDate, r.registrationDate, e.eventLocation, e.eventStatus, e.eventID FROM REGISTRATION r " +
                    "JOIN EVENT e ON r.eventID = e.eventID WHERE r.participantID = ? ORDER BY e.eventDate DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, participantId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Retrieve data from the ResultSet
                    String registrationId = rs.getString("registrationID");
                    String eventName = rs.getString("eventName");
                    String eventDate = rs.getDate("eventDate") != null ? rs.getDate("eventDate").toString() : null;
                    String registrationDate = rs.getDate("registrationDate") != null ? rs.getDate("registrationDate").toString() : null;
                    String eventLocation = rs.getString("eventLocation");
                    String eventStatus = rs.getString("eventStatus");
                    String eventId = rs.getString("eventID");



                    // Create a new EventRegistration object
                    EventRegistration event = new EventRegistration(registrationId, eventName, eventDate, registrationDate, eventLocation, eventStatus, eventId);

                    // Add the event to the list
                    eventList.add(event);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return eventList;
    }
    
    public List<EventRegistration> getCancelableEvents(String participantId) {
        List<EventRegistration> eventList = new ArrayList<>();

        try{
            // Load JDBC driver
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/s9946_UEMS", "root", "");
            // Adjusted SQL query to only use the EVENT table
            String sql = "SELECT r.registrationID, e.eventName, e.eventDate, r.registrationDate, e.eventLocation, e.eventStatus, e.eventID FROM REGISTRATION r " +
                    "JOIN EVENT e ON r.eventID = e.eventID WHERE r.participantID = ? AND e.eventStatus IN ('Ongoing', 'Upcoming') ORDER BY r.registrationDate DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, participantId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Retrieve data from the ResultSet
                    String registrationId = rs.getString("registrationID");
                    String eventName = rs.getString("eventName");
                    String eventDate = rs.getDate("eventDate") != null ? rs.getDate("eventDate").toString() : null;
                    String registrationDate = rs.getDate("registrationDate") != null ? rs.getDate("registrationDate").toString() : null;
                    String eventLocation = rs.getString("eventLocation");
                    String eventStatus = rs.getString("eventStatus");
                    String eventId = rs.getString("eventID");

                    // Create a new EventRegistration object
                    EventRegistration event = new EventRegistration(registrationId, eventName, eventDate, registrationDate, eventLocation, eventStatus, eventId);

                    // Add the event to the list
                    eventList.add(event);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return eventList;
    }

    public boolean deleteRegistration(String registrationId) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/s9946_UEMS", "root", "");

            // Query to check event status, event date, and event time
            String checkStatusQuery = "SELECT e.eventStatus, e.eventDate, e.eventTime " +
                                      "FROM EVENT e JOIN REGISTRATION r ON e.eventID = r.eventID " +
                                      "WHERE r.registrationID = ?";
            ps = con.prepareStatement(checkStatusQuery);
            ps.setString(1, registrationId);
            rs = ps.executeQuery();

            if (rs.next()) {
                String eventStatus = rs.getString("eventStatus");
                Date eventDate = rs.getDate("eventDate"); // YYYY-MM-DD
                Time eventTime = rs.getTime("eventTime"); // HH:MM:SS

                // Convert to LocalDateTime
                LocalDateTime eventStartTime = eventDate.toLocalDate().atTime(eventTime.toLocalTime());
                LocalDateTime now = LocalDateTime.now();

                // Check if event is ongoing or within 24 hours
                if ("ongoing".equalsIgnoreCase(eventStatus)) {
                    System.out.println("Deletion not allowed. Event is ongoing.");
                } else if (eventStartTime.isBefore(now.plusHours(24))) {
                    System.out.println("Deletion not allowed. Event starts within 24 hours.");
                } else {
                    // Proceed with deletion
                    String deleteQuery = "DELETE FROM REGISTRATION WHERE registrationID = ?";
                    ps = con.prepareStatement(deleteQuery);
                    ps.setString(1, registrationId);

                    int res = ps.executeUpdate();
                    if (res == 1) {
                        status = true;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return status;
    }



    public boolean hasParticipants(String eventId) {
        boolean hasParticipants = false;
        
        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
            
            // SQL query to count the number of registrations for the event
            String sql = "SELECT COUNT(*) FROM REGISTRATION WHERE eventID = ?";
            
            // Prepare statement and set parameters
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, eventId);
            
            // Execute query
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1); // Get the count of participants
                    if (count > 0) {
                        hasParticipants = true; // Event has participants
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return hasParticipants;
    }

    
    public boolean registerForEvent(Registration registration) {
        String query = "INSERT INTO REGISTRATION (registrationID, participantID, eventID, registrationDate) VALUES (?, ?, ?, ?)";
        
        boolean status = false;

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = con.prepareStatement(query)) {
        	
        	stmt.setString(1, registration.getRegistrationID()); 
        	stmt.setString(2, registration.getParticipantID());  
            stmt.setString(3, registration.getEventID());       
            stmt.setDate(4, new java.sql.Date(registration.getRegistrationDate().getTime())); 
            int res = stmt.executeUpdate();
            
            if (res == 1) {
                status = true;
                System.out.println("Successfully registered: " + registration.getRegistrationID());
            } else {
                System.out.println("Failed to register: " + registration.getRegistrationID());
            }

        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace(); // Log error for debugging
        }
        return status;
    }
    
    public boolean isUserRegistered(String userID, String eventID) {
        String query = "SELECT COUNT(*) FROM REGISTRATION WHERE participantID = ? AND eventID = ?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, userID);
            stmt.setString(2, eventID);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
