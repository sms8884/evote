/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.scheduler;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.jaha.evote.common.util.DateUtils;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.domain.Config;
import com.jaha.evote.domain.GcmInfo;
import com.jaha.evote.domain.VoteMaster;
import com.jaha.evote.domain.type.ConfigType;
import com.jaha.evote.domain.type.GcmType;
import com.jaha.evote.domain.type.UserStatus;
import com.jaha.evote.service.CommitteeService;
import com.jaha.evote.service.ConfigService;
import com.jaha.evote.service.GcmService;
import com.jaha.evote.service.VoteService;

/**
 * <pre>
 * Class Name : PushSchedule.java
 * Description : 푸시 스케줄러
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
@Component
public class PushSchedule extends BaseSchedule {

    protected final Logger logger = LoggerFactory.getLogger(getClass());

    @Autowired
    private GcmService gcmService;

    @Autowired
    private ConfigService configService;

    @Autowired
    private VoteService voteService;

    @Autowired
    private CommitteeService committeeService;

    @Autowired
    private Messages messages;

    @Value("${service.site.url}")
    private String serviceSiteUrl;

    // 0 0 * * * * : 매일 매시 시작 시점
    // */10 * * * * * : 10초 간격
    // 0 0 8-10 * * * : 매일 8,9,10시
    // 0 0/30 8-10 * * * : 매일 8:00, 8:30, 9:00, 9:30, 10:00
    // 0 0 9-17 * * MON-FRI : 주중 9시부터 17시까지
    // 0 0 0 25 12 ? : 매년 크리스마스 자정

    @Scheduled(cron = "0 0 * * * *")
    public void pushSchedule() {

        if (!isScheduleServer()) {
            logger.info("### skip pushSchedule...");
            return;
        }

        try {

            //=================================================================
            // 0. Start Schedule...
            //=================================================================

            String startTime = DateUtils.getDate();
            logger.info("##################################################");
            logger.info("### PushSchedule START [{}]", startTime);
            logger.info("###");

            //=================================================================
            // 1. 투표 시작 푸시 스케줄
            //=================================================================

            logger.info("### voteStartSchedule :: START");
            voteStartSchedule();
            logger.info("### voteStartSchedule :: END");
            logger.info("###");


            //=================================================================
            // 2. 투표 종료 푸시 스케줄
            //=================================================================

            logger.info("### voteEndSchedule :: START");
            voteEndSchedule();
            logger.info("### voteEndSchedule :: END");
            logger.info("###");


            //=================================================================
            // 3. 위원공모 시작 푸시 스케줄
            //=================================================================

            logger.info("### cmitStartSchedule :: START");
            cmitStartSchedule();
            logger.info("### cmitStartSchedule :: END");
            logger.info("###");


            //=================================================================
            // 99. End Schedule...
            //=================================================================

            String endTime = DateUtils.getDate();
            logger.info("### PushSchedule End [{}]", endTime);
            logger.info("##################################################");

        } catch (Exception e) {

            logger.error("########## pushSchedule ERROR ##########", e);

        }

    }

    private void voteStartSchedule() {

        try {

            Config config = null;
            List<String> pushDestList = null;
            GcmInfo gcmInfo = null;

            List<VoteMaster> voteStartSchedule = voteService.selectVoteStartSchedule();

            if (voteStartSchedule != null && !voteStartSchedule.isEmpty()) {

                for (VoteMaster voteMaster : voteStartSchedule) {

                    config = new Config();
                    config.setSiteCd(voteMaster.getSiteCd());
                    config.setUserStat(UserStatus.AVAILABLE);
                    config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                    config.setConfigCode(ConfigType.CONFIG_PUSH_VOTE.getCode());    // 투표알림

                    pushDestList = configService.selectPushKeyList(config);

                    if (pushDestList != null && !pushDestList.isEmpty()) {

                        gcmInfo = new GcmInfo();
                        gcmInfo.setGcmType(GcmType.VOTE_URGE);
                        // push.vote.urge=투표에 참여해주세요.\n{0}
                        gcmInfo.setPushMessage(messages.getMessage("push.vote.urge", voteMaster.getTitle()));
                        //gcmInfo.setReturnUrl(serviceSiteUrl + "/vote/vote-main");
                        gcmInfo.setArgs(null);

                        gcmService.send(gcmInfo, pushDestList, ConfigType.CONFIG_PUSH_VOTE.getCode());

                        logger.info("### voteStartSchedule :: VOTE_SEQ [{}], PUSH DEST COUNT [{}]", voteMaster.getVoteSeq(), pushDestList.size());

                    } else {
                        logger.info("### voteStartSchedule :: pushDestList is NULL");
                    }

                }

            } else {
                logger.info("### voteStartSchedule :: NULL");
            }

        } catch (Exception e) {
            logger.error("########## voteStartSchedule ERROR ##########", e);
        }

    }

    private void voteEndSchedule() {

        try {

            Config config = null;
            List<String> pushDestList = null;
            GcmInfo gcmInfo = null;

            List<VoteMaster> voteEndSchedule = voteService.selectVoteEndSchedule();

            if (voteEndSchedule != null && !voteEndSchedule.isEmpty()) {

                for (VoteMaster voteMaster : voteEndSchedule) {

                    config = new Config();
                    config.setSiteCd(voteMaster.getSiteCd());
                    config.setUserStat(UserStatus.AVAILABLE);
                    config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                    config.setConfigCode(ConfigType.CONFIG_PUSH_VOTE.getCode());    // 투표알림

                    pushDestList = configService.selectPushKeyList(config);

                    if (pushDestList != null && !pushDestList.isEmpty()) {

                        gcmInfo = new GcmInfo();
                        gcmInfo.setGcmType(GcmType.VOTE_URGE);
                        // push.vote.close=투표가 마감되었습니다.\n{0}
                        gcmInfo.setPushMessage(messages.getMessage("push.vote.close", voteMaster.getTitle()));
                        //gcmInfo.setReturnUrl(serviceSiteUrl + "/vote/vote-main");
                        gcmInfo.setArgs(null);

                        gcmService.send(gcmInfo, pushDestList, ConfigType.CONFIG_PUSH_VOTE.getCode());

                        logger.info("### voteEndSchedule :: VOTE_SEQ [{}], PUSH DEST COUNT [{}]", voteMaster.getVoteSeq(), pushDestList.size());

                    } else {
                        logger.info("### voteEndSchedule :: pushDestList is NULL");
                    }

                }

            } else {
                logger.info("### voteEndSchedule :: NULL");
            }

        } catch (Exception e) {
            logger.error("########## voteEndSchedule ERROR ##########", e);
        }

    }

    private void cmitStartSchedule() {

        try {

            Config config = null;
            List<String> pushDestList = null;
            GcmInfo gcmInfo = null;

            List<Map<String, Object>> cmitStartSchedule = committeeService.selectCmitPssrpStartSchedule();

            if (cmitStartSchedule != null && !cmitStartSchedule.isEmpty()) {

                String title = null;
                String strStartDate = null;
                String strEndDate = null;

                for (Map<String, Object> map : cmitStartSchedule) {

                    config = new Config();
                    config.setSiteCd((String) map.get("site_cd"));
                    config.setUserStat(UserStatus.AVAILABLE);
                    config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                    config.setConfigCode(ConfigType.CONFIG_PUSH_NEW.getCode());     // 새글알림 (::: 위원공모 알림 설정은 없음)

                    pushDestList = configService.selectPushKeyList(config);

                    if (pushDestList != null && !pushDestList.isEmpty()) {

                        title = (String) map.get("title");
                        strStartDate = (String) map.get("start_date");
                        strEndDate = (String) map.get("end_date");

                        gcmInfo = new GcmInfo();
                        gcmInfo.setGcmType(GcmType.CMIT_PSSRP);
                        // push.cmit.pssrp=은평구 주민참여예산 위원공모\n{0}\n{1}~{2}
                        gcmInfo.setPushMessage(messages.getMessage("push.cmit.pssrp", title, strStartDate, strEndDate));
                        //gcmInfo.setReturnUrl(serviceSiteUrl + "/cmit/cmit_contest_req");
                        gcmInfo.setArgs(null);

                        gcmService.send(gcmInfo, pushDestList, ConfigType.CONFIG_PUSH_NEW.getCode());

                        logger.info("### cmitStartSchedule :: PS_SEQ [{}], PUSH DEST COUNT [{}]", map.get("ps_seq"), pushDestList.size());

                    } else {
                        logger.info("### cmitStartSchedule :: pushDestList is NULL");
                    }

                }

            } else {
                logger.info("### cmitStartSchedule :: NULL");
            }

        } catch (Exception e) {
            logger.error("########## cmitStartSchedule ERROR ##########", e);
        }

    }
}
