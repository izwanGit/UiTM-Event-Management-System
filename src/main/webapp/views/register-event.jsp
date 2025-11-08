<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Registration</title>
    <link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />
    
    <!-- DaisyUI and TailwindCSS -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-base-200">
    <header class="bg-primary text-primary-content p-4 flex items-center justify-between">
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png" alt="UiTM Perak Logo" class="h-16">
        <h1 class="text-lg font-bold text-center flex-grow">Event Registration</h1>
		<nav class="flex gap-2">
			<a href="/UiTM_Event_Management_System/BrowseEventServlet" class="btn btn-sm btn-ghost">Browse Events</a> 
			<a href="/UiTM_Event_Management_System/TrackRegisteredServlet" class="btn btn-sm btn-ghost">Track Registration</a> 
			<a href="/UiTM_Event_Management_System/EventFeedbackServlet" class="btn btn-sm btn-ghost">Give Feedback</a> 
			<a href="/UiTM_Event_Management_System/CancelRegistrationServlet" class="btn btn-sm btn-ghost">Cancel Registration</a> 
			<a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
		</nav>
    </header>

    <div class="container mx-auto p-4">
        <div class="card bg-base-100 shadow-xl max-w-lg mx-auto">
            <div class="card-body">
                <h2 class="card-title text-center text-2xl">Register for the Event</h2>
                <form action="${pageContext.request.contextPath}/RegisterEventServlet" method="POST">
                    <input type="hidden" name="eventID" value="${eventID}"> <!-- Event ID -->
                    
                    <label for="student-id" class="label">Student ID</label>
                    <input type="text" id="student-id" name="student_id" class="input input-bordered w-full" value="${participant.participantID}" readonly required>

                    <label for="name" class="label mt-4">Name</label>
                    <input type="text" id="name" name="name" class="input input-bordered w-full" value="${participant.participantName}" readonly required>

                    <label for="phone" class="label mt-4">Phone Number</label>
    				<input type="tel" id="phone" name="phone" class="input input-bordered w-full" value="${participant.participantNoTel}" placeholder="Enter your phone number" required>	
    				<small id="phoneError" class="text-red-500 hidden">Phone number must be 10 or 11 digits.</small>
    				
    				<script>
    				document.getElementById("phone").addEventListener("input", function () {
    				    this.value = this.value.replace(/\D/g, ""); // Remove non-numeric characters

    				    const phoneError = document.getElementById("phoneError");

    				    if (this.value.length < 10 || this.value.length > 11) {
    				        phoneError.classList.remove("hidden"); // Show error message
    				    } else {
    				        phoneError.classList.add("hidden"); // Hide error message
    				    }
    				});
					</script>

                    <label for="email" class="label mt-4">Email</label>
    				<input type="email" id="email" name="email" class="input input-bordered w-full" value="${participant.participantEmail}" placeholder="Enter your email address" required>

                    <button type="submit" class="btn btn-primary w-full mt-6">Register</button>
                </form>
            </div>
        </div>
    </div>
    
   <script>
        // Client-side form validation
        document.getElementById("registrationForm").addEventListener("submit", function(event) {
            var phone = document.getElementById("phone").value;
            var email = document.getElementById("email").value;

            // Check phone number
            if (!phone.match(/^[0-9]{10,11}$/)) {
                event.preventDefault(); // Prevent form submission
                alert("Please fill in mandatory fields correctly");
                return false; // Stops further processing
            }

            // Check email (basic validation and max length)
            if (!email || !email.match(/^[^@]+@[^@]+\.[^@]+$/) || email.length > 50) {
                event.preventDefault(); // Prevent form submission
                alert("Please fill in mandatory fields correctly");
                return false; // Stops further processing
            }
        });
    </script>
    
</body>
</html>
