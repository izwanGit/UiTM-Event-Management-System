package dao;

import model.PaymentReport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentReportDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/s9946_UEMS";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // XAMPP's default password is empty
    
    private static final String getLastPaymentID = "SELECT eventID FROM EVENT ORDER BY eventID DESC LIMIT 1";
    private static final String INSERT_PAYMENT_SQL = "INSERT INTO PAYMENT_REPORT (paymentID, eventID, dateGenerate, timeGenerate, totalAmount) VALUES (?, ?, ?, ?, ?)";
    
    // Static block to load the driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public static String generateNextPaymentID() {
        String lastID = null;
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(getLastPaymentID);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                lastID = rs.getString("paymentID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (lastID == null) {
            return "P00001";
        }

        int num = Integer.parseInt(lastID.substring(2)) + 1;
        return String.format("P%05d", num);
    }
    
    
    
    public boolean savePayment(PaymentReport payment) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(INSERT_PAYMENT_SQL)) {
            
            ps.setString(1, payment.getPaymentID());
            ps.setString(2, payment.getEventID());
            ps.setDate(3, new java.sql.Date(payment.getDateGenerate().getTime()));
            ps.setTime(4, new java.sql.Time(payment.getTimeGenerate().getTime()));
            ps.setDouble(5, payment.getTotalAmount());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Return true if the insert is successful

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static List<PaymentReport> getAllPaymentsByEventID(String eventID) {
	    List<PaymentReport> payments = new ArrayList<>();
	    
	    try {
	    	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
            String sql = "SELECT * FROM PAYMENT_REPORT WHERE eventID = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, eventID);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                PaymentReport payment = new PaymentReport(
	                    rs.getString("paymentID"),
	                    rs.getString("eventID"),
	                    rs.getDate("dateGenerate"),
	                    rs.getTime("timeGenerate"),
	                    rs.getDouble("totalAmount"));
	                    
	                    payments.add(payment);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return payments;
	}
    
}
