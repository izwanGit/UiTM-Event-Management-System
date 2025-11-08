<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.Organiser, dao.OrganiserDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Post Caption</title>
    <link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />
    
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-base-200 min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-primary text-primary-content p-4 flex items-center justify-between">
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png" alt="UiTM Perak Logo" class="h-16">
        <h1 class="text-lg font-bold text-center flex-grow">Edit Post Caption</h1>
        <a href="profile.jsp" class="btn btn-sm btn-ghost">Back to Profile</a>
        <a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
    </header>

    <!-- Main Content -->
    <div class="container mx-auto p-4 flex-grow">
        <h2 class="text-xl font-semibold mb-4">Edit Your Post Caption</h2>

        <%
            // Fetch the organiser ID from the session
            String organiserID = "ORG001"; // Replace with actual session logic

            // Fetch organiser details
            OrganiserDAO organiserDAO = new OrganiserDAO();
            Organiser organiser = organiserDAO.getOrganiserById(organiserID);

            if (organiser == null) {
                response.sendRedirect("error.jsp?message=Organiser not found");
                return;
            }
        %>

        <!-- Form to edit post caption -->
        <form id="editPostCaptionForm" action="EditPostCaptionServlet" method="POST">
            <!-- Post Caption -->
            <div class="mb-4">
                <label for="postCaption" class="label">Post Caption</label>
                <textarea id="postCaption" name="postCaption" class="textarea textarea-bordered w-full" 
                          placeholder="Enter your post caption" required><%= organiser.getPostCaption() %></textarea>
            </div>

            <!-- Organiser ID (hidden field) -->
            <input type="hidden" id="organiserID" name="organiserID" value="<%= organiser.getOrganiserID() %>">

            <div class="flex justify-between">
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <a href="profile.jsp" class="btn btn-ghost">Cancel</a>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <footer class="bg-base-300 text-base-content p-4 text-center">
        &copy; 2024 UiTM Event Management System
    </footer>
</body>
</html>