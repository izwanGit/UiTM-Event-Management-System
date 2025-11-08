package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Event;
import dao.EventDAO;
import dao.RegistrationDAO;

import java.io.IOException;
import java.io.PrintWriter;
import org.json.JSONObject;

public class DeleteEventActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); // Redirect if session expired
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        String eventId = request.getParameter("eventId");
        System.out.println("Deleting event: " + eventId);

        if (eventId == null || eventId.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid event ID.");
            out.print(jsonResponse);
            return;
        }

        EventDAO eventDAO = new EventDAO();
        RegistrationDAO registrationDAO = new RegistrationDAO();

        try {
            boolean hasParticipants = registrationDAO.hasParticipants(eventId);
            if (hasParticipants) {
                jsonResponse.put("hasParticipants", true);
                jsonResponse.put("message", "Cannot delete event with active participants.");
            } else {
                boolean status = eventDAO.deleteEvent(eventId);
                System.out.println(eventId);
                System.out.println(status);
                if (status) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Event deleted successfully!");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Cannot delete event that will start within 48 hours");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();  // Log the stack trace for debugging
            jsonResponse.put("success", false);
            jsonResponse.put("message", "An error occurred while processing the request.");
        }

        out.print(jsonResponse);
        out.flush();
    }
}