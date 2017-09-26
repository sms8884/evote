/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.android.gcm.server.Message;
import com.google.android.gcm.server.MulticastResult;
import com.google.android.gcm.server.Sender;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.domain.GcmInfo;
import com.jaha.evote.domain.PushSendInfo;
import com.jaha.evote.domain.common.CodeDetail;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.mapper.GcmMapper;
import com.jaha.evote.mapper.common.CodeMapper;

/**
 * <pre>
 * Class Name : GcmService.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 21.     jjpark      Generation
 * 2016. 12. 15.    jjpark      pushType 추가
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 21.
 * @version 1.0
 */
@Service
public class GcmService extends BaseService {

    @Autowired
    private GcmMapper gcmMapper;

    @Autowired
    private CodeMapper codeMapper;

    @Autowired
    private Messages messages;

    @Value("${gcm.server.key}")
    private String gcmServerKey;

    @Value("${gcm.send.size}")
    private String gcmSendSize;

    @Value("${service.site.url}")
    private String serviceSiteUrl;

    /**
     * 푸시 전송
     * 
     * @param gcmInfo
     * @param pushKeyList
     */
    @Transactional(propagation = Propagation.SUPPORTS)
    public void send(GcmInfo gcmInfo, List<String> pushKeyList, String pushType) {

        if (gcmInfo != null && pushKeyList != null && !pushKeyList.isEmpty()) {

            Sender sender = new Sender(gcmServerKey); // 서버 API Key 입력

            String pushTitle = messages.getMessage("push.title");
            String pushValue = gcmInfo.getPushMessage();
            String pushAction = getReturnUrl(gcmInfo);

            Message.Builder builders = new Message.Builder();
            builders.addData("title", pushTitle);
            builders.addData("value", pushValue);
            builders.addData("action", pushAction);
            builders.addData("push_type", pushType);

            Message message = builders.build();

            MulticastResult multiResult;

            int sendSize = NumberUtils.toInt(gcmSendSize, 1000);  // 전송 당 key size
            int fromIndex = 0;
            int toIndex = 0;

            int totalCnt = pushKeyList.size();
            int successCnt = 0;
            int failureCnt = 0;

            for (int i = 0; i < pushKeyList.size() / sendSize + 1; i++) {

                fromIndex = sendSize * i;

                if (i < pushKeyList.size() / sendSize) {
                    toIndex = sendSize * (i + 1);
                } else {
                    toIndex = pushKeyList.size();
                }

                try {
                    multiResult = sender.send(message, pushKeyList.subList(fromIndex, toIndex), 5);
                    logger.debug("### GCM SEND SUCCESS :: [{}]", multiResult.getSuccess());
                    logger.debug("### GCM SEND FAILURE :: [{}]", multiResult.getFailure());

                    successCnt += multiResult.getSuccess();
                    failureCnt += multiResult.getFailure();

                } catch (IOException e) {
                    // 에러 발생 시 count 맞지 않을 수 있음...
                    logger.error("### GCM SEND ERROR :: [{}]", e.getMessage());
                }

            }

            //=================================================================
            // INSERT GCM SEND HIST
            //=================================================================

            PushSendInfo pushSendInfo = new PushSendInfo();

            pushSendInfo.setPushType(gcmInfo.getGcmType());
            pushSendInfo.setTitle(pushTitle);
            pushSendInfo.setMessage(pushValue);
            pushSendInfo.setAction(pushAction);
            pushSendInfo.setTotalCnt(totalCnt);
            pushSendInfo.setSuccessCnt(successCnt);
            pushSendInfo.setFailureCnt(failureCnt);
            pushSendInfo.setRegUser(getUserSeq());  // Schedule 에서 호출했을 경우 default 0L 로 셋팅

            gcmMapper.insertPushSendHist(pushSendInfo);

        }

    }

    private String getReturnUrl(GcmInfo gcmInfo) {

        if (gcmInfo != null) {

            CodeDetail codeDetail = codeMapper.selectCodeInfo(CodeType.CODE_GROUP_GCM_TYPE.getCode(), gcmInfo.getGcmType().name());

            String strReturnUrl = serviceSiteUrl + codeDetail.getData1();

            if (gcmInfo.getArgs() == null) {
                return strReturnUrl;
            } else {
                MessageFormat form = new MessageFormat(strReturnUrl);
                return form.format(gcmInfo.getArgs());
            }
        } else {

            logger.info("### GCM INFO is NULL");

        }

        return null;
    }

}
