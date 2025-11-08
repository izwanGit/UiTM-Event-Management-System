<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.FeedbackReport" %>
<%
    String eventID = (String) request.getAttribute("eventID");
    List<FeedbackReport> feedbackList = (List<FeedbackReport>) request.getAttribute("feedbackList");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Feedback</title>
    <link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />
    
    <!-- DaisyUI and TailwindCSS -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Include jsPDF Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</head>
<body class="bg-base-200">

    <!-- Header Section -->
    <header class="bg-primary text-primary-content p-4 flex items-center justify-between">
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png" alt="UiTM Perak Logo" class="h-16">
        <h1 class="text-lg font-bold text-center flex-grow">View Feedback</h1>
        <nav class="flex gap-2">
            <a href="profile.jsp" class="btn btn-sm btn-ghost">Profile</a> 
            <a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
        </nav>
    </header>

    <!-- Feedback Section -->
    <div class="container mx-auto p-6 mt-6">
        <h2 class="text-3xl font-bold mb-6 text-center">Feedback for Event ID: <%= eventID %></h2>

        <div class="flex flex-wrap gap-6 justify-center">
            <% if (feedbackList != null && !feedbackList.isEmpty()) { 
                for (FeedbackReport feedback : feedbackList) { 
                    int rating = feedback.getRating();
            %>
                    <!-- Feedback Card -->
                    <div class="card w-96 bg-white shadow-lg border border-gray-300">
                        <div class="card-body p-6">
                            <h3 class="text-xl font-semibold text-gray-700">Rating</h3>
                            <div class="rating">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <input type="radio" name="rating-<%= feedback.hashCode() %>" class="mask mask-star-2 bg-yellow-400" <% if (i == rating) { %> checked <% } %> disabled />
                                <% } %>
                            </div>
                            <p class="text-gray-600 mt-3"><%= feedback.getComment() %></p>
                        </div>
                    </div>
            <% } } else { %>
                <p class="text-center text-error text-lg">No feedback available for this event.</p>
            <% } %>
        </div>

        <!-- Buttons -->
        <div class="mt-6 flex justify-center gap-4">
            <a href="profile.jsp" class="btn btn-secondary text-white hover:bg-secondary">Back to Profile</a>
            <button id="generatePdfBtn" class="btn btn-success text-white hover:bg-success">Generate Report</button>
        </div>
    </div>

    <!-- JavaScript to Generate PDF -->
    <script>
    document.getElementById('generatePdfBtn').addEventListener('click', function () {
        // Initialize jsPDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Add UiTM Logo
        const img = new Image();
        img.src = '../../assets/images/uitm.png'; // UiTM logo URL
        img.onload = function () {
            doc.addImage(img, 'PNG', 10, 10, 30, 30); // Add logo at top-left corner

            // Add Title
            doc.setFontSize(18);
            doc.setFont('helvetica', 'bold');
            doc.setTextColor(0, 0, 0); // Black color
            doc.text("UiTM Event Feedback Report", 50, 20);

            // Add Event ID
            doc.setFontSize(14);
            doc.text(`Event ID: <%= eventID %>`, 50, 30);

            // Add Table Headers
            doc.setFontSize(12);
            doc.setFillColor(200, 200, 200); // Light gray background for headers
            doc.rect(10, 50, 190, 10, 'F'); // Header background
            doc.setTextColor(0, 0, 0); // Black text
            doc.text("Rating", 15, 55);
            doc.text("Comment", 60, 55);

            // Add Feedback Data
            let y = 65; // Starting Y position for feedback data
            <% if (feedbackList != null && !feedbackList.isEmpty()) { 
                for (FeedbackReport feedback : feedbackList) { %>
                    doc.text("<%= feedback.getRating() %>", 15, y);
                    doc.text("<%= feedback.getComment() %>", 60, y);
                    y += 10; // Move down for the next entry
                <% }
            } else { %>
                doc.text("No feedback available for this event.", 15, y);
            <% } %>

            // Footer with copyright and additional info
            doc.setFontSize(10);
            doc.setTextColor(150, 150, 150);  // Gray color for footer
            doc.text("UiTM Event Management System", 10, 270); // Name of the system
            doc.text("Copyright 2025", 10, 275); // Copyright text
            doc.text("For internal use only.", 10, 280); // Add any other info you want

            // Save the PDF
            doc.save("feedback_report_event_<%= eventID %>.pdf");
        };
    });
</script>


</body>
</html>