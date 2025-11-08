package dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Participant;

public class UserDAO {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/s9946_UEMS";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // XAMPP's default password is empty
    
 // Static block to load the driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public boolean validateUser(String username, String password) {
        boolean isValid = false;
        String query = "";

        // Check if the username is for an organiser or a participant
        if (username.startsWith("ORG")) {
            // Organiser login query
            query = "SELECT * FROM ORGANISER WHERE organiserID = ? AND organiserPassword = ?";
        } else {
            // Participant login query
            query = "SELECT * FROM PARTICIPANT WHERE participantID = ? AND participantPassword = ?";
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                // If a record is found, the login is valid
                if (rs.next()) {
                    isValid = true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return isValid;
    }
    
    public Participant getParticipantById(String userId) {
        Participant participant = null;
        String query = "SELECT * FROM PARTICIPANT WHERE participantID = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setString(1, userId);

            ResultSet resultSet = preparedStatement.executeQuery();


            if (resultSet.next()) {
                participant = new Participant();
                participant.setParticipantID(resultSet.getString("participantID"));
                participant.setParticipantName(resultSet.getString("participantName"));
                participant.setParticipantEmail(resultSet.getString("participantEmail"));
                participant.setParticipantPassword(resultSet.getString("participantPassword"));
                participant.setParticipantNoTel(resultSet.getString("participantNoTel"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return participant;
    }
    
    public boolean updateParticipantDetails(Participant participant) {
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);) {
            String sql = "UPDATE PARTICIPANT SET participantEmail = ?, participantNoTel = ? WHERE participantID = ?";
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, participant.getParticipantEmail());
            ps.setString(2, participant.getParticipantNoTel());
            ps.setString(3, participant.getParticipantID());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    
    
}