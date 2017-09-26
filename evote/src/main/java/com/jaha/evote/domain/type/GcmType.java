/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : GcmType.java
 * Description : GCM Type
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 7.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 7.
 * @version 1.0
 */
public enum GcmType implements Serializable {

    /** 게시판 */
    BOARD,

    /** 정책제안 */
    PROPOSAL,

    /** 정책제안댓글 */
    PROP_CMT,

    /** 위원공모 */
    CMIT_PSSRP,

    /** 투표독려 */
    VOTE_URGE,

    /** 투표마감 */
    VOTE_CLOSE,

}
