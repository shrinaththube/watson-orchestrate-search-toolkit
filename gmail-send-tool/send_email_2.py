import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission
from ibm_watsonx_orchestrate.run import connections
from ibm_watsonx_orchestrate.agent_builder.connections import ConnectionType

@tool(
    name="send_gmail_2", 
    description="Send email using gmail",
    permission=ToolPermission.ADMIN,  # Changed from WRITE to ADMIN
    expected_credentials=[{
        "app_id": "gmail_credentials", 
        "type": ConnectionType.KEY_VALUE
    }]
)
def send_gmail_2(recipient_email: str, subject: str, body: str) -> str:
    """
    Sends an email using Gmail SMTP server.
    
    Args:
        recipient_email: The recipient's email address
        subject: Email subject line
        body: Email body content
        
    Returns:
        str: Success or error message
    """
    try:
        # Access credentials from the key_value connection
        conn = connections.key_value("gmail_credentials")
        sender_email = conn["GMAIL_USER"]
        app_password = conn["GMAIL_APP_PASSWORD"]
        
        # Create the email
        msg = MIMEMultipart()
        msg["From"] = sender_email
        msg["To"] = recipient_email
        msg["Subject"] = subject
        msg.attach(MIMEText(body, "plain"))
        
        # Connect to Gmail SMTP server
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.starttls()
        server.login(sender_email, app_password)
        
        # Send email
        server.sendmail(sender_email, recipient_email, msg.as_string())
        server.quit()
        
        return "✅ Email sent successfully!"
    
    except Exception as e:
        return f"❌ Failed to send email: {str(e)}"
