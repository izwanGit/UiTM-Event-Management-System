package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import model.Event;

import java.io.IOException;
import java.util.List;

import dao.EventDAO;

public class DeleteEventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
    	HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); // Redirect if session expired
            return;
        }
        String organiserId = (String) session.getAttribute("userId");        
        
        EventDAO dao = new EventDAO();
        List<Event> events = EventDAO.eventList(organiserId);

        Map<String, Integer> participantCounts = new HashMap<>();

        for (Event event : events) {
            int count = dao.getTotalParticipant(event.getEventID());
            participantCounts.put(event.getEventID(), count);
        }
        request.setAttribute("participantCounts", participantCounts);
        request.setAttribute("organisedEvents", events);

        // Forward to JSP
        request.getRequestDispatcher("/views/organizer/delete-events.jsp").forward(request, response);	}


}
