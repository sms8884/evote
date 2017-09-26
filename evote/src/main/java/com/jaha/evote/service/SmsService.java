package com.jaha.evote.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.RandomKeys;
import com.jaha.evote.mapper.SmsMapper;

/**
 * <pre>
 * Class Name : SmsService.java
 * Description : SMS 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Service
public class SmsService extends BaseService {

    @Autowired
    private SmsMapper smsMapper;

    @Autowired
    private Messages messages;

    @Value("${sms.send.number}")
    private String sendNumber;

    @Value("${sms.auth.limit.time}")
    private String authLimitTime;

    @Value("${sms.auth.master.code}")
    private String smsAuthMasterCode;

    @Autowired
    private Environment env;

    /**
     * 인증번호 전송
     * 
     * @param destNumber
     * @return
     */
    @Transactional
    public String sendMessage(String destNumber) {

        String code = String.format("%06d", (int) (Math.random() * 1000000));
        String key = RandomKeys.make(32);

        // [참여예산정책제안] 본인확인 인증번호는 [{0}]입니다.
        String msg = messages.getMessage("message.common.sms.001", code);

        msg = msg.replace("\n", "\r\n");
        String uniqueKey = System.currentTimeMillis() + RandomKeys.make(6);
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("uniqueKey", uniqueKey);
        param.put("destNumber", destNumber);
        param.put("sendNumber", sendNumber);
        param.put("msg", msg);
        param.put("code", code);
        param.put("key", key);

        smsMapper.sendMsgNow(param);
        smsMapper.insertMessageSendHist(uniqueKey);

        return key;
    }

    //    @Deprecated
    //    @Transactional
    //    public boolean sendMsgNow(String destNumber, String msg, String code, String key) {
    //        try {
    //            msg = msg.replace("\n", "\r\n");
    //            String uniqueKey = System.currentTimeMillis() + RandomKeys.make(6);
    //            HashMap<String, Object> param = new HashMap<String, Object>();
    //            param.put("uniqueKey", uniqueKey);
    //            param.put("destNumber", destNumber);
    //            param.put("sendNumber", sendNumber);
    //            param.put("msg", msg);
    //            param.put("code", code);
    //            param.put("key", key);
    //
    //            smsMapper.sendMsgNow(param);
    //            smsMapper.insertMessageSendHist(uniqueKey);
    //
    //            return true;
    //
    //        } catch (Exception e) {
    //            logger.error(e.getMessage());
    //        }
    //        return false;
    //    }

    /**
     * 인증번호 검증
     * 
     * @param code
     * @param key
     * @return
     */
    public boolean checkAuth(String code, String key, String phone) {

        // local, dev > auth code bypass
        if (isDevAuthMasterCode(code)) {
            return true;
        }

        Integer intAuthLimitTime = 0;
        try {
            intAuthLimitTime = Integer.parseInt(authLimitTime);
        } catch (NumberFormatException e) {
            logger.error(e.getMessage());
            intAuthLimitTime = 300;
        }

        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("code", code);
        param.put("key", key);
        param.put("phone", phone);
        param.put("intAuthLimitTime", -intAuthLimitTime);
        HashMap<String, Object> check = smsMapper.checkAuth(param);
        return check != null && !check.isEmpty();
    }

    /**
     * 인증번호 검증(대상 전화번호 포함)
     * 
     * @param code
     * @param key
     * @return
     */
    public HashMap<String, String> checkAuthWithDestPhone(String code, String key, String phone) {
        HashMap<String, Object> param = new HashMap<String, Object>();

        // local, dev > auth code bypass
        if (isDevAuthMasterCode(code)) {
            HashMap<String, String> result = new HashMap<>();
            result.put("DEST_PHONE", phone);
            return result;
        }

        param.put("code", code);
        param.put("key", key);
        param.put("phone", phone);
        return smsMapper.checkAuthWithDestPhone(param);
    }


    /**
     * 인증번호 우회 로직 - 로컬, 개발만 설정
     * 
     * @param code
     * @return
     */
    private boolean isDevAuthMasterCode(String code) {

        /*
         * local, dev > auth code bypass
         * 상용 profile 설정 금지!!!
         */
        if (env.acceptsProfiles("loc", "dev", "staging")) {
            if (smsAuthMasterCode != null && smsAuthMasterCode.equals(code)) {

                logger.info("#################### auth code bypass ####################");
                logger.info("### smsAuthMasterCode [{}], authCode [{}]", smsAuthMasterCode, code);
                logger.info("#################### auth code bypass ####################");

                if (smsAuthMasterCode.equals(code)) {
                    return true;
                }
            }
        }

        return false;
    }

}
