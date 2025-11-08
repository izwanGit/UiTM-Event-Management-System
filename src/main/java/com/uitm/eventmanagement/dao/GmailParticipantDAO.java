package com.uitm.eventmanagement.dao;
import com.uitm.eventmanagement.model.GmailParticipant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GmailParticipantDAO {
    private static final String URL = "jdbc:mysql://139.99.124.197:3306/s9946_UEMS";
    private static final String USER = "u9946_V6ind91OVj";
    private static final String PASSWORD = "v76tb2IsW0A@=99ho.VP@xjB";
    public List<GmailParticipant> getParticipantsForEvent(String eventId) throws SQLException {
        List<GmailParticipant> participants = new ArrayList<>();
        String query = "SELECT * FROM PARTICIPANT WHERE participantID IN (SELECT participantID FROM REGISTRATION WHERE eventID = ?)";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setString(1, eventId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                // Move to the first row of the ResultSet before accessing it
                while (rs.next()) {
                    // Access data after calling rs.next()
                    String participantId = rs.getString("participantID");
                    String participantName = rs.getString("participantName");
                    String participantEmail = rs.getString("participantEmail");
                    String participantPassword = rs.getString("participantPassword");
                    String participantNoTel = rs.getString("participantNoTel");
                    GmailParticipant participant = new GmailParticipant(participantId, participantName, participantEmail, participantPassword, participantNoTel);
                    participants.add(participant);
                }
            }
        }
        return participants;
    }
}