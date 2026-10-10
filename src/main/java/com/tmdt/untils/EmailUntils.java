package com.tmdt.untils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUntils {
    private static final String MY_EMAIL = "23130024@st.hcmuaf.edu.vn";
    private static final String MY_APP_PASSWORD = "njqv zadc nfsk abou";

    public static void sendMail(String toEmail, String subject, String content) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(MY_EMAIL, MY_APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(MY_EMAIL, "MangaNe Support"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));


        message.setSubject(subject);


        message.setContent(content, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}
