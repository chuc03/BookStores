package vn.bookstore.util;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import jakarta.servlet.ServletContext;

public class EmailUtil {

    public static void sendHtmlEmail(ServletContext ctx, String to, String subject, String htmlBody) throws MessagingException {
        String host = ctx.getInitParameter("smtp.host");
        String port = ctx.getInitParameter("smtp.port");
        final String user = ctx.getInitParameter("smtp.user");
        final String pass = ctx.getInitParameter("smtp.pass");
        String from = ctx.getInitParameter("mail.from");

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject, "UTF-8");
        message.setContent(htmlBody, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}
