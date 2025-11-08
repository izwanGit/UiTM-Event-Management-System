package dao;

import java.sql.*;
import model.Organiser;

public class OrganiserDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/s9946_UEMS";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // XAMPP's default password is empty

    public Organiser getOrganiserById(String organiserID) {
        Organiser organiser = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);

            String sql = "SELECT * FROM ORGANISER WHERE organiserID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, organiserID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                organiser = new Organiser();
                organiser.setOrganiserID(rs.getString("organiserID"));
                organiser.setOrganiserPassword(rs.getString("organiserPassword"));
                organiser.setOrganiserName(rs.getString("organiserName"));
                organiser.setOrganiserEmail(rs.getString("organiserEmail"));
                organiser.setOrganiserNoTel(rs.getString("organiserNoTel"));
                organiser.setPostCaption(rs.getString("postCaption"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return organiser;
    }

    public boolean updatePostCaption(String organiserID, String postCaption) {
        boolean status = false;
        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);

            // Prepare the SQL statement
            String sql = "UPDATE ORGANISER SET postCaption = ? WHERE organiserID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, postCaption);
            ps.setString(2, organiserID);

            // Execute the query
            int result = ps.executeUpdate();
            if (result == 1) {
                status = true; // Successfully updated
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}