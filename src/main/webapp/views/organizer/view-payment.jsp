<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List,java.text.SimpleDateFormat, java.util.Date, model.PaymentReport"%>

<%
// Retrieve the payments list from the request attribute
List<PaymentReport> payments = (List<PaymentReport>) request.getAttribute("payments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Payment</title>
<link rel="shortcut icon" type="image/x-icon"
	href="/UiTM_Event_Management_System/assets/images/uitm.png" />

<!-- DaisyUI and TailwindCSS -->
<link
	href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css"
	rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>

<!-- Include jsPDF Library -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</head>
<body class="bg-base-200">

	<!-- Header Section -->
	<header
		class="bg-primary text-primary-content p-4 flex items-center justify-between">
		<img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png"
			alt="UiTM Perak Logo" class="h-16">
		<h1 class="text-lg font-bold text-center flex-grow">View Payment</h1>
		<nav class="flex gap-2">
			<a href="profile.jsp" class="btn btn-sm btn-ghost">Profile</a> <a
				href="/UiTM_Event_Management_System/LogoutServlet"
				class="btn btn-sm btn-error">Logout</a>
		</nav>
	</header>

	<!-- Payment Details Section -->
	<div class="container mx-auto p-6 mt-6">
		<h2 class="text-3xl font-bold mb-6 text-center">Payments Report
			for Selected Event</h2>

		<%
		if (payments != null && !payments.isEmpty()) {
			for (PaymentReport payment : payments) {
		%>

		<div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
			<!-- Payment ID Card -->
			<div class="card bg-white shadow-lg border border-gray-300">
				<div class="card-body text-center p-4">
					<h3 class="text-lg font-semibold text-gray-700">Payment ID</h3>
					<p class="text-xl font-bold text-primary"><%=payment.getPaymentID()%></p>
				</div>
			</div>

			<!-- Date Generate Card -->
			<div class="card bg-white shadow-lg border border-gray-300">
				<div class="card-body text-center p-4">
					<h3 class="text-lg font-semibold text-gray-700">Date Generated</h3>
					<%
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					String formattedDate = sdf.format(payment.getDateGenerate());
					%>
					<p class="text-xl font-bold text-primary"><%=formattedDate%></p>
				</div>
			</div>

			<!-- Time Generate Card -->
			<div class="card bg-white shadow-lg border border-gray-300">
				<div class="card-body text-center p-4">
					<h3 class="text-lg font-semibold text-gray-700">Time Generated</h3>
					<p class="text-xl font-bold text-primary"><%=payment.getTimeGenerate()%></p>
				</div>
			</div>

			<!-- Total Amount Card -->
			<div class="card bg-white shadow-lg border border-gray-300">
				<div class="card-body text-center p-4">
					<h3 class="text-lg font-semibold text-gray-700">Total Amount
						(RM)</h3>
					<p class="text-2xl font-bold text-green-600">
						RM
						<%=String.format("%.2f", payment.getTotalAmount())%></p>
				</div>
			</div>
		</div>

		<%
		}
		} else {
		%>
		<p class="text-center text-error text-lg">No payments found.</p>
		<%
		}
		%>

		<!-- Buttons -->
		<div class="mt-6 flex justify-center gap-4">
			<a href="profile.jsp"
				class="btn btn-secondary text-white hover:bg-secondary">Back to Profile</a>
			<button id="generatePdfBtn"
				class="btn btn-success text-white hover:bg-success">Generate
				Report</button>
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
                doc.text("UiTM Payment Report", 50, 20);

                // Add Table Headers
                doc.setFontSize(12);
                doc.setFillColor(200, 200, 200); // Light gray background for headers
                doc.rect(10, 50, 40, 10, 'F'); // Header background for Payment ID
                doc.rect(50, 50, 40, 10, 'F'); // Header background for Date Generated
                doc.rect(90, 50, 40, 10, 'F'); // Header background for Time Generated
                doc.rect(130, 50, 40, 10, 'F'); // Header background for Total Amount

                doc.setTextColor(0, 0, 0); // Black text for headers
                doc.text("Payment ID", 15, 55);
                doc.text("Date Generated", 55, 55);
                doc.text("Time Generated", 95, 55);
                doc.text("Total Amount (RM)", 135, 55);

                // Add Payment Data
                let y = 65; // Starting Y position for payment data
                <%if (payments != null && !payments.isEmpty()) {
	for (PaymentReport payment : payments) {%>
	<%SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String formattedDate = sdf.format(payment.getDateGenerate());%>
                        doc.text("<%=payment.getPaymentID()%>", 15, y);
                        doc.text("<%= formattedDate %>", 55, y);
                        doc.text("<%=payment.getTimeGenerate()%>", 95, y);
                        doc.text("RM <%=String.format("%.2f", payment.getTotalAmount())%>", 135, y);
                        y += 10; // Move down for the next entry
                    <%}
} else {%>
                    doc.text("No payments found.", 15, y);
                <%}%>

                doc.setFontSize(10);
                doc.setTextColor(150, 150, 150);  // Gray color for footer
                doc.text("UiTM Event Management System", 10, 270); // Name of the system
                doc.text("Copyright 2025", 10, 275); // Copyright text
                doc.text("For internal use only.", 10, 280); // Add any other info you want
                // Save the PDF
                doc.save("payment_report.pdf");
            };
        });
    </script>

	<!-- Footer -->
	<footer class="bg-base-300 text-base-content p-4 text-center">
		&copy; 2024 UiTM Event Management System </footer>

</body>
</html>
