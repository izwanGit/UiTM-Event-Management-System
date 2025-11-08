package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Event;
import dao.EventDAO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/UpdateEventServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,         // 10MB
    maxRequestSize = 1024 * 1024 * 50         // 50MB
)
public class EditEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String POSTER_RELATIVE_PATH = "assets/images/posters/"; // Relative path for poster storage

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            // If user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            // Retrieve form parameters
            String eventID = request.getParameter("eventID");
            String organiserID = request.getParameter("organiserID");
            String eventName = request.getParameter("eventName");
            Date eventDate = Date.valueOf(request.getParameter("eventDate"));
            Time eventTime = Time.valueOf(request.getParameter("eventTime") + ":00"); // Append seconds
            String eventLocation = request.getParameter("eventLocation");
            double eventPrice = Double.parseDouble(request.getParameter("eventPrice"));
            String eventStatus = request.getParameter("eventStatus");
            int maxParticipant = Integer.parseInt(request.getParameter("maxParticipant"));
            String description = request.getParameter("description");

            // Create the event model object
            Event event = new Event(eventID, organiserID, eventName, eventDate, eventTime, eventLocation, eventPrice, eventStatus, maxParticipant, description);

            // Update the event in the database
            boolean isUpdated = EventDAO.editEvent(event);

            if (!isUpdated) {
                throw new Exception("Failed to update event.");
            }

            // Handle poster upload
            Part filePart = request.getPart("poster");
            if (filePart != null && filePart.getSize() > 0) {
                savePoster(filePart, eventID);
            }

            // Redirect to profile or success page with eventID
         // After successfully editing an event:
            request.setAttribute("toastMessage", "Event edited successfully!");
            request.setAttribute("toastType", "info"); // or "success", "error", etc.
            request.getRequestDispatcher("profile.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("toastMessage", "Error: Failed to edit event.");
            request.setAttribute("toastType", "error");
            request.getRequestDispatcher("profile.jsp").forward(request, response);

        }
    }

    private void savePoster(Part filePart, String eventID) throws IOException {
        // Define the absolute save path on the server
        String savePath = getServletContext().getRealPath("/") + POSTER_RELATIVE_PATH;

        // Debug: Print the save path
        System.out.println("Save Path: " + savePath);

        // Create the directory if it doesn't exist
        File saveDir = new File(savePath);
        if (!saveDir.exists() && !saveDir.mkdirs()) {
            throw new IOException("Failed to create directory: " + savePath);
        }

        // Save the file with eventID as its name (using PNG extension)
        String filePath = savePath + eventID + ".jpg";

        // Debug: Print the file path
        System.out.println("File Path: " + filePath);

        // Delete the existing file if it exists
        File existingFile = new File(filePath);
        if (existingFile.exists()) {
            if (!existingFile.delete()) {
                throw new IOException("Failed to delete existing file: " + filePath);
            }
        }

        // Save the new file
        try (InputStream input = filePart.getInputStream();
             FileOutputStream output = new FileOutputStream(filePath)) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
            System.out.println("File saved successfully: " + filePath);
        } catch (IOException e) {
            System.out.println("Error saving file: " + e.getMessage());
            throw e;
        }
    }
}