/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import javax.mail.Address;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.domain.Email;

/**
 * <pre>
 * Class Name : MailService.java
 * Description : 메일 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 20.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 20.
 * @version 1.0
 */
@Service
public class MailService extends BaseService {

    @Autowired
    protected JavaMailSender mailSender;

    @Value("${mail.username}")
    private String defaultSenderEmail;

    /**
     * 메일 발송(HTML)
     * 
     * @param email
     */
    public void sendEmail(Email email) {

        try {

            if (email == null) {
                logger.info("### mail info is null");
            } else {

                MimeMessage message = mailSender.createMimeMessage();
                Address sender = null;

                if (StringUtils.isEmpty(email.getSender())) {
                    sender = new InternetAddress(defaultSenderEmail);
                } else {
                    sender = new InternetAddress(email.getSender());
                }

                message.setFrom(sender);
                message.setSubject(email.getSubject());

                message.setContent(email.getContent(), "text/html; charset=utf-8");

                message.setRecipient(RecipientType.TO, new InternetAddress(email.getReciver()));

                mailSender.send(message);

            }

        } catch (Exception e) {
            logger.error("### 메일 발송 실패 ::: MailService > sendEmail : {}", e.getMessage());
        }

    }

    /**
     * 메일발송(Text)
     * 
     * @param from
     * @param to
     * @param subject
     * @param text
     */
    public void sendSimpleMail(String from, String to, String subject, String text) {
        SimpleMailMessage message = new SimpleMailMessage();

        if (StringUtils.isEmpty(from)) {
            message.setFrom(defaultSenderEmail);
        } else {
            message.setFrom(from);
        }

        message.setTo(to);
        message.setSubject(subject);
        message.setText(text);

        mailSender.send(message);
    }

}
