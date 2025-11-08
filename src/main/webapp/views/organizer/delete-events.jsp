<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Event" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Event</title>
    <link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />
    
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-base-200 min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-primary text-primary-content p-4 flex items-center justify-between">
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png" alt="UiTM Perak Logo" class="h-16">
        <h1 class="text-lg font-bold text-center flex-grow">Delete Event</h1>
		<nav class="flex gap-2">
			<a href="profile.jsp" class="btn btn-sm btn-ghost">Profile</a> 
			<a href="/UiTM_Event_Management_System/LogoutServlet"
				class="btn btn-sm btn-error">Logout</a>
		</nav>    </header>

    <!-- Main Content -->
    <div class="container mx-auto p-4 flex-grow">
        <!-- Event List Section -->
        <div class="mb-6">
            <h2 class="text-lg font-semibold mb-2">Your Events</h2>

            <!-- Event Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <%
                Map<String, Integer> participantCounts = (Map<String, Integer>) request.getAttribute("participantCounts");
                List<Event> events = (List<Event>) request.getAttribute("organisedEvents");
                if (events != null && !events.isEmpty()) {
                    for (int i = 0; i < events.size(); i++) {
                        request.setAttribute("event", events.get(i)); // Set the bean for <jsp:useBean>
                        int participantCount = participantCounts.getOrDefault(events.get(i).getEventID(), 0);
                %>
                <jsp:useBean id="event" class="model.Event" scope="request" />
                
                <!-- Event Card -->
                <div class="card bg-base-100 shadow-xl">
                    <figure>
                        <img src="../../assets/images/posters/<jsp:getProperty name="event" property="eventID" />.jpg"
                            alt="<jsp:getProperty name="event" property="eventName" />" class="h-48 object-cover w-full">
                    </figure>
                    <div class="card-body">
                        <h2 class="card-title"><jsp:getProperty name="event" property="eventName" /></h2>
                        <p>Location: <jsp:getProperty name="event" property="eventLocation" /></p>
                        <p>Date: <jsp:getProperty name="event" property="eventDate" /></p>
                        <p>Time: <jsp:getProperty name="event" property="eventTime" /></p>
                        <div class="flex justify-between items-center">
                            <p class="text-sm text-secondary"><%= participantCount %>/<jsp:getProperty name="event" property="maxParticipant" /> Participants</p>
                            <button class="btn btn-error" onclick="confirmDeletion('<jsp:getProperty name="event" property="eventID" />')">Delete</button>
                        </div>
                    </div>
                </div>

                <%
                    } 
                }
                %>
            </div>

            <p id="errorMessage" class="text-error mt-2 hidden">Cannot delete event with active participants.</p>
        </div>

        <!-- Confirmation Dialog -->
        <div id="confirmationModal" class="fixed top-0 left-0 w-full h-full bg-gray-900 bg-opacity-50 flex items-center justify-center hidden">
            <div class="bg-white p-6 rounded shadow-lg">
                <h3 class="text-lg font-bold">Confirm Deletion</h3>
                <p>Are you sure you want to delete this event?</p>
                <div class="mt-4 flex justify-end space-x-2">
                    <button id="confirmDeleteButton" class="btn btn-error">Yes, Delete</button>
                    <button class="btn" onclick="cancelDeletion()">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-base-300 text-base-content p-4 text-center">
        &copy; 2024 UiTM Event Management System
    </footer>

    <script>
    document.addEventListener("DOMContentLoaded", function () {
        console.log("Page loaded and script initialized");

        const errorMessage = document.getElementById("errorMessage");
        const confirmationModal = document.getElementById("confirmationModal");
        const confirmDeleteButton = document.getElementById("confirmDeleteButton");
        let eventToDelete = "";

        // Function to show confirmation modal
        window.confirmDeletion = function (eventId) {
            console.log("Confirm deletion triggered for event ID:", eventId);
            eventToDelete = eventId;

            // Show the confirmation modal
            confirmationModal.classList.remove("hidden");
        };

        // Function to delete event
        function deleteEvent() {
            console.log("Deleting event:", eventToDelete);
            if (!eventToDelete) {
                console.error("No event ID to delete.");
                return;
            }

            fetch("DeleteEventActionServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "eventId=" + encodeURIComponent(eventToDelete),
            })
                .then(response => response.text())
                .then(text => {
                    console.log("Response text:", text);
                    try {
                        const data = JSON.parse(text);
                        console.log("Participant check response:", data);
                        if (data.success) {
                            alert("Success: " + data.message);
                            // Reload the page after successful deletion
                            setTimeout(() => location.reload(), 1000);
                        } else {
                            alert("Error: " + data.message);
                        }
                    } catch (error) {
                        console.error("Error parsing JSON:", error);
                        console.error("Response text was:", text);
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                })
                .finally(() => {
                    // Hide the confirmation modal
                    confirmationModal.classList.add("hidden");
                });
        }

        // Attach deleteEvent function to the confirm button
        confirmDeleteButton.addEventListener("click", deleteEvent);

        // Function to cancel deletion (hide modal)
        window.cancelDeletion = function () {
            console.log("Cancel deletion clicked");
            confirmationModal.classList.add("hidden");
        };
    });
    </script>
</body>
</html>