package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Event;
import java.sql.*;
import java.time.LocalDateTime;

public class EventDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/s9946_UEMS";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // XAMPP's default password is empty

    private static final String getLastEventID = "SELECT eventID FROM EVENT ORDER BY eventID DESC LIMIT 1";

    // Static block to load the driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private static String generateNextEventID() {
		String lastID = null;
		try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
				PreparedStatement ps = con.prepareStatement(getLastEventID);
				ResultSet rs = ps.executeQuery()) {

			if (rs.next()) {
				lastID = rs.getString("eventID");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (lastID == null) {
			return "EV0001";
		}

		int num = Integer.parseInt(lastID.substring(2)) + 1;
		return String.format("EV%04d", num);
	}

    public static String insertEvent(Event event) {
		String eventID = generateNextEventID();

		try {
			Connection con = DriverManager.getConnection(URL, USER, PASSWORD);

			String sql = "INSERT INTO EVENT(eventID, organiserID, eventName, eventDate, eventTime, eventLocation, eventPrice, eventStatus, maxParticipant, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
			PreparedStatement ps = con.prepareStatement(sql);

			ps.setString(1, eventID);
			ps.setString(2, event.getOrganiserID());
			ps.setString(3, event.getEventName());
			ps.setDate(4, event.getEventDate());
			ps.setTime(5, event.getEventTime());
			ps.setString(6, event.getEventLocation());
			ps.setDouble(7, event.getEventPrice());
			ps.setString(8, event.getEventStatus());
			ps.setInt(9, event.getMaxParticipant());
			ps.setString(10, event.getDescription());

			int result = ps.executeUpdate();
			if (result == 1) {
				return eventID;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

    public static List<Event> eventList(String organiserID) {
		List<Event> events = new ArrayList<>();

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
					PreparedStatement ps = con.prepareStatement("SELECT * FROM EVENT WHERE organiserID = ?")) {

				ps.setString(1, organiserID);

				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						Event event = new Event();
						event.setEventID(rs.getString("eventID"));
						event.setOrganiserID(rs.getString("organiserID"));
						event.setEventName(rs.getString("eventName"));
						event.setEventDate(rs.getDate("eventDate"));
						event.setEventTime(rs.getTime("eventTime"));
						event.setEventLocation(rs.getString("eventLocation"));
						event.setEventPrice(rs.getDouble("eventPrice"));
						event.setEventStatus(rs.getString("eventStatus"));
						event.setMaxParticipant(rs.getInt("maxParticipant"));

						// Handle NULL description
						String description = rs.getString("description");
						event.setDescription(description != null && !description.isEmpty() ? description
								: "No description available");

						events.add(event);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return events;
	}
    
    public List<Event> getFilteredEvents(String status, String organiserID, String searchQuery) {
        List<Event> eventList = new ArrayList<>();
        List<String> params = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT * FROM EVENT WHERE 1=1");
        
        // Add filters based on parameters
        if (status != null && !status.isEmpty()) {
            sql.append(" AND eventStatus = ?");
            params.add(status);
        }
        if (organiserID != null && !organiserID.isEmpty()) {
            sql.append(" AND organiserID = ?");
            params.add(organiserID);
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append(" AND eventName LIKE ?");
            params.add("%" + searchQuery + "%");
        }
        
        sql.append(" ORDER BY eventDate DESC");

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            // Set parameters in the correct order
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Event event = new Event();
                event.setEventID(rs.getString("eventID"));
                event.setOrganiserID(rs.getString("organiserID"));
                event.setEventName(rs.getString("eventName"));
                event.setEventDate(rs.getDate("eventDate"));
                event.setEventTime(rs.getTime("eventTime"));
                event.setEventLocation(rs.getString("eventLocation"));
                event.setEventPrice(rs.getDouble("eventPrice"));
                event.setEventStatus(rs.getString("eventStatus"));
                event.setMaxParticipant(rs.getInt("maxParticipant"));
                
				// Handle NULL description
				String description = rs.getString("description");
				event.setDescription(description != null && !description.isEmpty() ? description
						: "No description available");
                
                eventList.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return eventList;
    }

public boolean deleteEvent(String eventID) {
    boolean status = false;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(URL, USER, PASSWORD);

        // Query to check event start time
        String checkEventTimeSQL = "SELECT eventDate, eventTime FROM EVENT WHERE eventID = ?";
        ps = con.prepareStatement(checkEventTimeSQL);
        ps.setString(1, eventID);
        rs = ps.executeQuery();

        if (rs.next()) {
            Date eventDate = rs.getDate("eventDate"); // YYYY-MM-DD
            Time eventTime = rs.getTime("eventTime"); // HH:MM:SS

            // Convert to LocalDateTime
            LocalDateTime eventStartTime = eventDate.toLocalDate().atTime(eventTime.toLocalTime());
            LocalDateTime now = LocalDateTime.now();

            // Check if the event starts within 48 hours
            if (eventStartTime.isBefore(now.plusHours(48))) {
                System.out.println("Deletion not allowed. Event starts within 48 hours.");
                return false;
            }

            // Proceed with deletion
            String deleteEventSQL = "DELETE FROM EVENT WHERE eventID = ?";
            ps = con.prepareStatement(deleteEventSQL);
            ps.setString(1, eventID);

            int result = ps.executeUpdate();
            if (result == 1) {
                status = true; // Successfully deleted
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

    
    public List<Event> getOrganisedEvents(String organiserId) {
        List<Event> eventList = new ArrayList<>();

        try{
            // Load JDBC driver
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://139.99.124.197:3306/s9946_UEMS", "u9946_V6ind91OVj", "v76tb2IsW0A@=99ho.VP@xjB");
            // Adjusted SQL query to only use the EVENT table
            String sql = "SELECT * FROM EVENT WHERE organiserId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, organiserId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                	String eventId = rs.getString("eventID");
                    String organiserIdValue = rs.getString("organiserID");
                    String eventName = rs.getString("eventName");
                    Date eventDate = rs.getDate("eventDate");
                    Time eventTime = rs.getTime("eventTime");
                    String eventLocation = rs.getString("eventLocation");
                    double eventPrice = rs.getDouble("eventPrice");
                    String eventStatus = rs.getString("eventStatus");
                    int maxParticipant = rs.getInt("maxParticipant");
                    String description = rs.getString("description");
                    
                    Event event = new Event(eventId, organiserIdValue, eventName, eventDate, eventTime, eventLocation, eventPrice, eventStatus, maxParticipant, description);
                    
                    eventList.add(event);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return eventList;
    }
    
    public List<Event> getAllEvents() {
        List<Event> eventList = new ArrayList<>();

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement("SELECT * FROM EVENT ORDER BY eventDate DESC");
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Event event = new Event();
                event.setEventID(rs.getString("eventID"));
                event.setOrganiserID(rs.getString("organiserID"));
                event.setEventName(rs.getString("eventName"));
                event.setEventDate(rs.getDate("eventDate"));
                event.setEventTime(rs.getTime("eventTime"));
                event.setEventLocation(rs.getString("eventLocation"));
                event.setEventPrice(rs.getDouble("eventPrice"));
                event.setEventStatus(rs.getString("eventStatus"));
                event.setMaxParticipant(rs.getInt("maxParticipant"));
                
                
                // If description is null
                String description = rs.getString("description");
                if (description == null || description.trim().isEmpty()) {
                    description = "No description available"; // Default value
                }

                event.setDescription(description);
                
                eventList.add(event);
                
                System.out.println("Fetched event: " + event.getEventID()); // Debugging
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Fetched events: " + eventList.size()); // Debugging log
       
        
        return eventList;
    }
    
    public int getTotalParticipant(String EventId) {
        int totalParticipant=0;

        try{
            // Load JDBC driver
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/s9946_UEMS", "root", "");
            // Adjusted SQL query to only use the EVENT table
            String sql = "SELECT COUNT(*) AS TOTAL_PARTICIPANT FROM REGISTRATION WHERE eventID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, EventId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                	totalParticipant = rs.getInt("TOTAL_PARTICIPANT");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
		return totalParticipant;
    }

    public static boolean editEvent(Event event) {
        boolean status = false;
        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);

            // Prepare the SQL statement
            String updateEventSQL = "UPDATE EVENT SET " +
                    "organiserID = ?, " +
                    "eventName = ?, " +
                    "eventDate = ?, " +
                    "eventTime = ?, " +
                    "eventLocation = ?, " +
                    "eventPrice = ?, " +
                    "eventStatus = ?, " +
                    "maxParticipant = ?, " +
                    "description = ? " +
                    "WHERE eventID = ?";
            PreparedStatement ps = con.prepareStatement(updateEventSQL);

            // Set parameters
            ps.setString(1, event.getOrganiserID());
            ps.setString(2, event.getEventName());
            ps.setDate(3, event.getEventDate());
            ps.setTime(4, event.getEventTime());
            ps.setString(5, event.getEventLocation());
            ps.setDouble(6, event.getEventPrice());
            ps.setString(7, event.getEventStatus());
            ps.setInt(8, event.getMaxParticipant());
            ps.setString(9, event.getDescription());
            ps.setString(10, event.getEventID());

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
    
    public Event getEventByID(String eventID) {
        Event event = null;
        /**String query = "SELECT e.eventID, e.eventName, e.eventLocation, e.eventDate, e.eventTime, e.eventPrice, e.eventStatus, e.maxParticipants, e.description "
                     + "FROM EVENT e "
                     + "JOIN REGISTRATION r ON e.eventID = r.eventID "
                     + "WHERE e.eventID = ?";
        **/
        String query = "SELECT eventID, organiserID, eventName, eventDate, eventTime, eventLocation, eventPrice, eventStatus, maxParticipant, description"
        			+ " FROM EVENT "
        			+ "WHERE eventID = ?";
        			 
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, eventID);
            System.out.println("Querying eventID: " + eventID); // Debugging
            
            // Execute the query
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                	event = new Event();
                    event.setEventID(rs.getString("eventID"));
                    event.setOrganiserID(rs.getString("organiserID"));
                    event.setEventName(rs.getString("eventName"));
                    event.setEventDate(rs.getDate("eventDate"));
                    event.setEventTime(rs.getTime("eventTime"));
                    event.setEventLocation(rs.getString("eventLocation"));
                    event.setEventPrice(rs.getDouble("eventPrice"));
                    event.setEventStatus(rs.getString("eventStatus"));
                    event.setMaxParticipant(rs.getInt("maxParticipant"));
                    
                    // Check if description is null or empty and set a default value
                    String description = rs.getString("description");
                    if (description == null || description.isEmpty()) {
                        event.setDescription("No description available."); // Set a default description
                    } else {
                        event.setDescription(description);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return event;
    }
    
 // Method to fetch the next upcoming event
    public Event getUpcomingEvent() {
        Event event = null;
        
        String query = "SELECT eventID, organiserID, eventName, eventDate, eventTime, eventLocation, eventPrice, eventStatus, maxParticipant, description "
                + "FROM EVENT "
                + "WHERE eventDate > CURRENT_DATE "
                + "ORDER BY eventDate LIMIT 1";
        
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = con.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
            	event = new Event();
                event.setEventID(rs.getString("eventID"));
                event.setOrganiserID(rs.getString("organiserID"));
                event.setEventName(rs.getString("eventName"));
                event.setEventDate(rs.getDate("eventDate"));
                event.setEventTime(rs.getTime("eventTime"));
                event.setEventLocation(rs.getString("eventLocation"));
                event.setEventPrice(rs.getDouble("eventPrice"));
                event.setEventStatus(rs.getString("eventStatus"));
                event.setMaxParticipant(rs.getInt("maxParticipant"));
                event.setDescription(rs.getString("description"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return event;
    }
    
    
    public List<Event> getFilteredEvents(String category, String searchQuery) {
        List<Event> eventList = new ArrayList<>();
        
        String sql = "SELECT * FROM EVENT WHERE 1=1"; // Base query
        List<String> params = new ArrayList<>(); // Store parameters for debugging

        if (category != null && !category.isEmpty()) {
            sql += " AND eventStatus = ?";
            params.add(category);
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql += " AND eventName LIKE ?";
            params.add("%" + searchQuery + "%");
        }

        // Debugging
        System.out.println("Executing SQL: " + sql);
        System.out.println("With parameters: " + params);

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {

            int paramIndex = 1;
            for (String param : params) {
                ps.setString(paramIndex++, param);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                eventList.add(new Event(
                    rs.getString("eventID"),
                    rs.getString("organiserID"),
                    rs.getString("eventName"),
                    rs.getDate("eventDate"),
                    rs.getTime("eventTime"),
                    rs.getString("eventLocation"),
                    rs.getDouble("eventPrice"),
                    rs.getString("eventStatus"),
                    rs.getInt("maxParticipant"),
                    rs.getString("description")
                ));
            }

            System.out.println("Number of filtered events fetched: " + eventList.size());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return eventList;
    }
    
    




}