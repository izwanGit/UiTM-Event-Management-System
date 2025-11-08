package com.uitm.eventmanagement.dao;
import com.uitm.eventmanagement.model.GmailEvent;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GmailEventDAO {
    private static final String URL = "jdbc:mysql://139.99.124.197:3306/s9946_UEMS";
    private static final String USER = "u9946_V6ind91OVj";
    private static final String PASSWORD = "v76tb2IsW0A@=99ho.VP@xjB";
    public List<GmailEvent> getUpcomingEvents() {
        List<GmailEvent> events = new ArrayList<>();
        String query = "SELECT * FROM EVENT WHERE eventDate = CURDATE() + INTERVAL 1 DAY";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = con.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            // Move to the first row of the result set
            while (rs.next()) {
                String eventId = rs.getString("eventID");
                String eventName = rs.getString("eventName");
                String eventDate = rs.getDate("eventDate") != null ? rs.getDate("eventDate").toString() : null;
                String eventTime = rs.getTime("eventTime") != null ? rs.getTime("eventTime").toString() : null;
                String eventLocation = rs.getString("eventLocation");
                // Create an event object and add it to the list
                GmailEvent event = new GmailEvent(eventId, eventName, eventDate, eventTime, eventLocation);
                events.add(event);
            }
        } catch (SQLException e) {
            // Log the exception (consider using a logging framework)
            e.printStackTrace();
        }
        return events;
    }
}
