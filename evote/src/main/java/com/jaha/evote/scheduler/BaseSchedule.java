/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

import com.jaha.evote.common.util.StringUtils;

/**
 * <pre>
 * Class Name : BaseSchedule.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 23.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 23.
 * @version 1.0
 */
public abstract class BaseSchedule {

    protected final Logger logger = LoggerFactory.getLogger(getClass());

    @Value("#{systemProperties['spring.profiles.active']}")
    private String springProfilesActive;

    @Value("#{systemProperties['server.name']}")
    private String systemServerName;

    @Value("${schedule.server.name}")
    private String scheduleServerName;

    protected boolean isScheduleServer() {

        //        logger.debug("### springProfilesActive :: [{}]", springProfilesActive);
        //        logger.debug("### systemServerName :: [{}]", systemServerName);
        //        logger.debug("### scheduleServerName :: [{}]", scheduleServerName);

        if ("real".equals(springProfilesActive)) {
            if (StringUtils.isNotEmpty(systemServerName) && StringUtils.isNotEmpty(scheduleServerName) && StringUtils.equals(systemServerName, scheduleServerName)) {
                return true;
            }
            return false;
        } else {
            return true;
        }

    }

}
