package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.EventFeedback;
import model.FeedbackReport;

public class FeedbackDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/s9946_UEMS";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // XAMPP's default password is empty

    public List<EventFeedback> getFeedback() {
        List<EventFeedback> feedbackList = new ArrayList<>();

        try{
            // Load JDBC driver
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/s9946_UEMS", "root", "");
            // Adjusted SQL query to only use the EVENT table
            String sql = "SELECT e.eventID, p.participantID, e.eventName, e.eventDate, f.rating, f.comment, o.organiserID FROM FEEDBACK_REPORT f\n"
            				+ "JOIN ORGANISER o \n"
		            		+ "JOIN EVENT e \n"
		            		+ "JOIN REGISTRATION r\n"
		            		+ "JOIN PARTICIPANT p\n"
		            		+ "WHERE e.eventID = f.eventID AND\n"
		            		+ "r.eventID = e.eventID AND\n"
		            		+ "r.participantID = p.participantID;";
            PreparedStatement ps = con.prepareStatement(sql);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Retrieve data from the ResultSet
                    String eventId = rs.getString("eventID");
                    String participantId = rs.getString("participantID");
                    String eventName = rs.getString("eventName");
                    String eventDate = rs.getDate("eventDate") != null ? rs.getDate("eventDate").toString() : null;
                    int rating = rs.getInt("rating");
                    String comment = rs.getString("comment");
                    String organiserId = rs.getString("organiserID");

                    // Create a new EventRegistration object
                    EventFeedback feedback = new EventFeedback(eventId, participantId, eventName, eventDate, rating, comment, organiserId);

                    // Add the event to the list
                    feedbackList.add(feedback);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedbackList;
    }
    
    public List<EventFeedback> getNoFeedback(String participantID) {
        List<EventFeedback> feedbackList = new ArrayList<>();

        try{
            // Load JDBC driver
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/s9946_UEMS", "root", "");
            // Adjusted SQL query to only use the EVENT table
            String sql = "SELECT e.eventID, p.participantID, e.eventName, e.eventDate, o.organiserID\n"
		                    + "FROM EVENT e\n"
		                    + "JOIN ORGANISER o ON o.organiserID = e.organiserID\n"
		                    + "JOIN REGISTRATION r ON e.eventID = r.eventID\n"
		                    + "JOIN PARTICIPANT p ON r.participantID = p.participantID\n"
		                    + "WHERE p.participantID = ? AND\n"
		                    + "e.eventStatus = 'Ended' ORDER BY r.registrationDate DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, participantID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Retrieve data from the ResultSet
                    String eventId = rs.getString("eventID");
                    String participantId = rs.getString("participantID");
                    String eventName = rs.getString("eventName");
                    String eventDate = rs.getDate("eventDate") != null ? rs.getDate("eventDate").toString() : null;
                    int rating = 0;
                    String comment = "";
                    String organiserId = rs.getString("organiserID");


                    // Create a new EventRegistration object
                    EventFeedback feedback = new EventFeedback(eventId, participantId, eventName, eventDate, rating, comment, organiserId);

                    // Add the event to the list
                    feedbackList.add(feedback);
                }
                //System.out.println("Found " + feedbackList.size() + " events.");

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedbackList;
    }
    
 
    public List<EventFeedback> getFilteredEvents(String participantId, String category, String searchQuery) {
        List<EventFeedback> eventList = new ArrayList<>();
        List<String> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT e.eventID, p.participantID, e.eventName, e.eventDate, o.organiserID ")
                .append("FROM EVENT e ")
                .append("JOIN ORGANISER o ON o.organiserID = e.organiserID ")
                .append("JOIN REGISTRATION r ON e.eventID = r.eventID ")
                .append("JOIN PARTICIPANT p ON r.participantID = p.participantID ")
                .append("WHERE p.participantID = ? ")
                .append("AND e.eventStatus = 'Ended'");

        params.add(participantId);

        if (category != null && !category.isEmpty()) {
            sql.append(" AND o.organiserID = ?");
            params.add(category);
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append(" AND e.eventName LIKE ?");
            params.add("%" + searchQuery + "%");
        }
        sql.append(" ORDER BY eventDate DESC");


        System.out.println("SQL Query: " + sql.toString());
        System.out.println("Parameters: " + params);

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String eventId = rs.getString("eventID");
                    String participantID = rs.getString("participantID");
                    String eventName = rs.getString("eventName");
                    String eventDate = rs.getDate("eventDate") != null ? rs.getDate("eventDate").toString() : null;
                    int rating = 0;
                    String comment = "";
                    String organiserId = rs.getString("organiserID");
                    // Populate other fields of EventFeedback as necessary
                    EventFeedback event = new EventFeedback(eventId, participantID, eventName, eventDate, rating, comment, organiserId);
                    eventList.add(event);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return eventList;
    }

    
    public boolean insertFeedback(String eventId, String rating, String comment) {
    	boolean status = false;
    	try{
            // Load JDBC driver
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/s9946_UEMS", "root", "");
            // Adjusted SQL query to only use the EVENT table
            String sql = "INSERT INTO FEEDBACK_REPORT (eventID, rating, comment)\n"
            			+ "VALUES (?, ?, ?);";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, eventId);
            ps.setString(2, rating);
            ps.setString(3, comment);

            
            int res = ps.executeUpdate();
            if(res == 1) {
            	status=true;
            }
       
        } catch (Exception e) {
            e.printStackTrace();
        }
    	return status;
    	
    }

    public static List<FeedbackReport> getFeedbackReportByEventID(String eventID) {
        List<FeedbackReport> feedbackList = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM FEEDBACK_REPORT WHERE eventID = ?")) {

            stmt.setString(1, eventID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                FeedbackReport feedback = new FeedbackReport();
                feedback.setRating(rs.getInt("rating"));
                feedback.setComment(rs.getString("comment"));
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }    
}
