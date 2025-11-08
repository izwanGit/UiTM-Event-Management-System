package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Event;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import dao.EventDAO;
import dao.FeedbackDAO;

public class BrowseEventFilterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve filter parameters
        String status = request.getParameter("status");
        String category = request.getParameter("category"); // OrganiserID
        String searchQuery = request.getParameter("searchByName");

        EventDAO dao = new EventDAO();
        List<Event> eventList = dao.getFilteredEvents(status, category, searchQuery);

        // Get participant counts for each event
        Map<String, Integer> participantCounts = new HashMap<>();
        for (Event event : eventList) {
            int count = dao.getTotalParticipant(event.getEventID());
            participantCounts.put(event.getEventID(), count);
        }
        
      //cookie testing
        EventDAO eventDAO = new EventDAO();
        List<Event> allEvents = eventDAO.getAllEvents();

        String lastPickOrganiserID = null;
        Cookie[] cookies = request.getCookies();
        String preferredCategory = null;
        

        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("lastPick".equals(cookie.getName())) {
                    lastPickOrganiserID = cookie.getValue(); // Get the organiser ID of the last pick
                    break;
                }
            }
        }
        request.setAttribute("lastPickOrganiserID", lastPickOrganiserID);
        request.setAttribute("eventList", eventList);
        request.setAttribute("participantCounts", participantCounts);
        request.getRequestDispatcher("/views/browse-event.jsp").forward(request, response);
        
        
    }
}
