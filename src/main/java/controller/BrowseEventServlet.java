package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.EventDAO;
import model.Event;

@MultipartConfig // Enables file upload handling
public class BrowseEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            // If user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        /// Retrieve the success message from session
        System.out.println("Session ID: " + session.getId());
        String registrationStatus = (String) session.getAttribute("registrationStatus");
        System.out.println("Fetched registrationStatus: " + registrationStatus);


        // If the message exists, set it as a request attribute for displaying
        if (registrationStatus != null) {
            request.setAttribute("successMessage", registrationStatus);
        }
        
        // Fetch the list of events from the database
        EventDAO eventDAO = new EventDAO();
        List<Event> eventList = eventDAO.getAllEvents(); // assuming this method returns all events
        
        EventDAO dao = new EventDAO();
        List<Event> events = dao.getAllEvents();

        Map<String, Integer> participantCounts = new HashMap<>();

        for (Event event : events) {
            int count = dao.getTotalParticipant(event.getEventID());
            participantCounts.put(event.getEventID(), count);
        }
        request.setAttribute("participantCounts", participantCounts);
        
        // Debugging: Print event count
        System.out.println("Number of events fetched: " + (eventList != null ? eventList.size() : "null"));
        
        if (eventList != null && !eventList.isEmpty()) {
            // Set the event list as an attribute to be used in JSP
            request.setAttribute("eventList", eventList);
        } else {
            request.setAttribute("errorMessage", "No events available.");
        }

        // Forward to the browse event page to display the event list
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/browse-event.jsp");
        dispatcher.forward(request, response);
    }
    
    // Handles payment processing
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String eventID = request.getParameter("eventID");
        String registrationID = request.getParameter("registrationID");
        Part receipt = request.getPart("receipt"); // Get uploaded file

        if (eventID == null || registrationID == null || receipt == null) {
        	session.setAttribute("registrationStatus", "Payment failed. Please try again.");
            response.sendRedirect("BrowseEventServlet");
            return;
        }
      

        // Simulating payment confirmation
        System.out.println("Payment confirmed for Registration ID: " + registrationID);

        // Store confirmation message in session
        session.setAttribute("registrationStatus", "Registration successful!");

        // Redirect to Browse Event page
        response.sendRedirect("BrowseEventServlet");
    }

    
}
